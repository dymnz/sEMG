// Modified from the following:
// MPU-6050 Short Example Sketch
// By Arduino User JohnChi
// August 17, 2014
// Public Domain

#include<Wire.h>
#define REG_ADDR 0x3D
#define MV_SIZE 20
#define WAIT_SAMPLE 10
#define DELAY_MS 50
#define MAX_ANGLE 180
#define MIN_ANGLE 0
#define MAX_VALUE 32768.0 // 2^16

int read_y(void);

const int MPU_addr = 0x68;  // I2C address of the MPU-6050
char buffer[100];
int mv_array[MV_SIZE];
int8_t pointer = 0;
float moving_sum = 0;
int moving_average = 0.0;
int moving_diff = 0;
int estimate_angle = 0;
int initial_value = 0;



void setup() {
  Wire.begin();
  Wire.beginTransmission(MPU_addr);
  Wire.write(0x6B);  // PWR_MGMT_1 register
  Wire.write(0);     // set to zero (wakes up the MPU-6050)
  Wire.endTransmission(true);
  Serial.begin(115200);
  
  Serial.println("Waiting for MPU to stablize...");
  for (uint8_t i = 0; i < WAIT_SAMPLE; i++) {
    read_y();
    delay(DELAY_MS);
  }
  
  Serial.println("Getting initial value...");
  for (uint8_t i = 0; i < MV_SIZE; i++) {
    mv_array[i] = read_y();
    moving_sum += mv_array[i];
    delay(DELAY_MS);
  }

  moving_average = moving_sum / MV_SIZE;
  initial_value = moving_average;
  sprintf(buffer, "Initial value: %d\n", initial_value);
  Serial.print(buffer);
  
}

void loop() {
  
  while (true) {
    mv_array[pointer] = read_y();

    moving_sum = 0;
    for (uint8_t i = 0; i < MV_SIZE; i++) {
      moving_sum += mv_array[pointer];
    }
    moving_average = moving_sum / MV_SIZE;

    moving_diff = initial_value - moving_average;
    estimate_angle = ((float)moving_diff / MAX_VALUE) * (MAX_ANGLE - MIN_ANGLE) + MIN_ANGLE;
    Serial.println(estimate_angle);

    pointer = (pointer+1) % MV_SIZE;

    delay(DELAY_MS);  
  } 
}


int read_y(void) {

  Wire.beginTransmission(MPU_addr);
  Wire.write(REG_ADDR);  // starting with register 0x3D (ACCEL_YOUT_H)
  Wire.endTransmission(false);
  Wire.requestFrom(MPU_addr, 2, true);  // request a total of 2 registers 
  return (int) (Wire.read()<<8 | Wire.read());  // 0x3D (ACCEL_YOUT_H) & 0x3E (ACCEL_YOUT_L)
}

