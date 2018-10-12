/* MPU9250_MS5637_t3 Basic Example Code
 by: Kris Winer
 date: April 1, 2014
 license: Beerware - Use this code however you'd like. If you
 find it useful you can buy me a beer some time.
 */
#include <i2c_t3.h>
#include <SPI.h>
#include "common.h"

#define VerboseSerialDebug false  // set to true to get Serial output for debugging

// Specify sensor full scale
uint8_t Gscale = GFS_250DPS;
uint8_t Ascale = AFS_2G;
uint8_t Mscale = MFS_16BITS; // Choose either 14-bit or 16-bit magnetometer resolution
uint8_t Mmode = 0x06;        // 2 for 8 Hz, 6 for 100 Hz continuous magnetometer data read
float aRes, gRes, mRes;      // scale resolutions per LSB for the sensors

// Pin definitions
int intPin = 8;
volatile bool newData = false;
bool newMagData = false;

int16_t MPU9250Data[7]; // used to read all 14 bytes at once from the MPU9250 accel/gyro
int16_t accelCount[3];  // Stores the 16-bit signed accelerometer sensor output
int16_t gyroCount[3];   // Stores the 16-bit signed gyro sensor output
int16_t magCount[3];    // Stores the 16-bit signed magnetometer sensor output
float magCalibration[3] = {0, 0, 0};  // Factory mag calibration and mag bias
float gyroBias[3] = {0, 0, 0}, accelBias[3] = {0, 0, 0}, magBias[3] = {0, 0, 0}, magScale[3]  = {0, 0, 0};      // Bias corrections for gyro and accelerometer
int16_t tempCount;            // temperature raw count output
float   temperature;          // Stores the MPU9250 gyro internal chip temperature in degrees Celsius
double Temperature, Pressure; // stores MS5637 pressures sensor pressure and temperature
float SelfTest[6];            // holds results of gyro and accelerometer self test

// global constants for 9 DoF fusion and AHRS (Attitude and Heading Reference System)
float GyroMeasError = PI * (20.0f / 180.0f);   // gyroscope measurement error in rads/s (start at 40 deg/s)
float GyroMeasDrift = PI * (0.0f  / 180.0f);   // gyroscope measurement drift in rad/s/s (start at 0.0 deg/s/s)
// There is a tradeoff in the beta parameter between accuracy and response speed.
// In the original Madgwick study, beta of 0.041 (corresponding to GyroMeasError of 2.7 degrees/s) was found to give optimal accuracy.
// However, with this value, the LSM9SD0 response time is about 10 seconds to a stable initial quaternion.
// Subsequent changes also require a longish lag time to a stable output, not fast enough for a quadcopter or robot car!
// By increasing beta (GyroMeasError) by about a factor of fifteen, the response time constant is reduced to ~2 sec
// I haven't noticed any reduction in solution accuracy. This is essentially the I coefficient in a PID control sense;
// the bigger the feedback coefficient, the faster the solution converges, usually at the expense of accuracy.
// In any case, this is the free parameter in the Madgwick filtering and fusion scheme.
float beta = sqrt(3.0f / 4.0f) * GyroMeasError;   // compute beta
float zeta = sqrt(3.0f / 4.0f) * GyroMeasDrift;   // compute zeta, the other free parameter in the Madgwick scheme usually set to a small or zero value
#define Kp 2.0f * 5.0f // these are the free parameters in the Mahony filter and fusion scheme, Kp for proportional feedback, Ki for integral
#define Ki 0.0f

float pitch, yaw, roll;                   // range = [-180 +180] [-180 +180] [-180 +180]
float a12, a22, a31, a32, a33;            // rotation matrix coefficients for Euler angles and gravity components
float deltat = 0.0f, sum = 0.0f;          // integration interval for both filter schemes
uint32_t lastUpdate = 0, firstUpdate = 0; // used to calculate integration interval
uint32_t Now = 0;                         // used to calculate integration interval

float ax, ay, az, gx, gy, gz, mx, my, mz; // variables to hold latest sensor data values
float lin_ax, lin_ay, lin_az;             // falselinear acceleration (acceleration with gravity component subtracted)
float q[4] = {1.0f, 0.0f, 0.0f, 0.0f};    // vector to hold quaternion
float eInt[3] = {0.0f, 0.0f, 0.0f};       // vector to hold integral error for Mahony method

const uint32_t expected_mpu_report_rate = 500;
const uint32_t mpu_report_interval_us = (uint32_t) (1000000 / expected_mpu_report_rate);
bool mpu_data_ready = false;
uint32_t mpu_delta_t = 0;
uint32_t mpu_last_t = 0;


const uint32_t expected_semg_report_rate = 3000;
const uint32_t semg_report_interval_us = (uint32_t) (1000000 / expected_semg_report_rate);
bool semg_data_ready = false;
uint32_t semg_delta_t = 0;
uint32_t semg_last_t = 0;

const int alignment_packet_len = 1;

const int semg_channel = 6;
const int semg_packet_byte = 2;
const int semg_packet_len = alignment_packet_len + semg_channel * semg_packet_byte;

const int mpu_channel = 4;
const int mpu_packet_byte = 4;  // float 4-byte
const int mpu_packet_len = alignment_packet_len + mpu_channel * mpu_packet_byte;

uint8_t semg_packet[semg_packet_len] = {'$'};
uint8_t mpu_packet[mpu_packet_len] = {'@'};

typedef uint8_t indexType; // !!!!!!! WORKS WHEN MV_SIZE < 255 !!!!!!!


void setup()
{

  // Setup for Master mode, pins 16/17, external pullups, 400kHz for Teensy 3.1
  Wire.begin(I2C_MASTER, 0x00, I2C_PINS_16_17, I2C_PULLUP_INT, I2C_RATE_400);
  Serial.begin(0);
  while (!Serial);

  // For sEMG ADC
  analogReadResolution(12);
  //analogReference(INTERNAL);
 

  // Set up the interrupt pin, its set as active high, push-pull
  pinMode(intPin, INPUT);


  // Read the WHO_AM_I register, this is a good test of communication
  byte c = readByte(MPU9250_ADDRESS, WHO_AM_I_MPU9250);  // Read WHO_AM_I register for MPU-9250
  
  if (c == 0x71) // WHO_AM_I should always be 0x68
  {
    MPU9250SelfTest(SelfTest); // Start by performing self test and reporting values
    delay(1000);

    // get sensor resolutions, only need to do this once
    getAres();
    getGres();
    getMres();

    accelgyrocalMPU9250(gyroBias, accelBias); // Calibrate gyro and accelerometers, load biases in bias registers
    initMPU9250();

    // Read the WHO_AM_I register of the magnetometer, this is a good test of communication
    byte d = readByte(AK8963_ADDRESS, AK8963_WHO_AM_I);  // Read WHO_AM_I register for AK8963

    // Get magnetometer calibration from AK8963 ROM
    initAK8963(magCalibration);
    /*
    magcalMPU9250(magBias, magScale);
    Serial.println("AK8963 mag biases (mG)"); Serial.println(magBias[0], 10); Serial.println(magBias[1], 10); Serial.println(magBias[2], 10);
    Serial.println("AK8963 mag scale (mG)"); Serial.println(magScale[0], 10); Serial.println(magScale[1], 10); Serial.println(magScale[2], 10);
    delay(10000); // add delay to see results before Serial.spew of data
    */
    magcalMPU9250_fixed_value(magBias, magScale); 


    attachInterrupt(intPin, myinthandler, RISING);  // define interrupt for INT pin output of MPU9250

  }
  else
  {
    Serial.print("Could not connect to MPU9250: 0x");
    Serial.println(c, HEX);
    while (1); // Loop forever if communication doesn't happen
  }
}

void loop()
{ 
  //try_read_and_send_semg(); // Rate limited send
  read_and_send_semg(); // Send whenever

  if (newData == true) {
    newData = false;  // reset newData flag
    update_mpu_data();
  }

  update_mpu_filter();

  if (mpu_data_ready == true) {
    send_mpu();
    mpu_data_ready = false;
  }
}


// A6-9 = Pin18-23
void try_read_and_send_semg()
{
  semg_delta_t = micros() - semg_last_t;
  if (semg_delta_t > semg_report_interval_us) {
#if VerboseSerialDebug
    SerialUSB.print("18/19/20/21/22/23: "); 
    SerialUSB.print(analogRead(A4)); SerialUSB.print("/"); 
    SerialUSB.print(analogRead(A5)); SerialUSB.print("/"); 
    SerialUSB.print(analogRead(A6)); SerialUSB.print("/"); 
    SerialUSB.print(analogRead(A7)); SerialUSB.print("/"); 
    SerialUSB.print(analogRead(A8)); SerialUSB.print("/"); 
    SerialUSB.println(analogRead(A9));
#else
    ((uint16_t *)(semg_packet + alignment_packet_len))[0] = analogRead(A4);
    ((uint16_t *)(semg_packet + alignment_packet_len))[1] = analogRead(A5);
    ((uint16_t *)(semg_packet + alignment_packet_len))[2] = analogRead(A6);
    ((uint16_t *)(semg_packet + alignment_packet_len))[3] = analogRead(A7);               
    ((uint16_t *)(semg_packet + alignment_packet_len))[4] = analogRead(A8);
    ((uint16_t *)(semg_packet + alignment_packet_len))[5] = analogRead(A9); 
    SerialUSB.write(semg_packet, semg_packet_len);
#endif
    semg_last_t = micros();
  }
}

void read_and_send_semg()
{
  // A6-9 = Pin20-23
#if VerboseSerialDebug
    SerialUSB.print("18/19/20/21/22/23: "); 
    SerialUSB.print(analogRead(A4)); SerialUSB.print("/"); 
    SerialUSB.print(analogRead(A5)); SerialUSB.print("/"); 
    SerialUSB.print(analogRead(A6)); SerialUSB.print("/"); 
    SerialUSB.print(analogRead(A7)); SerialUSB.print("/"); 
    SerialUSB.print(analogRead(A8)); SerialUSB.print("/"); 
    SerialUSB.println(analogRead(A9));
#else
    ((uint16_t *)(semg_packet + alignment_packet_len))[0] = analogRead(A4);
    ((uint16_t *)(semg_packet + alignment_packet_len))[1] = analogRead(A5);
    ((uint16_t *)(semg_packet + alignment_packet_len))[2] = analogRead(A6);
    ((uint16_t *)(semg_packet + alignment_packet_len))[3] = analogRead(A7);               
    ((uint16_t *)(semg_packet + alignment_packet_len))[4] = analogRead(A8);
    ((uint16_t *)(semg_packet + alignment_packet_len))[5] = analogRead(A9); 
    SerialUSB.write(semg_packet, semg_packet_len);
#endif
}

void update_mpu_data()
{
  readMPU9250Data(MPU9250Data); // INT cleared on any read

  // Now we'll calculate the accleration value into actual g's
  ax = (float)MPU9250Data[0] * aRes - accelBias[0]; // get actual g value, this depends on scale being set
  ay = (float)MPU9250Data[1] * aRes - accelBias[1];
  az = (float)MPU9250Data[2] * aRes - accelBias[2];

  // Calculate the gyro value into actual degrees per second
  gx = (float)MPU9250Data[4] * gRes; // get actual gyro value, this depends on scale being set
  gy = (float)MPU9250Data[5] * gRes;
  gz = (float)MPU9250Data[6] * gRes;

  readMagData(magCount);  // Read the x/y/z adc values

  // Calculate the magnetometer values in milliGauss
  // Include factory calibration per data sheet and user environmental corrections
  if (newMagData == true) {
    newMagData = false; // reset newMagData flag
    mx = (float)magCount[0] * mRes * magCalibration[0] - magBias[0]; // get actual magnetometer value, this depends on scale being set
    my = (float)magCount[1] * mRes * magCalibration[1] - magBias[1];
    mz = (float)magCount[2] * mRes * magCalibration[2] - magBias[2];
    mx *= magScale[0];
    my *= magScale[1];
    mz *= magScale[2];
  }
}

void update_mpu_filter()
{
  Now = micros();
  deltat = ((Now - lastUpdate) / 1000000.0f); // set integration time by time elapsed since last filter update
  lastUpdate = Now;

  MadgwickQuaternionUpdate(-ax, ay, az, gx * PI / 180.0f, -gy * PI / 180.0f, -gz * PI / 180.0f,  my,  -mx, mz);
  
  // Serial.print and/or display at 0.5 s rate independent of data rates
  mpu_delta_t = micros() - mpu_last_t;
  if (mpu_delta_t > mpu_report_interval_us) { // update LCD once per half-second independent of read rate

    mpu_data_ready = true;    
    mpu_last_t = micros();
  }
}

void send_mpu()
{
  
#if VerboseSerialDebug
  SerialUSB.print("Roll/Pitch/Yaw: "); 
  SerialUSB.print(roll); SerialUSB.print("/"); 
  SerialUSB.print(pitch); SerialUSB.print("/"); 
  SerialUSB.println(yaw);
#else
  // Send Roll/Pitch/Yaw
  ((float *)(mpu_packet + alignment_packet_len))[0] = (float) q[0];
  ((float *)(mpu_packet + alignment_packet_len))[1] = (float) q[1];
  ((float *)(mpu_packet + alignment_packet_len))[2] = (float) q[2];
  ((float *)(mpu_packet + alignment_packet_len))[3] = (float) q[3];
  SerialUSB.write(mpu_packet, mpu_packet_len);
#endif
}
    

