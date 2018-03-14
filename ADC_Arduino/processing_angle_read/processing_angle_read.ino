#include <stdint.h>
#include "HX711.h"

#include<Wire.h>

#define DOUT  3
#define CLK  2

#define REG_ADDR 0x3D // X: 3B Y: 3D
#define MV_SIZE 100
#define WAIT_SAMPLE 30
#define DELAY_MS 10
#define MAX_ANGLE 180
#define MIN_ANGLE 0
#define ANGLE_SHIFT 180
#define MAX_VALUE 32768.0 // 2^16 int_16

const int MaxSampleCount = 1000;

const int alignment_packet_len = 1;

const int semg_channel = 2;
const int semg_packet_byte = 2;
const int semg_packet_len = alignment_packet_len + semg_channel * semg_packet_byte;

const int force_channel = 1;
const int force_packet_byte = 4;
const int force_packet_len = alignment_packet_len + force_channel * force_packet_byte;

const int mpu_channel = 1;
const int mpu_packet_byte = 1;  // int8_t for +-128 degree
const int mpu_packet_len = alignment_packet_len + mpu_channel * mpu_packet_byte;

uint8_t semg_packet[semg_packet_len] = {'$'};
uint8_t force_packet[force_packet_len] = {'#'};
uint8_t mpu_packet[force_packet_len] = {'@'};

// Loadcell
HX711 scale(DOUT, CLK);
long scale_offset;

// sEMG
int semg_value;

// MPU
const int MPU_addr = 0x68;  // I2C address of the MPU-6050
int16_t mpu_buffer[MV_SIZE];
int8_t mpu_buffer_index = 0;
int mpu_initial_value = 0;
int estimated_angle = 0;

int readX(void);

void setup() {
  SerialUSB.begin(0);
  while (!SerialUSB);
  
  AdcBooster();
  analogReadResolution(12);
  analogReference(AR_EXTERNAL);
 
  // Scale initialization
  Scale_init();

  // MPU initialization
  MPU_init();
}


void loop() {  
  while (1) {        
    // scale.read() returns 32bit signed int
    // If the scale is not ready, retain the old value
    /*
    if (scale.is_ready()) {
      ((long *)(force_packet + alignment_packet_len))[0] = scale.read() - scale_offset;
      SerialUSB.write(force_packet, force_packet_len);
    }
    */

    // TODO: Check for MPU data availability before reading
    estimated_angle = MPU_read();
    ((int8_t *)(mpu_packet + alignment_packet_len))[0] = estimated_angle;
    SerialUSB.write(mpu_packet, mpu_packet_len);

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
  ADC->CTRLB.reg = ADC_CTRLB_PRESCALER_DIV512 |   // Divide Clock by N.
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

void MPU_init() {
  Wire.begin();
  Wire.beginTransmission(MPU_addr);
  Wire.write(0x6B);  // PWR_MGMT_1 register
  Wire.write(0);     // set to zero (wakes up the MPU-6050)
  Wire.endTransmission(true);
    
  float mpu_moving_sum = 0.0;
  
  for (uint8_t i = 0; i < WAIT_SAMPLE; i++) {
    MPU_readX();
    delay(DELAY_MS);
  }
  
  for (uint8_t i = 0; i < MV_SIZE; i++) {
    mpu_buffer[i] = MPU_readX();
    mpu_moving_sum += mpu_buffer[i];
    delay(DELAY_MS);
  }

  mpu_initial_value = mpu_moving_sum / MV_SIZE;
}

long MPU_read()
{
    int8_t estimated_angle = 0;
    float mpu_moving_sum = 0.0;
    int mpu_moving_average = 0;
    int mpu_moving_diff = 0;
    
    mpu_buffer[mpu_buffer_index] = MPU_readX();
    
    mpu_moving_sum = 0;
    for (uint8_t i = 0; i < MV_SIZE; i++) {
      mpu_moving_sum += mpu_buffer[i];
    }
    
    mpu_moving_average = mpu_moving_sum / MV_SIZE;
    mpu_moving_diff = mpu_initial_value - mpu_moving_average;
    estimated_angle = ((float)mpu_moving_diff / MAX_VALUE) * (MAX_ANGLE - MIN_ANGLE) + MIN_ANGLE + ANGLE_SHIFT; 
    
    mpu_buffer_index = (mpu_buffer_index+1) % MV_SIZE;
    
    return estimated_angle;
}

int MPU_readX(void) {
  Wire.beginTransmission(MPU_addr);
  Wire.write(REG_ADDR);  // starting with register 0x3B (ACCEL_XOUT_H)
  Wire.endTransmission(false);
  Wire.requestFrom(MPU_addr, 2, true);  // request a total of 2 registers 
  return  (int16_t)(Wire.read()<<8 | Wire.read());  // 0x3B (ACCEL_XOUT_H) & 0x3C (ACCEL_XOUT_L)
}
   
