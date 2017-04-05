int sampleCount = 0;
int currentTime = 0;
int lastTime = 0;
char buffer[50];

void setup() {
  AdcBooster();
  analogReadResolution(12);
  SerialUSB.begin(0);
  while(!SerialUSB);
}

void loop() {
  ReadSendMatlab();  // For testing using MatLab
  //ReadSend1();    // Test read 1-channel
  //ReadSend4();    // Test read 4-channel
  //ReadTimeTest(); // Test samples per second
}

void ReadSendMatlab()
{
  int sensorValue = analogRead(A0);  
  sprintf(buffer, "%d\r\n", sensorValue);
  SerialUSB.print(buffer);
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

void ReadTimeTest()
{
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

//https://forum.arduino.cc/index.php?topic=443173.0
void AdcBooster()
{
  ADC->CTRLA.bit.ENABLE = 0;                     // Disable ADC
  while( ADC->STATUS.bit.SYNCBUSY == 1 );        // Wait for synchronization
  ADC->CTRLB.reg = ADC_CTRLB_PRESCALER_DIV128 |   // Divide Clock by 64.
                   ADC_CTRLB_RESSEL_12BIT;       // Result on 12 bits
  ADC->AVGCTRL.reg = ADC_AVGCTRL_SAMPLENUM_1 |   // 1 sample
                     ADC_AVGCTRL_ADJRES(0x00ul); // Adjusting result by 0
  ADC->SAMPCTRL.reg = 0x00;                      // Sampling Time Length = 0
  ADC->CTRLA.bit.ENABLE = 1;                     // Enable ADC
  while( ADC->STATUS.bit.SYNCBUSY == 1 );        // Wait for synchronization
}
