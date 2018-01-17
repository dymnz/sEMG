#include <stdint.h>

const int MaxSampleCount = 1000;
char buffer[50];

void setup() {
  AdcBooster();
  analogReadResolution(12);
  SerialUSB.begin(0);
  while(!SerialUSB);
}

void loop() {
  ReadSend1Loop();
}


void ReadSend1Loop()
{
  int sensorValue;
  while (1) {
    sensorValue = analogRead(A0);
    SerialUSB.write((uint8_t)(sensorValue >> 8)); SerialUSB.write((uint8_t)(sensorValue & 0xFF));
  }
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
