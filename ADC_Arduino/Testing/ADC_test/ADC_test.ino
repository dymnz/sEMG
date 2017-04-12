#include <stdint.h>

const int MaxSampleCount = 10000;
char buffer[50];

void setup() {
  AdcBooster();
  analogReadResolution(12);
  SerialUSB.begin(0);
  while(!SerialUSB);
}

void loop() {
  // Wait until Matlab signals start
  while(SerialUSB.read() == -1);
  
  //ReadSendMatlab();  // For testing using MatLab
  //ReadSend1();    // Test read 1-channel
  //ReadSend4();    // Test read 4-channel
  //SamplingRateTest1(); // Test samples per second (function call)
  //SamplingRateTest2(); // Test samples per second (while loop)
  ReadSendBatch(); // Batch send
  //ReadIntervalTest();
}

void ReadIntervalTest()
{
  static uint8_t interval[MaxSampleCount];
  static int sampleCount = 1;
  
  int current, last = 0;
  while (sampleCount < MaxSampleCount){
    //analogRead(A0);
    current = micros();
    interval[sampleCount++] = current - last;
    last = current;
  }
  
  for (int i = 3 ; i < MaxSampleCount ; i++) {
    sprintf(buffer, "%d\r\n", interval[i]);
    SerialUSB.print(buffer);
  }
}

void ReadSendMatlab()
{
  int sensorValue = analogRead(A0);  
  sprintf(buffer, "%d\r\n", sensorValue);
  SerialUSB.print(buffer);
}
  
void ReadSendBatch()
{
  static uint16_t samples[MaxSampleCount];
  static int sampleCount = 0;
  while (sampleCount < MaxSampleCount) {
    samples[sampleCount++] = analogRead(A0);
    delay(1);
  }
  
  for (int i = 0 ; i < MaxSampleCount ; i++) {
    sprintf(buffer, "%d\r\n", samples[i]);
    SerialUSB.print(buffer);
  }
  
}
  
void ReadSend1()
{
  int sensorValue = analogRead(A0);  
  sprintf(buffer, "%d\r\n", sensorValue);
  SerialUSB.print(buffer);
}

void ReadSend4()
{
  int sensorValue = analogRead(A0);
  int sensorValue2 = analogRead(A1);
  int sensorValue3 = analogRead(A2);
  int sensorValue4 = analogRead(A3);  
  sprintf(buffer, "%d\t%d\t%d\t%d\t\r\n", sensorValue, sensorValue2, sensorValue3, sensorValue4);
  SerialUSB.print(buffer);
}

void SamplingRateTest1()
{
  static int currentTime = 0;
  static int lastTime = 0;
  static int sampleCount = 0;
  int sensorValue = analogRead(A0);
  
  sampleCount++;
  currentTime = millis();
  
  if (currentTime - lastTime >= 1000)
  {
    lastTime = currentTime;
    SerialUSB.print(sampleCount);
    SerialUSB.print("\t\r\n");
    sampleCount = 0;
  }
}

void SamplingRateTest2()
{
  int sampleCount = 0;
  int sensorValue;
  int startTime = millis();
  
  while(millis() - startTime < 1000) 
  {
    sensorValue = analogRead(A0);
    sampleCount++;
  }
  
  SerialUSB.println(sampleCount);
}

//https://forum.arduino.cc/index.php?topic=443173.0
void AdcBooster()
{
  ADC->CTRLA.bit.ENABLE = 0;                     // Disable ADC
  while( ADC->STATUS.bit.SYNCBUSY == 1 );        // Wait for synchronization
  ADC->CTRLB.reg = ADC_CTRLB_PRESCALER_DIV512 |   // Divide Clock by N.
                   ADC_CTRLB_RESSEL_12BIT;       // Result on 12 bits
  ADC->AVGCTRL.reg = ADC_AVGCTRL_SAMPLENUM_1 |   // 1 sample
                     ADC_AVGCTRL_ADJRES(0x00ul); // Adjusting result by 0
  ADC->SAMPCTRL.reg = 0x00;                      // Sampling Time Length = 0
  ADC->CTRLA.bit.ENABLE = 1;                     // Enable ADC
  while( ADC->STATUS.bit.SYNCBUSY == 1 );        // Wait for synchronization
}
