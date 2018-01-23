#include <stdint.h>
#include "HX711.h"

const int MaxSampleCount = 1000;

const int alignment_packet_len = 5;
uint8_t alignment_packet[] = { '$', '@', '%', '!', '~'};

const int data_packet_len = 6;
uint8_t data_packet[data_packet_len] = {0};



#define DOUT  3
#define CLK  2

HX711 scale(DOUT, CLK);

long offset;

void setup() {
  AdcBooster();
  analogReadResolution(12);

  scale.set_scale();
  scale.tare(); //Reset the scale to 0
  long zero_factor = scale.read_average(); //Get a baseli ne reading
  offset = scale.get_offset();
  
  SerialUSB.begin(0);
  while (!SerialUSB);
  SerialUSB.write(alignment_packet, alignment_packet_len);
}

void loop() {
  int sensorValue;
  while (1) {        
    // scale.read() returns 32bit signed int
    // If the scale is not ready, retain the old value
    if (scale.is_ready()) {
      long v = scale.read() - offset;
      ((long *)data_packet)[0] = v;
      

    }

    sensorValue = analogRead(A0);
    data_packet[4] = (uint8_t)(sensorValue >> 8);
    data_packet[5] = (uint8_t)(sensorValue & 0xFF);
    
    SerialUSB.write(data_packet, data_packet_len);
    //SerialUSB.println( *((long*)data_packet) );
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


long read()
{
  unsigned long value = 0;
  uint8_t data[3] = { 0 };
  uint8_t filler = 0x00;

  // pulse the clock pin 24 times to read the data
  data[2] = shiftIn(DOUT, CLK, MSBFIRST);
  data[1] = shiftIn(DOUT, CLK, MSBFIRST);
  data[0] = shiftIn(DOUT, CLK, MSBFIRST);

  // set the channel and the gain factor for the next reading using the clock pin
  for (unsigned int i = 0; i < 1; i++) {
    digitalWrite(CLK, HIGH);
    digitalWrite(CLK, LOW);
  }

  // Replicate the most significant bit to pad out a 32-bit signed integer
  if (data[2] & 0x80) {
    filler = 0xFF;
  } else {
    filler = 0x00;
  }

  // Construct a 32-bit signed integer
  return ( static_cast<unsigned long>(filler) << 24
      | static_cast<unsigned long>(data[2]) << 16
      | static_cast<unsigned long>(data[1]) << 8
      | static_cast<unsigned long>(data[0]) );
}

