import processing.serial.*;
Serial serial;

final int width = 1440;
final int height = 900;
final float graph_x_step = 0.05;

final float force_calibration_factor = -200000;

final int semg_channel = 1;
final int semg_packet_byte = 2;
final int force_channel = 1;
final int force_packet_byte = 4;
final int total_channel = force_channel + semg_channel;

final int value_buffer_size = 10000;
int buffer_index = 0, draw_index = 0;
int[] semg_values = new int[semg_channel];
float[] force_values = new float[force_channel];
int[] value_buffer[] = new int[total_channel][value_buffer_size];

final int alignment_packet_len = 1;
char[] alignment_packet = { '$'};
int alignment_count = 0;

int serial_count = 0;
final int raw_packet_len = 
  semg_channel * semg_packet_byte + 
  force_channel * force_packet_byte;
char[] raw_packet = new char[raw_packet_len];

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
  int ind = Serial.list().length - 1;
  serial = new Serial(this, Serial.list()[ind], 1843200); // Set this to your serial port obtained using the line above
}

void serialEvent(Serial serial) {  

  while (serial.available() > 0) {    
    char ch = (char)serial.read();

    // Wait for alignment
    if (!aligned) {
      if (ch == alignment_packet[alignment_count]) {
        ++alignment_count;
        if (alignment_count >= alignment_packet_len) {
          aligned = true;
          alignment_count = 0;        
        }              
      }
      continue;
    }
             
    // Actual reading
    // Force channel -> SEMG channel    
    raw_packet[serial_count] = ch;
    ++serial_count;

    if (serial_count < raw_packet_len)
      continue;
        
    serial_count = 0;        
        
    force_values[0] = float(int(
      (raw_packet[3] << 24) | 
      (raw_packet[2] << 16) | 
      (raw_packet[1] << 8) | 
      (raw_packet[0])));

      
    semg_values[0] = (raw_packet[4] << 8) | raw_packet[5];
    
    convert();
    
    value_buffer[0][buffer_index] = int(force_values[0]);
    value_buffer[1][buffer_index] = semg_values[0];
    
    if (++buffer_index >= value_buffer_size) 
      buffer_index = 0;
    
    /*
    sample_count++;
    current_time = millis();
    if (current_time - last_time > 1000) {
      println(sample_count);
      last_time = millis();
      sample_count = 0;
    }    
    */
    aligned = false;
    draw_values = true;

  }  
}

void draw() {
  if (draw_values) {
    draw_values = false;
    drawAxisX();
  }
}