#include <stdint.h>

const int MaxSampleCount = 1000;

const int alignment_packet_len = 5;
uint8_t alignment_packet[] = { '$', '@', '%', '!', '~'};

const int data_packet_len = 2;
uint8_t data_packet[data_packet_len] = {0};

void setup() {
	AdcBooster();
	analogReadResolution(12);
	SerialUSB.begin(0);
	while (!SerialUSB);
  SerialUSB.write(alignment_packet, alignment_packet_len);
}

void loop() {
	int sensorValue;
  while (1) {
    sensorValue = analogRead(A0);
    data_packet[0] = (uint8_t)(sensorValue >> 8);
    data_packet[1] = (uint8_t)(sensorValue & 0xFF);
    
    SerialUSB.write(data_packet, data_packet_len);
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
