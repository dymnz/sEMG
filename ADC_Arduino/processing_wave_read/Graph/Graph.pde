import processing.serial.*;
Serial serial;

final int channel = 1;
final int width = 1440;
final int height = 900;

final int value_buffer_size = 2048;
int buffer_index = 0, draw_index = 0;
int[] read_values = new int[channel];
int[] value_buffer[] = new int[channel][value_buffer_size];

final int alignment_packet_len = 5;
char[] alignment_packet = { '$', '@', '%', '!', '~'};
int alignment_count = 0;

int serial_count = 0;
char[] raw_packet = new char[channel * 2];

int current_time = 0;
int last_time = 0;
int sample_count = 0;

boolean draw_values  = false;
boolean aligned = false;

void settings() {
  size(width, height, FX2D);
}

void setup() {
  background(0);
  frameRate(9999);
  println(Serial.list()); // Use this to print connected serial devices
  serial = new Serial(this, Serial.list()[1], 1843200); // Set this to your serial port obtained using the line above
}

void serialEvent(Serial serial) {
  // Wait for alignment
  if (!aligned) {
    while (serial.available() > 0) {
      char ch = (char)serial.read();
      if (ch == alignment_packet[alignment_count])
        alignment_count++;
      if (alignment_count >= alignment_packet_len)
        aligned = true;        
    }
  }
    
  // Actual reading
  while (serial.available() > 0) {    
    char ch = (char)serial.read();
    raw_packet[serial_count++] = ch;
    
    if (serial_count < 2)
      continue;
        
    serial_count = 0;    
    read_values[0] = (raw_packet[0] << 8) | raw_packet[1];
    
    convert();
    
    value_buffer[0][buffer_index] = read_values[0];
    ++buffer_index;   
    
    /*
    sample_count++;
    current_time = millis();
    if (current_time - last_time > 1000) {
      println(sample_count);
      last_time = millis();
      sample_count = 0;
    }    
    */
    
    draw_values = true;        
  }
}

void draw() {
  if (draw_values) {
    draw_values = false;
    drawAxisX();
  }
}