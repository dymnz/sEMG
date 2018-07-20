import processing.serial.*;

Serial serial;
PrintWriter file;

enum State {HOLD, SEMG_ALIGN, MPU_ALIGN, POT_ALIGN,SEMG_READ, MPU_READ, POT_READ,SEMG_FIN, MPU_FIN, POT_FIN}
State serial_state = State.HOLD;

final String filename = "../../../Signals/Arduino/Format_semg_angle/data/MPU_VS_POT_1.txt";

final int width = 1440;
final int height = 900;
final int grid_size = 30;
final float graph_x_step = 0.1;

final float force_calibration_factor = -200000;
final int value_buffer_size = 10000;

final int semg_channel = 4;
final int semg_packet_byte = 2;
final int mpu_channel = 3;
final int mpu_packet_byte = 2;

final int total_channel = mpu_channel + semg_channel;
final int semg_packet_len = semg_channel * semg_packet_byte;
final int mpu_packet_len = mpu_channel * mpu_packet_byte;

int semg_buffer_index = 0, semg_draw_index = 0;
int mpu_buffer_index = 0, mpu_draw_index = 0;
int pot_buffer_index = 0, pot_draw_index = 0;

float[] semg_values = new float[semg_channel];
float[] mpu_values = new float[mpu_channel];

float[] semg_buffer[] = new float[semg_channel][value_buffer_size];
float[] mpu_buffer[] = new float[mpu_channel][value_buffer_size];

final int alignment_packet_len = 1;
final char[] semg_alignment_packet = {'$'};
final char[] mpu_alignment_packet = {'@'};

int alignment_count = 0;
int serial_count = 0;

char[] semg_packet = new char[semg_packet_len];
char[] mpu_packet = new char[mpu_packet_len];

int current_time = 0;
int last_time = 0;
int sample_count = 0;

boolean draw_semg  = false;
boolean draw_mpu = false;
boolean draw_pot  = false;
boolean aligned = false;

boolean tared = false; // Value is wrote to file only after tared = true

void settings() {
  size(width, height, FX2D);
}

void setup() {
  resetGraph();
  frameRate(1000);
  file = createWriter(filename); 
  
  println(Serial.list()); // Use this to print connected serial devices  
  int ind = Serial.list().length - 1;
  serial = new Serial(this, "/dev/ttyACM0", 4000000); // Set this to your serial port obtained using the line above

}

int c = 0;
void serialEvent(Serial serial) {  
  while (serial.available() > 0) {
    char ch = (char)serial.read();
    
    if (serial_state == State.HOLD) {
      if (ch == semg_alignment_packet[alignment_count]) {
        if (alignment_count == 0)
          serial_state = State.SEMG_ALIGN;
        ++alignment_count;
      }
      else if (ch == mpu_alignment_packet[alignment_count]) {
        if (alignment_count == 0)
          serial_state = State.MPU_ALIGN;         
        ++alignment_count;
      }       //<>//

      
      if (alignment_count >= alignment_packet_len) {
        if (serial_state == State.SEMG_ALIGN)
          serial_state = State.SEMG_READ;
        else if (serial_state == State.MPU_ALIGN)
          serial_state = State.MPU_READ; 
          
        alignment_count = 0;
      }    
    } else if (serial_state == State.SEMG_READ) {      
      semg_packet[serial_count] = ch;
      
      ++serial_count;
      
      if (serial_count >= semg_packet_len) {
        for (int i = 0; i < semg_channel; ++i) {
        semg_values[i] = (semg_packet[2 * i + 1] << 8) | semg_packet[2 * i];

        semg_buffer[i][semg_buffer_index] = semg_values[i];
        }
        
        if (++semg_buffer_index >= value_buffer_size) 
          semg_buffer_index = 0;
          
        draw_semg = true;    
        serial_state = State.HOLD;
        serial_count = 0;
        
        sampleCount();
      }             
    } else if (serial_state == State.MPU_READ) {
      mpu_packet[serial_count] = ch;
      
      ++serial_count;
      
      if (serial_count >= mpu_packet_len) {
        for (int i = 0; i < mpu_channel; ++i)
          mpu_values[i] =  int((mpu_packet[2 * i + 1] << 8) | (mpu_packet[2 * (i - 1)]));
  
        mpu_convert();
        for (int i = 0; i < mpu_channel; ++i)
          mpu_buffer[i][mpu_buffer_index] = (int)mpu_values[i];
     
        if (++mpu_buffer_index >= value_buffer_size) 
          mpu_buffer_index = 0;
          
        draw_mpu = true;
        serial_state = State.HOLD;
        serial_count = 0;        
      }     
    }
  }  
}

void keyPressed() {
  if (key == '0') { // ascii for '0' 
    pot_tare();
    mpu_tare();
    tared = true;
  }
}


void draw() {
  // Force data is drawn along with SEMG data as the update
  // rate of force data is much slower. 
  if (draw_semg) {
    draw_semg = false;   
    drawAll();
    //writeAll();
  }  
}

void sampleCount() {     
  sample_count++;
  current_time = millis();
  if (current_time - last_time > 1000) {
    println(sample_count);
    last_time = millis();
    sample_count = 0;
  }        
}
