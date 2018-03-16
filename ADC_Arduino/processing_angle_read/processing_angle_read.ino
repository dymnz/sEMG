#include <stdint.h>
#include "HX711.h"

#include <Wire.h>

#define DOUT  3
#define CLK  2

#define ACCE_REG_ADDR 0x3B
#define MV_SIZE 20
#define WAIT_SAMPLE 30
#define DELAY_MS 1
#define MAX_ANGLE 360
#define MIN_ANGLE 0
#define ANGLE_SHIFT 0
#define MAX_VALUE 65536.0 // 2^16 int_16

const int MaxSampleCount = 1000;

const int alignment_packet_len = 1;

const int semg_channel = 2;
const int semg_packet_byte = 2;
const int semg_packet_len = alignment_packet_len + semg_channel * semg_packet_byte;

const int force_channel = 1;
const int force_packet_byte = 4;
const int force_packet_len = alignment_packet_len + force_channel * force_packet_byte;

const int mpu_channel = 1;
const int mpu_packet_byte = 2;  // int8_t for +-128 degree
const int mpu_packet_len = alignment_packet_len + mpu_channel * mpu_packet_byte;

uint8_t semg_packet[semg_packet_len] = {'$'};
uint8_t force_packet[force_packet_len] = {'#'};
uint8_t mpu_packet[force_packet_len] = {'@'};

typedef uint8_t indexType; // !!!!!!! WORKS WHEN MV_SIZE < 255 !!!!!!!

struct MPUData{ 
  int addr;
  indexType pointer = 0;       
  int16_t x_array[MV_SIZE];
  int16_t y_array[MV_SIZE];
  int16_t z_array[MV_SIZE];  
  int16_t offset_array[3]; 
  float average_array[3];
  float roll_pitch[2];
} mpu_1;

int mpu_addr_1 = 0x68;
int16_t mpu_offset_1[3] = {192, 516, -1993};

// Loadcell
HX711 scale(DOUT, CLK);
long scale_offset;

void setup() {
  Wire.begin();
  SerialUSB.begin(0);
  while (!SerialUSB);

  AdcBooster();
  analogReadResolution(12);
  analogReference(AR_EXTERNAL);
 
  // Scale initialization
 // Scale_init();

  // MPU initialization
  mpu_1.addr = mpu_addr_1;    
  MPU_init(&mpu_1);
  memcpy(mpu_1.offset_array, mpu_offset_1, sizeof mpu_offset_1);
}


void loop() {
  int semg_value;
  
  while (1) {        
    // scale.read() returns 32bit signed int
    // If the scale is not ready, retain the old value
    ///*
    if (scale.is_ready()) {
      ((long *)(force_packet + alignment_packet_len))[0] = scale.read() - scale_offset;
      SerialUSB.write(force_packet, force_packet_len);
    }
    //*/

    // TODO: Check for MPU data availability before reading
    MPU_read(&mpu_1);
    MPU_calculateAverage(&mpu_1);
    MPU_calculateOrientation(&mpu_1);
    ((int16_t *)(mpu_packet + alignment_packet_len))[0] = (int16_t)mpu_1.roll_pitch[0];
    SerialUSB.write(mpu_packet, mpu_packet_len);
    //SerialUSB.println((int16_t)mpu_1.roll_pitch[0]);

    ///*
    semg_value = analogRead(A0);
    ((uint16_t *)(semg_packet + alignment_packet_len))[0] = semg_value;
    semg_value = analogRead(A1);
    ((uint16_t *)(semg_packet + alignment_packet_len))[1] = semg_value;        
    SerialUSB.write(semg_packet, semg_packet_len);
    //*/
  }
}

//https://forum.arduino.cc/index.php?topic=443173.0
void AdcBooster()
{
  ADC->CTRLA.bit.ENABLE = 0;                     // Disable ADC
  while ( ADC->STATUS.bit.SYNCBUSY == 1 );       // Wait for synchronization
  ADC->CTRLB.reg = ADC_CTRLB_PRESCALER_DIV128 |   // Divide Clock by N.
                   ADC_CTRLB_RESSEL_12BIT;       // Result on 12 bits
  ADC->AVGCTRL.reg = ADC_AVGCTRL_SAMPLENUM_1 |   // 1 sample
                     ADC_AVGCTRL_ADJRES(0x00ul); // Adjusting result by 0
  ADC->SAMPCTRL.reg = 0x00;                      // Sampling Time Length = 0
  ADC->CTRLA.bit.ENABLE = 1;                     // Enable ADC
  while ( ADC->STATUS.bit.SYNCBUSY == 1 );       // Wait for synchronization
}

void Scale_init() {
  scale.set_scale();
  scale.tare(); //Reset the scale to 0
  long zero_factor = scale.read_average(); //Get a baseli ne reading
  scale_offset = scale.get_offset();
}

void MPU_init(struct MPUData *mpu) {
  SerialUSB.println("MPU_init");
  Wire.beginTransmission(mpu->addr);
  Wire.write(0x6B);  // PWR_MGMT_1 register
  Wire.write(0);     // set to zero (wakes up the MPU-6050)
  Wire.endTransmission(true);  

  // Read some samples
  for (indexType i = 0; i < WAIT_SAMPLE; i++) {
    MPU_read(&mpu_1);    
    delay(DELAY_MS);
  }

  // Gather initial value
  for (indexType i = 0; i < MV_SIZE; i++) {
    MPU_read(&mpu_1); 
    //SerialUSB.println(MPU_calculateAverage(mpu));   
    delay(DELAY_MS);
  }  
  //SerialUSB.println("MPU_init");
  //while(1);
}


int MPU_read(struct MPUData *mpu) {
  Wire.beginTransmission(mpu->addr);
  Wire.write(ACCE_REG_ADDR);  // starting with register 0x3D (ACCEL_YOUT_H)
  Wire.endTransmission(false);
  Wire.requestFrom(mpu->addr, 6, true);  // request a total of 6 registers 
  
  mpu->x_array[mpu->pointer] = Wire.read()<<8|Wire.read();  // 0x3B (ACCEL_XOUT_H) & 0x3C (ACCEL_XOUT_L)    
  mpu->y_array[mpu->pointer] = Wire.read()<<8|Wire.read();  // 0x3D (ACCEL_YOUT_H) & 0x3E (ACCEL_YOUT_L)
  mpu->z_array[mpu->pointer] = Wire.read()<<8|Wire.read();  // 0x3F (ACCEL_ZOUT_H) & 0x40 (ACCEL_ZOUT_L)

  mpu->pointer = (mpu->pointer + 1) % MV_SIZE;
}

int MPU_calculateAverage(struct MPUData *mpu) {
  float sums[3] = {0, 0, 0};
  for (indexType i = 0; i < MV_SIZE; i++) {  
    sums[0] += mpu->x_array[i];
    sums[1] += mpu->y_array[i];
    sums[2] += mpu->z_array[i];
  }
  
  mpu->average_array[0] = (sums[0] / MV_SIZE) - mpu->offset_array[0];
  mpu->average_array[1] = (sums[1] / MV_SIZE) - mpu->offset_array[1];
  mpu->average_array[2] = (sums[2] / MV_SIZE) - mpu->offset_array[2];
}


int MPU_calculateOrientation(struct MPUData *mpu) {
  // https://stackoverflow.com/questions/3755059/3d-accelerometer-calculate-the-orientation
 
  float sign = mpu->average_array[2] > 0? 1.0 : -1.0;
  
  mpu->roll_pitch[0] = 
    atan2(
      mpu->average_array[1], 
      sign * sqrt(
        mpu->average_array[2]*mpu->average_array[2] 
        + 0.001 * mpu->average_array[0] * mpu->average_array[0])
    ) * 180.0 / PI;
  mpu->roll_pitch[1] = 
    atan2(
      mpu->average_array[0], 
      sqrt(
          mpu->average_array[1]*mpu->average_array[1] 
          + mpu->average_array[2]*mpu->average_array[2])
    ) * 180.0 / PI;    

  mpu->roll_pitch[0] = - mpu->roll_pitch[0];    
//  if (mpu->roll_pitch[0] > 180)
//    mpu->roll_pitch[0] -= 360;
}

