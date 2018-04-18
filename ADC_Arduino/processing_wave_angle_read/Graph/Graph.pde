import processing.serial.*;

Serial serial;
PrintWriter file;

enum State {HOLD, SEMG_ALIGN, MPU_ALIGN, SEMG_READ, MPU_READ, SEMG_FIN, MPU_FIN}
State serial_state = State.HOLD;

final String filename = "../../../Signals/Arduino/Format_semg_angle/data/raw_S2WA_TEST.txt";

final int width = 1440;
final int height = 900;
final int grid_size = 30;
final float graph_x_step = 0.1;

final float force_calibration_factor = -200000;
final int value_buffer_size = 10000;

final int semg_channel = 2;
final int semg_packet_byte = 2;
final int mpu_channel = 2;
final int mpu_packet_byte = 2;

final int total_channel = mpu_channel + semg_channel;
final int semg_packet_len = semg_channel * semg_packet_byte;
final int mpu_packet_len = mpu_channel * mpu_packet_byte;

int semg_buffer_index = 0, semg_draw_index = 0;
int mpu_buffer_index = 0, mpu_draw_index = 0;

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
boolean aligned = false;

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
      }      
      
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
        semg_values[0] = (semg_packet[1] << 8) | semg_packet[0];
        semg_values[1] = (semg_packet[3] << 8) | semg_packet[2];
        
        
        semg_buffer[0][semg_buffer_index] = semg_values[0];
        semg_buffer[1][semg_buffer_index] = semg_values[1];
        
        if (++semg_buffer_index >= value_buffer_size) 
          semg_buffer_index = 0;
          
        draw_semg = true;    
        serial_state = State.HOLD;
        serial_count = 0;
        
        //sampleCount();
      }             
    } else if (serial_state == State.MPU_READ) {
      mpu_packet[serial_count] = ch;
      
      ++serial_count;
      
      if (serial_count >= mpu_packet_len) {
        mpu_values[0] =  int((mpu_packet[1] << 8) | (mpu_packet[0]));
        mpu_values[1] =  int((mpu_packet[3] << 8) | (mpu_packet[2]));
        
        mpu_buffer[0][mpu_buffer_index] = convert_to_int16((int)mpu_values[0]);
        mpu_buffer[1][mpu_buffer_index] = convert_to_int16((int)mpu_values[1]);
        
        if (++mpu_buffer_index >= value_buffer_size) 
          mpu_buffer_index = 0;
          
        draw_mpu = true;
        serial_state = State.HOLD;
        serial_count = 0;        
      }     
    }
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
