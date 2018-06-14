/* MPU9250_MS5637_t3 Basic Example Code
 by: Kris Winer
 date: April 1, 2014
 license: Beerware - Use this code however you'd like. If you
 find it useful you can buy me a beer some time.
 */
#include "Wire.h"
#include <SPI.h>
#include "common.h"

#define SerialDebug true  // set to true to get Serial output for debugging

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
float GyroMeasError = PI * (4.0f / 180.0f);   // gyroscope measurement error in rads/s (start at 40 deg/s)
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

uint32_t delt_t = 0, count = 0, sumCount = 0;  // used to control display output rate
float pitch, yaw, roll;
float a12, a22, a31, a32, a33;            // rotation matrix coefficients for Euler angles and gravity components
float deltat = 0.0f, sum = 0.0f;          // integration interval for both filter schemes
uint32_t lastUpdate = 0, firstUpdate = 0; // used to calculate integration interval
uint32_t Now = 0;                         // used to calculate integration interval

float ax, ay, az, gx, gy, gz, mx, my, mz; // variables to hold latest sensor data values
float lin_ax, lin_ay, lin_az;             // linear acceleration (acceleration with gravity component subtracted)
float q[4] = {1.0f, 0.0f, 0.0f, 0.0f};    // vector to hold quaternion
float eInt[3] = {0.0f, 0.0f, 0.0f};       // vector to hold integral error for Mahony method


void setup()
{
  Wire.begin();
//  TWBR = 12;  // 400 kbit/sec I2C speed for Pro Mini
  // Setup for Master mode, pins 18/19, external pullups, 400kHz for Teensy 3.1
//  Wire.begin(I2C_MASTER, 0x00, I2C_PINS_16_17, I2C_PULLUP_EXT, I2C_RATE_400);
  delay(4000);
  SerialUSB.begin(0);
  while (!SerialUSB);
  
  SerialUSB.println("MPU9250 9-axis motion sensor...");
  
  // Set up the interrupt pin, its set as active high, push-pull
  pinMode(intPin, INPUT);

  SerialUSB.println("MPU9250 9-axis motion sensor...");


  // Read the WHO_AM_I register, this is a good test of communication
  SerialUSB.println("MPU9250 9-axis motion sensor...");
  byte c = readByte(MPU9250_ADDRESS, WHO_AM_I_MPU9250);  // Read WHO_AM_I register for MPU-9250
  SerialUSB.print("MPU9250 "); SerialUSB.print("I AM "); SerialUSB.print(c, HEX); SerialUSB.print(" I should be "); SerialUSB.println(0x71, HEX);

  if (c == 0x71) // WHO_AM_I should always be 0x68
  {
    SerialUSB.println("MPU9250 is online...");

    MPU9250SelfTest(SelfTest); // Start by performing self test and reporting values
    SerialUSB.print("x-axis self test: acceleration trim within : "); SerialUSB.print(SelfTest[0], 1); SerialUSB.println("% of factory value");
    SerialUSB.print("y-axis self test: acceleration trim within : "); SerialUSB.print(SelfTest[1], 1); SerialUSB.println("% of factory value");
    SerialUSB.print("z-axis self test: acceleration trim within : "); SerialUSB.print(SelfTest[2], 1); SerialUSB.println("% of factory value");
    SerialUSB.print("x-axis self test: gyration trim within : "); SerialUSB.print(SelfTest[3], 1); SerialUSB.println("% of factory value");
    SerialUSB.print("y-axis self test: gyration trim within : "); SerialUSB.print(SelfTest[4], 1); SerialUSB.println("% of factory value");
    SerialUSB.print("z-axis self test: gyration trim within : "); SerialUSB.print(SelfTest[5], 1); SerialUSB.println("% of factory value");
    delay(1000);

    // get sensor resolutions, only need to do this once
    getAres();
    getGres();
    getMres();

    SerialUSB.println(" Calibrate gyro and accel");
    accelgyrocalMPU9250(gyroBias, accelBias); // Calibrate gyro and accelerometers, load biases in bias registers
    SerialUSB.println("accel biases (mg)"); SerialUSB.println(1000.*accelBias[0]); SerialUSB.println(1000.*accelBias[1]); SerialUSB.println(1000.*accelBias[2]);
    SerialUSB.println("gyro biases (dps)"); SerialUSB.println(gyroBias[0]); SerialUSB.println(gyroBias[1]); SerialUSB.println(gyroBias[2]);

    initMPU9250();
    SerialUSB.println("MPU9250 initialized for active data mode...."); // Initialize device for active mode read of acclerometer, gyroscope, and temperature

    // Read the WHO_AM_I register of the magnetometer, this is a good test of communication
    byte d = readByte(AK8963_ADDRESS, AK8963_WHO_AM_I);  // Read WHO_AM_I register for AK8963
    SerialUSB.print("AK8963 "); SerialUSB.print("I AM "); SerialUSB.print(d, HEX); SerialUSB.print(" I should be "); SerialUSB.println(0x48, HEX);


    // Get magnetometer calibration from AK8963 ROM
    initAK8963(magCalibration); SerialUSB.println("AK8963 initialized for active data mode...."); // Initialize device for active mode read of magnetometer


    // Don't use online calibration, use value from 'MPU9250_mag_cal'
    //magcalMPU9250(magBias, magScale);
    magBias[0] = 126.0  * mRes * magCalibration[0]; // save mag biases in G for main program
    magBias[1] = 33.0   * mRes * magCalibration[1];
    magBias[2] = -86.0  * mRes * magCalibration[2];
    magScale[0] = 1.0286195;
    magScale[1] = 0.983897;
    magScale[2] = 0.98867315;
    
    SerialUSB.println("AK8963 mag biases (mG)"); SerialUSB.println(magBias[0]); SerialUSB.println(magBias[1]); SerialUSB.println(magBias[2]);
    SerialUSB.println("AK8963 mag scale (mG)"); SerialUSB.println(magScale[0]); SerialUSB.println(magScale[1]); SerialUSB.println(magScale[2]);
    delay(2000); // add delay to see results before SerialUSB.spew of data

    if (SerialDebug) {
//  SerialUSB.println("Calibration values: ");
      SerialUSB.print("X-Axis sensitivity adjustment value "); SerialUSB.println(magCalibration[0], 2);
      SerialUSB.print("Y-Axis sensitivity adjustment value "); SerialUSB.println(magCalibration[1], 2);
      SerialUSB.print("Z-Axis sensitivity adjustment value "); SerialUSB.println(magCalibration[2], 2);
    }

    attachInterrupt(intPin, myinthandler, RISING);  // define interrupt for INT pin output of MPU9250

  }
  else
  {
    SerialUSB.print("Could not connect to MPU9250: 0x");
    SerialUSB.println(c, HEX);
    while (1) ; // Loop forever if communication doesn't happen
  }
}

void loop()
{
  // Workaround to not use INT
  //if (readByte(MPU9250_ADDRESS, DMP_INT_STATUS) & 0x01)
  //  newData = true;
    
  // If intPin goes high, all data registers have new data 
  if (newData == true) { // On interrupt, read data
    newData = false;  // reset newData flag
    readMPU9250Data(MPU9250Data); // INT cleared on any read
//   readAccelData(accelCount);  // Read the x/y/z adc values

    // Now we'll calculate the accleration value into actual g's
    ax = (float)MPU9250Data[0] * aRes - accelBias[0]; // get actual g value, this depends on scale being set
    ay = (float)MPU9250Data[1] * aRes - accelBias[1];
    az = (float)MPU9250Data[2] * aRes - accelBias[2];

//   readGyroData(gyroCount);  // Read the x/y/z adc values

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

  Now = micros();
  deltat = ((Now - lastUpdate) / 1000000.0f); // set integration time by time elapsed since last filter update
  lastUpdate = Now;

  sum += deltat; // sum for averaging filter update rate
  sumCount++;

  // Sensors x (y)-axis of the accelerometer/gyro is aligned with the y (x)-axis of the magnetometer;
  // the magnetometer z-axis (+ down) is misaligned with z-axis (+ up) of accelerometer and gyro!
  // We have to make some allowance for this orientation mismatch in feeding the output to the quaternion filter.
  // For the MPU9250+MS5637 Mini breakout the +x accel/gyro is North, then -y accel/gyro is East. So if we want te quaternions properly aligned
  // we need to feed into the Madgwick function Ax, -Ay, -Az, Gx, -Gy, -Gz, My, -Mx, and Mz. But because gravity is by convention
  // positive down, we need to invert the accel data, so we pass -Ax, Ay, Az, Gx, -Gy, -Gz, My, -Mx, and Mz into the Madgwick
  // function to get North along the accel +x-axis, East along the accel -y-axis, and Down along the accel -z-axis.
  // This orientation choice can be modified to allow any convenient (non-NED) orientation convention.
  // Pass gyro rate as rad/s
  //MadgwickQuaternionUpdate(-ax, ay, az, gx * PI / 180.0f, -gy * PI / 180.0f, -gz * PI / 180.0f,  my,  -mx, mz);
  MadgwickQuaternionUpdate(ay, ax, -az, gy * PI / 180.0f, gx * PI / 180.0f, -gz * PI / 180.0f,  mx,  my, mz);
//  if(passThru)MahonyQuaternionUpdate(-ax, ay, az, gx*PI/180.0f, -gy*PI/180.0f, -gz*PI/180.0f,  my,  -mx, mz);

  // SerialUSB.print and/or display at 0.5 s rate independent of data rates
  delt_t = millis() - count;
  if (delt_t > 500) { // update LCD once per half-second independent of read rate

  /*
    if (SerialDebug) {
      SerialUSB.print("ax = "); SerialUSB.print((int)1000 * ax);
      SerialUSB.print(" ay = "); SerialUSB.print((int)1000 * ay);
      SerialUSB.print(" az = "); SerialUSB.print((int)1000 * az); SerialUSB.println(" mg");
      SerialUSB.print("gx = "); SerialUSB.print( gx, 2);
      SerialUSB.print(" gy = "); SerialUSB.print( gy, 2);
      SerialUSB.print(" gz = "); SerialUSB.print( gz, 2); SerialUSB.println(" deg/s");
      SerialUSB.print("mx = "); SerialUSB.print( (int)mx );
      SerialUSB.print(" my = "); SerialUSB.print( (int)my );
      SerialUSB.print(" mz = "); SerialUSB.print( (int)mz ); SerialUSB.println(" mG");

      SerialUSB.print("q0 = "); SerialUSB.print(q[0]);
      SerialUSB.print(" qx = "); SerialUSB.print(q[1]);
      SerialUSB.print(" qy = "); SerialUSB.print(q[2]);
      SerialUSB.print(" qz = "); SerialUSB.println(q[3]);
    }
    */

    // Define output variables from updated quaternion---these are Tait-Bryan angles, commonly used in aircraft orientation.
    // In this coordinate system, the positive z-axis is down toward Earth.
    // Yaw is the angle between Sensor x-axis and Earth magnetic North (or true North if corrected for local declination, looking down on the sensor positive yaw is counterclockwise.
    // Pitch is angle between sensor x-axis and Earth ground plane, toward the Earth is positive, up toward the sky is negative.
    // Roll is angle between sensor y-axis and Earth ground plane, y-axis up is positive roll.
    // These arise from the definition of the homogeneous rotation matrix constructed from quaternions.
    // Tait-Bryan angles as well as Euler angles are non-commutative; that is, the get the correct orientation the rotations must be
    // applied in the correct order which for this configuration is yaw, pitch, and then roll.
    // For more see http://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles which has additional links.
    //Software AHRS:
//   yaw   = atan2f(2.0f * (q[1] * q[2] + q[0] * q[3]), q[0] * q[0] + q[1] * q[1] - q[2] * q[2] - q[3] * q[3]);
//   pitch = -asinf(2.0f * (q[1] * q[3] - q[0] * q[2]));
//   roll  = atan2f(2.0f * (q[0] * q[1] + q[2] * q[3]), q[0] * q[0] - q[1] * q[1] - q[2] * q[2] + q[3] * q[3]);
//   pitch *= 180.0f / PI;
//   yaw   *= 180.0f / PI;
//   yaw   += 13.8f; // Declination at Danville, California is 13 degrees 48 minutes and 47 seconds on 2014-04-04
//   if(yaw < 0) yaw   += 360.0f; // Ensure yaw stays between 0 and 360
//   roll  *= 180.0f / PI;
    a12 =   2.0f * (q[1] * q[2] + q[0] * q[3]);
    a22 =   q[0] * q[0] + q[1] * q[1] - q[2] * q[2] - q[3] * q[3];
    a31 =   2.0f * (q[0] * q[1] + q[2] * q[3]);
    a32 =   2.0f * (q[1] * q[3] - q[0] * q[2]);
    a33 =   q[0] * q[0] - q[1] * q[1] - q[2] * q[2] + q[3] * q[3];
    pitch = -asinf(a32);
    roll  = atan2f(a31, a33);
    yaw   = atan2f(a12, a22);
    pitch *= 180.0f / PI;
    yaw   *= 180.0f / PI;
    yaw   += 4.31f; // http://www.magnetic-declination.com/Myanmar/E-yaw/1625256.html#
    if (yaw < 0) yaw   += 360.0f; // Ensure yaw stays between 0 and 360
    roll  *= 180.0f / PI;
    lin_ax = ax + a31;
    lin_ay = ay + a32;
    lin_az = az - a33;
    if (SerialDebug) {
      SerialUSB.print("Yaw, Pitch, Roll: ");
      SerialUSB.print(yaw, 2);
      SerialUSB.print(", ");
      SerialUSB.print(pitch, 2);
      SerialUSB.print(", ");
      SerialUSB.println(roll, 2);

      SerialUSB.print("Grav_x, Grav_y, Grav_z: ");
      SerialUSB.print(-a31 * 1000, 2);
      SerialUSB.print(", ");
      SerialUSB.print(-a32 * 1000, 2);
      SerialUSB.print(", ");
      SerialUSB.print(a33 * 1000, 2);  SerialUSB.println(" mg");
      SerialUSB.print("Lin_ax, Lin_ay, Lin_az: ");
      SerialUSB.print(lin_ax * 1000, 2);
      SerialUSB.print(", ");
      SerialUSB.print(lin_ay * 1000, 2);
      SerialUSB.print(", ");
      SerialUSB.print(lin_az * 1000, 2);  SerialUSB.println(" mg");

      SerialUSB.print("rate = "); SerialUSB.print((float)sumCount / sum, 2); SerialUSB.println(" Hz");
    }

    count = millis();
    sumCount = 0;
    sum = 0;
  }

}

