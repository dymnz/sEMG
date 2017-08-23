#include <Wire.h>
#include <Math.h>

#define ACCE_REG_ADDR 0x3B
#define MV_SIZE 20
#define WAIT_SAMPLE 10
#define DELAY_MS 5
#define MAX_ANGLE 180
#define MIN_ANGLE 0
#define MAX_VALUE 32768.0 // 2^16

typedef uint8_t indexType; // !!!!!!! WORKS WHEN MV_SIZE < 255 !!!!!!!

char buffer[100];
int mv_arrayX[MV_SIZE];
int mv_arrayY[MV_SIZE];

struct MPUData{ 
  int addr;
  indexType pointer = 0;       
  int16_t x_array[MV_SIZE];
  int16_t y_array[MV_SIZE];
  int16_t z_array[MV_SIZE];  
  int16_t offset_array[3]; 
  float average_array[3];
  float roll_pitch[2];
} mpu_1, mpu_2;

void setup() {
  Serial.begin(115200);

  // Set address
  mpu_1.addr = 0x68;
  mpu_2.addr = 0x69;  // AD0 pulled high

  // Init MPUs
  initMPU(&mpu_1);
  initMPU(&mpu_2);

  // Set offsets
  int16_t offset_1[3] = {192, 516, -1993};
  int16_t offset_2[3] = {673, 223, 642};
  memcpy(mpu_1.offset_array, offset_1, sizeof offset_1);
  memcpy(mpu_2.offset_array, offset_2, sizeof offset_2);
  
  // Read some samples
  Serial.println("Waiting for MPU to stablize...");
  for (indexType i = 0; i < WAIT_SAMPLE; i++) {
    readOnce(&mpu_1);
    readOnce(&mpu_2);
    delay(DELAY_MS);
  }

  // Gather initial value
  Serial.println("Getting initial value...");
  for (indexType i = 0; i < MV_SIZE; i++) {
    readOnce(&mpu_1);
    readOnce(&mpu_2);       
    delay(DELAY_MS);
  }
  
  calculateAverage(&mpu_1);
  calculateAverage(&mpu_2);
  
  sprintf(buffer, "Initial value 1: %6d %6d %6d\n", mpu_1.average_array[0], mpu_1.average_array[1], mpu_1.average_array[2]);  
  Serial.print(buffer);
  sprintf(buffer, "Initial value 2: %6d %6d %6d\n", mpu_2.average_array[0], mpu_2.average_array[1], mpu_2.average_array[2]);
  Serial.print(buffer);

  //while (true);
}

void loop() {

  int  x = 0;
  while (true) {    
    readOnce(&mpu_1);
    readOnce(&mpu_2); 
    calculateAverage(&mpu_1);
    calculateAverage(&mpu_2);
    calculateOrientation(&mpu_1);
    calculateOrientation(&mpu_2);
    
    if (mpu_1.pointer == 0) {
      int elbow_angle = 360 - (180 + mpu_1.roll_pitch[0] - mpu_2.roll_pitch[0]);
      //sprintf(buffer, "%6d %6d\n", (int)mpu_1.roll_pitch[0], (int)mpu_1.roll_pitch[1]);      
      //sprintf(buffer,
      //  "%6d %6d %6d %6d %6d\n", 
      //  elbow_angle, 
      //  (int)mpu_1.roll_pitch[0],
      //  (int)mpu_1.roll_pitch[1],
      //  (int)mpu_2.roll_pitch[0],
      //  (int)mpu_2.roll_pitch[1]);      
      //Serial.print(buffer);      
      Serial.println(elbow_angle);
    }
    delay(DELAY_MS);             
  }   
}

void initMPU(struct MPUData *mpu) {
  Wire.beginTransmission(mpu->addr);
  Wire.write(0x6B);  // PWR_MGMT_1 register
  Wire.write(0);     // set to zero (wakes up the MPU-6050)
  Wire.endTransmission(true);  
}

int readOnce(struct MPUData *mpu) {
  Wire.beginTransmission(mpu->addr);
  Wire.write(ACCE_REG_ADDR);  // starting with register 0x3D (ACCEL_YOUT_H)
  Wire.endTransmission(false);
  Wire.requestFrom(mpu->addr, 6, true);  // request a total of 6 registers 
  
  mpu->x_array[mpu->pointer] = Wire.read()<<8|Wire.read();  // 0x3B (ACCEL_XOUT_H) & 0x3C (ACCEL_XOUT_L)    
  mpu->y_array[mpu->pointer] = Wire.read()<<8|Wire.read();  // 0x3D (ACCEL_YOUT_H) & 0x3E (ACCEL_YOUT_L)
  mpu->z_array[mpu->pointer] = Wire.read()<<8|Wire.read();  // 0x3F (ACCEL_ZOUT_H) & 0x40 (ACCEL_ZOUT_L)

  mpu->pointer = (mpu->pointer + 1) % MV_SIZE;
}

int calculateAverage(struct MPUData *mpu) {
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


int calculateOrientation(struct MPUData *mpu) {
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

