// Modified from the following:
// MPU-6050 Short Example Sketch
// By Arduino User JohnChi
// August 17, 2014
// Public Domain

#include<Wire.h>
#define REG_ADDR 0x3B
#define MV_SIZE 100
#define WAIT_SAMPLE 30
#define DELAY_MS 10
#define MAX_ANGLE 180
#define MIN_ANGLE 0
#define ANGLE_SHIFT 
#define MAX_VALUE 65536.0 // 2^16

int readX(void);

const int MPU_addrX = 0x68;  // I2C address of the MPU-6050
char buffer[100];
int mv_arrayX[MV_SIZE];
int8_t pointer = 0;
float moving_sumX = 0.0;
int moving_average = 0;
int moving_diff = 0;
int estimate_angleX = 0;
int initial_valueX = 0;


void setup() {
  Wire.begin();
  Wire.beginTransmission(MPU_addrX);
  Wire.write(0x6B);  // PWR_MGMT_1 register
  Wire.write(0);     // set to zero (wakes up the MPU-6050)
  Wire.endTransmission(true);
  
  SerialUSB.begin(115200);
  
  SerialUSB.println("Waiting for MPU to stablize...");

  for (uint8_t i = 0; i < WAIT_SAMPLE; i++) {
    readX();
    delay(DELAY_MS);
  }
  
  SerialUSB.println("Getting initial value...");
  for (uint8_t i = 0; i < MV_SIZE; i++) {
    mv_arrayX[i] = readX();
    moving_sumX += mv_arrayX[i];
    delay(DELAY_MS);
  }

  moving_average = moving_sumX / MV_SIZE;
  initial_valueX = moving_average;
  
  sprintf(buffer, "Initial value: %d\n", initial_valueX);
  SerialUSB.print(buffer);
}

void loop() {
  
  while (true) {
    mv_arrayX[pointer] = readX();
    
    moving_sumX = 0;
    for (uint8_t i = 0; i < MV_SIZE; i++) {
      moving_sumX += mv_arrayX[pointer];
    }
    
    moving_average = moving_sumX / MV_SIZE;
    moving_diff = initial_valueX - moving_average;
    estimate_angleX = ((float)moving_diff / MAX_VALUE) * (MAX_ANGLE - MIN_ANGLE) + MIN_ANGLE;
    
    //SerialUSB.println(moving_average);
    sprintf(buffer, "%4d", estimate_angleX);
    SerialUSB.println(buffer);    
    
    pointer = (pointer+1) % MV_SIZE;

    delay(DELAY_MS);  
  } 
}


int readX(void) {
  Wire.beginTransmission(MPU_addrX);
  Wire.write(REG_ADDR);  // starting with register 0x3D (ACCEL_YOUT_H)
  Wire.endTransmission(false);
  Wire.requestFrom(MPU_addrX, 2, true);  // request a total of 2 registers 
  return (int) (Wire.read()<<8 | Wire.read());  // 0x3D (ACCEL_YOUT_H) & 0x3E (ACCEL_YOUT_L)
}
   
