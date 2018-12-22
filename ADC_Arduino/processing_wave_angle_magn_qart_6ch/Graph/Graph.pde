import processing.serial.*; //<>//

Serial serial;
PrintWriter file;

enum SerialState {
  HOLD, SEMG_ALIGN, MPU_ALIGN, SEMG_READ, MPU_READ, SEMG_FIN, MPU_FIN
}
SerialState serial_state = SerialState.HOLD;

final String SERIAL_NAME = "/dev/ttyACM0";
final String filename = "../../../Signals/Arduino/Format_semg_angle_magn/data/raw_S2WA_YAO_631_" + "PRO" + "_1" + ".txt";


final int width = 1280;
final int height = 720; //<>//
final int grid_size = 30;
final float graph_x_step = 0.04;

final float force_calibration_factor = -200000;
final int value_buffer_size = 10000;

final int semg_channel = 6;
final int semg_packet_byte = 2;
final int quat_channel = 4;
final int quat_packet_byte = 4;

final int angle_channel = 3;

final int total_channel = quat_channel + semg_channel;
final int semg_packet_len = semg_channel * semg_packet_byte;
final int quat_packet_len = quat_channel * quat_packet_byte;

int semg_buffer_index = 0, semg_draw_index = 0;
int angle_buffer_index = 0, mpu_draw_index = 0;

float[] semg_values = new float[semg_channel];
float[] quat_values = new float[quat_channel];
float[] angle_values = new float[angle_channel];
float[] radian_values = new float[angle_channel];

float[] semg_buffer[] = new float[semg_channel][value_buffer_size];
float[] angle_buffer[] = new float[angle_channel][value_buffer_size];

final int alignment_packet_len = 1;
final char[] semg_alignment_packet = {'$'};
final char[] mpu_alignment_packet = {'@'};

int alignment_count = 0;
int serial_count = 0;

char[] semg_packet = new char[semg_packet_len];
char[] quat_packet = new char[quat_packet_len];

int sc_current_time = 0;
int sc_last_time = 0;
int sc_sample_count = 0;

int pm_current_time = 0;
int pm_last_time = 0;

boolean draw_semg  = false;
boolean draw_mpu = false;
boolean draw_pot  = false;
boolean aligned = false;

boolean quat_tared = false; // Value is wrote to file only after quat_tared = true


void settings() {
  size(width, height, FX2D);
}

void setup() {
  resetGraph();
  frameRate(1000);
  file = createWriter(filename); 

  println(Serial.list()); // Use this to print connected serial devices  
  serial = new Serial(this, SERIAL_NAME, 4000000); // Set this to your serial port obtained using the line above
}

int c = 0;
void serialEvent(Serial serial) {  
  while (serial.available() > 0) {
    char ch = (char)serial.read();

    if (serial_state == SerialState.HOLD) {
      if (ch == semg_alignment_packet[alignment_count]) {
        if (alignment_count == 0)
          serial_state = SerialState.SEMG_ALIGN;
        ++alignment_count;
      } else if (ch == mpu_alignment_packet[alignment_count]) {
        if (alignment_count == 0)
          serial_state = SerialState.MPU_ALIGN;         
        ++alignment_count;
      }      

      if (alignment_count >= alignment_packet_len) {
        if (serial_state == SerialState.SEMG_ALIGN)
          serial_state = SerialState.SEMG_READ;
        else if (serial_state == SerialState.MPU_ALIGN)
          serial_state = SerialState.MPU_READ;  

        alignment_count = 0;
      }
    } else if (serial_state == SerialState.SEMG_READ) {      
      semg_packet[serial_count] = ch;

      ++serial_count;

      if (serial_count >= semg_packet_len) {
        for (int i = 0; i < semg_channel; ++i) {
          semg_values[i] = (semg_packet[2*i + 1] << 8) | semg_packet[2*i];
          semg_buffer[i][semg_buffer_index] = semg_values[i];
        }

        if (++semg_buffer_index >= value_buffer_size) 
          semg_buffer_index = 0;

        draw_semg = true;    
        serial_state = SerialState.HOLD;
        serial_count = 0;

        if (quat_tared)
          printMove();
        else
          sampleCount();
      }
    } else if (serial_state == SerialState.MPU_READ) {
      quat_packet[serial_count] = ch;

      ++serial_count;

      if (serial_count >= quat_packet_len) {
        for (int i = 0; i < quat_channel; ++i) {
          
          // https://stackoverflow.com/questions/4513498/java-bytes-to-floats-ints
          quat_values[i] =  Float.intBitsToFloat( ((quat_packet[i*4 + 3] & 0xFF) << 24) | 
                                    ((quat_packet[i*4 + 2] & 0xFF) << 16) |
                                    ((quat_packet[i*4 + 1] & 0xFF) << 8)  | 
                                     (quat_packet[i*4] & 0xFF));
                                  
        }
   
        quat_convert();

        for (int i = 0; i < angle_channel; ++i)
          angle_buffer[i][angle_buffer_index] = (int)angle_values[i];

        if (++angle_buffer_index >= value_buffer_size) 
          angle_buffer_index = 0;

        draw_mpu = true;
        serial_state = SerialState.HOLD;
        serial_count = 0;
      }
    }
  }
}

void keyPressed() {
  if (key == '1') { // ascii for '1' 
    mpu_tare();
    quat_tared = true;
    
    println("Quat tared");
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
  sc_sample_count++;
  sc_current_time = millis();
  if (sc_current_time - sc_last_time > 1000) {
    println(sc_sample_count);

    sc_last_time = millis();
    sc_sample_count = 0;
  }
}

final String [] move_list = {"---1: Hold init   ",
  "2: MOVE to final ↗", "3: Hold FINAL ↔", "4: MOVE to init ↘", 
  "---5: Hold init   "};
  
int move_list_index = 0;
int move_count = 1;
void printMove() {     
  pm_current_time = millis();
  if (pm_current_time - pm_last_time > 1000) {
    println(move_list[move_list_index] + " \t--> " + move_count);

    pm_last_time = millis();
    move_list_index = (move_list_index + 1) % move_list.length;

    if (move_list_index == 0)
      ++move_count;
  }
}
