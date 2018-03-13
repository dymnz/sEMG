// I2C device class (I2Cdev) demonstration Arduino sketch for MPU6050 class
// 10/7/2011 by Jeff Rowberg <jeff@rowberg.net>
// Updates should (hopefully) always be available at https://github.com/jrowberg/i2cdevlib
//
// Changelog:
//      2013-05-08 - added multiple output formats
//                 - added seamless Fastwire support
//      2011-10-07 - initial release

/* ============================================
I2Cdev device library code is placed under the MIT license
Copyright (c) 2011 Jeff Rowberg

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
===============================================
*/

// I2Cdev and MPU6050 must be installed as libraries, or else the .cpp/.h files
// for both classes must be in the include path of your project
#include "I2Cdev.h"
#include "MPU6050.h"

// Arduino Wire library is required if I2Cdev I2CDEV_ARDUINO_WIRE implementation
// is used in I2Cdev.h
#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
    #include "Wire.h"
#endif

// class default I2C address is 0x68
// specific I2C addresses may be passed as a parameter here
// AD0 low = 0x68 (default for InvenSense evaluation board)
// AD0 high = 0x69
MPU6050 accelgyro;
MPU6050 accelgyro_2(0x69); // <-- use for AD0 high

int16_t ax, ay, az;
int16_t ax_2, ay_2, az_2;
float ox, oy, oz;   // offset for MPU1 
float ox_2, oy_2, oz_2;   // offset for MPU2 

char buffer[100];


// uncomment "OUTPUT_READABLE_ACCELGYRO" if you want to see a tab-separated
// list of the accel X/Y/Z and then gyro X/Y/Z values in decimal. Easy to read,
// not so easy to parse, and slow(er) over UART.
#define OUTPUT_READABLE_ACCELGYRO

// uncomment "OUTPUT_BINARY_ACCELGYRO" to send all 6 axes of data as 16-bit
// binary, one right after the other. This is very fast (as fast as possible
// without compression or data loss), and easy to parse, but impossible to read
// for a human.
//#define OUTPUT_BINARY_ACCELGYRO


#define LED_PIN 13
bool blinkState = false;

void setup() {
    // join I2C bus (I2Cdev library doesn't do this automatically)
    #if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
        Wire.begin();
    #elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
        Fastwire::setup(400, true);
    #endif

    // initialize SerialUSB communication
    // (38400 chosen because it works as well at 8MHz as it does at 16MHz, but
    // it's really up to you depending on your project)
    SerialUSB.begin(115200);

    // initialize device
    SerialUSB.println("Initializing I2C devices...");
    accelgyro.initialize();
    accelgyro_2.initialize();


    // verify connection
    SerialUSB.println("Testing device connections...");
    SerialUSB.println(accelgyro.testConnection() ? "MPU6050 connection successful" : "MPU6050 connection failed");
    SerialUSB.println(accelgyro_2.testConnection() ? "MPU6050_2 connection successful" : "MPU6050_2 connection failed");

    accelgyro.setRate(4); // 200Hz
    accelgyro_2.setRate(4); // 200Hz

    // offset
    // perfect: 0 0 16384
    SerialUSB.println("Find offset:");
    findOffset();
    SerialUSB.println("Test offset:");
    offsetTest();

    while (true);
    
    // configure Arduino LED for
    pinMode(LED_PIN, OUTPUT);
}

void loop() {
    // read raw accel/gyro measurements from device
    //accelgyro.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);

    // these methods (and a few others) are also available
    accelgyro.getAcceleration(&ax, &ay, &az);
    accelgyro_2.getAcceleration(&ax_2, &ay_2, &az_2);
    //accelgyro.getRotation(&gx, &gy, &gz);

    #ifdef OUTPUT_READABLE_ACCELGYRO
        // display tab-separated accel/gyro x/y/z values
        sprintf(buffer, "1: %8d %8d %8d\n", ax, ay, az);
        SerialUSB.print(buffer);
        sprintf(buffer, "2: %8d %8d %8d\n", ax_2, ay_2, az_2);
        SerialUSB.print(buffer);
 
    #endif

    #ifdef OUTPUT_BINARY_ACCELGYRO
        SerialUSB.write((uint8_t)(ax >> 8)); SerialUSB.write((uint8_t)(ax & 0xFF));
        SerialUSB.write((uint8_t)(ay >> 8)); SerialUSB.write((uint8_t)(ay & 0xFF));
        SerialUSB.write((uint8_t)(az >> 8)); SerialUSB.write((uint8_t)(az & 0xFF));
        SerialUSB.write((uint8_t)(gx >> 8)); SerialUSB.write((uint8_t)(gx & 0xFF));
        SerialUSB.write((uint8_t)(gy >> 8)); SerialUSB.write((uint8_t)(gy & 0xFF));
        SerialUSB.write((uint8_t)(gz >> 8)); SerialUSB.write((uint8_t)(gz & 0xFF));
    #endif

    // blink LED to indicate activity
    blinkState = !blinkState;
    digitalWrite(LED_PIN, blinkState);
    delay(100);
}

void findOffset() {  
    float sumX, sumY, sumZ;
    sumX = sumY = sumZ = 0;
    for (int i = 0; i < 1000; i++) {
      accelgyro.getAcceleration(&ax, &ay, &az);
      sumX += ax;
      sumY += ay;
      sumZ += az;
      delay(5);
    }

    ox = (sumX/1000);
    oy = (sumY/1000);
    oz = (sumZ/1000) - 16384.0;
    
    SerialUSB.print("1:"); SerialUSB.print("\t");
    SerialUSB.print(ox); SerialUSB.print("\t");
    SerialUSB.print(oy); SerialUSB.print("\t");
    SerialUSB.print(oz); SerialUSB.print("\t");
    SerialUSB.print("\n");

    sumX = sumY = sumZ = 0;
    for (int i = 0; i < 1000; i++) {
      accelgyro_2.getAcceleration(&ax, &ay, &az);
      sumX += ax;
      sumY += ay;
      sumZ += az;
      delay(5);
    }

    ox_2 = (int)(sumX/1000);
    oy_2 = (int)(sumY/1000);
    oz_2 = (int)(sumZ/1000) - 16384;
    
    SerialUSB.print("2:"); SerialUSB.print("\t");
    SerialUSB.print(ox_2); SerialUSB.print("\t");
    SerialUSB.print(oy_2); SerialUSB.print("\t");
    SerialUSB.print(oz_2); SerialUSB.print("\t");
    SerialUSB.print("\n");
}


void offsetTest() {
    float sumX, sumY, sumZ;
    sumX = sumY = sumZ = 0;
    for (int i = 0; i < 1000; i++) {
      accelgyro.getAcceleration(&ax, &ay, &az);
      sumX += ax - ox;
      sumY += ay - oy;
      sumZ += az - oz;
      delay(5);
    }
    SerialUSB.print("1:"); SerialUSB.print("\t");
    SerialUSB.print((int)(sumX/1000)); SerialUSB.print("\t");
    SerialUSB.print((int)(sumY/1000)); SerialUSB.print("\t");
    SerialUSB.print((int)(sumZ/1000)); SerialUSB.print("\t");
    SerialUSB.print("\n");

    sumX = sumY = sumZ = 0;
    for (int i = 0; i < 1000; i++) {
      accelgyro_2.getAcceleration(&ax, &ay, &az);
      sumX += ax - ox_2;
      sumY += ay - oy_2;
      sumZ += az - oz_2;
      delay(5);
    }
    SerialUSB.print("2:"); SerialUSB.print("\t");
    SerialUSB.print((int)(sumX/1000)); SerialUSB.print("\t");
    SerialUSB.print((int)(sumY/1000)); SerialUSB.print("\t");
    SerialUSB.print((int)(sumZ/1000)); SerialUSB.print("\t");
    SerialUSB.print("\n");
}

