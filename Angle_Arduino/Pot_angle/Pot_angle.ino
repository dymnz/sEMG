
int sensorPin = A4;    // select the input pin for the potentiometer
int sensorValue = 0;  // variable to store the value coming from the sensor

void setup() {
  SerialUSB.begin(0);
  while (!SerialUSB);

  AdcBooster();
  analogReadResolution(12);
  analogReference(AR_EXTERNAL);
}

void loop() {
  sensorValue = analogRead(sensorPin);

  SerialUSB.println(sensorValue);

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

