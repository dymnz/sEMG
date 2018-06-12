import processing.serial.*;
Serial serial;

final int channel = 3;
final int width = 900;
final int height = 900;

final int value_buffer_size = 2048;
int buffer_index = 0, draw_index = 0;
int[] read_values = new int[channel];
int[] value_buffer[] = new int[channel][value_buffer_size];

final int alignment_packet_len = 5;
char[] alignment_packet = {'$', '@', '%', '!', '~'};

int alignment_count = 0;

int serial_count = 0;
char[] raw_packet = new char[channel * 2];

int current_time = 0;
int last_time = 0;
int sample_count = 0;

boolean draw_values  = false;
boolean aligned = false;

boolean remove_bias = false;

void settings() {
  size(width, height, FX2D);
}

void setup() {
  background(190);
  frameRate(9999);
  println(Serial.list()); // Use this to print connected serial devices
  serial = new Serial(this, Serial.list()[0], 2000000); // Set this to your serial port obtained using the line above
}

int ser = 0;
void serialEvent(Serial serial) {
  
  //println((char)serial.read());
  
  // Wait for alignment
  if (!aligned) {
    while (serial.available() > 0) {
      char ch = (char)serial.read();
      println(alignment_packet[alignment_count] + ":" + ch);
      if (ch == alignment_packet[alignment_count])
        alignment_count++;
      if (alignment_count >= alignment_packet_len) {
        println("----------------Aligned!!!!");
        aligned = true;
        break;
      }
    }
  }
    
  // Actual reading
  while (serial.available() > 0) {    
    char ch = (char)serial.read();
    raw_packet[serial_count] = ch;
    serial_count++;
    
    if (serial_count < 6)
      continue;
        
    serial_count = 0;    
    read_values[0] = convert_to_int16((raw_packet[0] << 8) | raw_packet[1]);
    read_values[1] = convert_to_int16((raw_packet[2] << 8) | raw_packet[3]);
    read_values[2] = convert_to_int16((raw_packet[4] << 8) | raw_packet[5]);
    
    
    if (!remove_bias)
      bias_calc();
    
    
    if (!remove_bias) {
      value_buffer[0][buffer_index] = read_values[0];
      value_buffer[1][buffer_index] = read_values[1];
      value_buffer[2][buffer_index] = read_values[2];
    } else {
      value_buffer[0][buffer_index] = read_values[0] - mag_bias[0];
      value_buffer[1][buffer_index] = read_values[1] - mag_bias[1];
      value_buffer[2][buffer_index] = read_values[2] - mag_bias[2];   
      
      
      value_buffer[0][buffer_index] *= mag_scale[0];
      value_buffer[1][buffer_index] *= mag_scale[1];
      value_buffer[2][buffer_index] *= mag_scale[2];
    }
    ++buffer_index;   
    
    
    draw_values = true;        
  }
  
}

void keyPressed() {
  if (key == '1') { // ascii for '0' 
    println("remove_bias");
    background(190);
    remove_bias = true;
    println("mag_bias: " + mag_bias[0] + "/" + mag_bias[1] + "/" + mag_bias[2]);
    println("mag_scale: " + mag_scale[0] + "/" + mag_scale[1] + "/" + mag_scale[2]);
  }
  if (key == '0') {
    println("reset max min");
    background(190);
    mag_max = new int[] {-32760, -32760, -32760};
    mag_min = new int[] {32760, 32760, 32760};
    remove_bias = false;
  }
}


void draw() {
  if (draw_values) {
    draw_values = false;
    drawAxisX();
  }
}
