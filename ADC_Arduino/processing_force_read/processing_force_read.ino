#include <stdint.h>
#include "HX711.h"

#define DOUT  3
#define CLK  2

const int MaxSampleCount = 1000;

const int alignment_packet_len = 1;

const int semg_channel = 1;
const int semg_packet_byte = 2;
const int semg_packet_len = alignment_packet_len + semg_channel * semg_packet_byte;

const int force_channel = 1;
const int force_packet_byte = 4;
const int force_packet_len = alignment_packet_len + force_channel * force_packet_byte;

uint8_t semg_packet[semg_packet_len] = {'$'};
uint8_t force_packet[force_packet_len] = {'#'};

HX711 scale(DOUT, CLK);

long offset;
int sensorValue;

void setup() {
  AdcBooster();
  analogReadResolution(12);

  scale.set_scale();
  scale.tare(); //Reset the scale to 0
  long zero_factor = scale.read_average(); //Get a baseli ne reading
  offset = scale.get_offset();
  
  SerialUSB.begin(0);
  while (!SerialUSB);
}

void loop() {  
  while (1) {        
    // scale.read() returns 32bit signed int
    // If the scale is not ready, retain the old value
    ///*
    if (scale.is_ready()) {
      ((long *)(force_packet + alignment_packet_len))[0] = scale.read() - offset;
      SerialUSB.write(force_packet, force_packet_len);
    }
    //*/

    sensorValue = analogRead(A0);
    ((uint16_t *)(semg_packet + alignment_packet_len))[0] = sensorValue;
        
    SerialUSB.write(semg_packet, semg_packet_len);
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

