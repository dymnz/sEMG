float x = 0;
float semg_last_x = 1;
float pot_last_x = 1;
float mpu_last_x = 1;

int[] semg_last_height = new int[semg_channel];
int[] mpu_last_height = new int[mpu_channel];

final int[][] semg_color_list = {{120, 10, 10}, {255, 170, 170}, {10, 120, 10}, {170, 255, 170}};
final int[][] mpu_color_list = {{255, 30, 30}, {30, 255, 30}, {30, 30, 255}};

String buffer_str = ""; 

//https://forum.processing.org/two/discussion/6738/reduce-delay-in-writing-data-to-a-graph
void drawAll() {
  int draw_value;
  strokeWeight(4);
  //println(semg_buffer_index, force_buffer_index);
  while (semg_draw_index < semg_buffer_index) {
    buffer_str = "";
    for (int i = 0; i < semg_channel; i++  ) {
      draw_value = int(map(semg_buffer[i][semg_draw_index], semg_minValue, semg_maxValue, 0, height));
      stroke(semg_color_list[i][0], semg_color_list[i][1], semg_color_list[i][2]);
      //line(semg_last_x, semg_last_height[i], x, height - draw_value);

      semg_last_height[i] = int(height - draw_value);

      buffer_str += semg_buffer[i][semg_draw_index] + ",";
    }
    ++semg_draw_index;

    if (mpu_draw_index < mpu_buffer_index) {      
      for (int i = 0; i < mpu_channel; ++i) {
        stroke(mpu_color_list[i][0], mpu_color_list[i][1], mpu_color_list[i][2]);
        draw_value = int(map(mpu_buffer[i][mpu_draw_index], RPY_minValue[i], RPY_maxValue[i], 0, height));
        //line(mpu_last_x, mpu_last_height[i], x, height - draw_value);

        mpu_last_height[i] = int(height - draw_value);

        buffer_str += mpu_buffer[i][mpu_draw_index] + ",";
      }
      ++mpu_draw_index;
      mpu_last_x = x;
    } else {
      buffer_str += 0 + ",";
    }

    semg_last_x = x;    
    x += graph_x_step;

    if (tared == true)
      file.println(buffer_str);
  }


  if (x >= width) {
    x = 0;
    semg_last_x = 0;
    pot_last_x = 0;
    mpu_last_x = 0;
    resetGraph();
  }  

  semg_buffer_index = 0;      
  semg_draw_index = 0;
  mpu_buffer_index = 0;      
  mpu_draw_index = 0;
  
}

void resetGraph() {
  background(255);  
  strokeWeight(2);



  /*
  stroke(130, 130, 130);
  for (int i = RPY_maxValue[0] + RPY_minValue[0]; i < RPY_maxValue[0] - RPY_minValue[0]; i+=15) {
    int y = int(map(i, RPY_maxValue[0] + RPY_minValue[0], RPY_maxValue[0] - RPY_minValue[0], 0, height));
    line(0, height - y, width, height - y);
    line(0, y, width, y);
  }
  */

  stroke(0); 
  line(0, height / 2, width, height / 2);
}

final int semg_minValue = 0;
final int semg_maxValue = 4095;
void semg_convert() {
}

final int semg_minValue_abs = -2048;
final int semg_maxValue_abs = 2048;
void semg_convert_abs() {
  semg_values[0] = abs(semg_values[0] - 2048) + 2048;
}


final int [] RPY_minValue = {-180, -180, -180};
final int [] RPY_maxValue = {+180, +180, +180};
void mpu_convert() {
  for (int i = 0; i < mpu_channel; ++i) {
    mpu_values[i] = convert_to_int16((int) mpu_values[i]);
    mpu_values[i] = mpu_values[i] - mpu_angle_0d_diff[i];
    if (mpu_values[i] < -180) mpu_values[i] += 360;
    if (mpu_values[i] > +180) mpu_values[i] -= 360;
  }
  
}

// Use the last value stored in pot_buffer to tare;
int [] mpu_angle_0d_diff = {0, 0, 0}; // The diff of angle when hand resting and 0d; 
void mpu_tare() {
  println("MPU Tared!");
  for (int i = 0; i < mpu_channel; ++i)
    mpu_angle_0d_diff[i] = (int) mpu_buffer[i][mpu_buffer_index] + mpu_angle_0d_diff[i];
}


void writeAll() {
}

int convert_to_int16(int num) {
  boolean negative = (num & (1 << 15)) != 0;
  int converted_int;

  if (negative)
    converted_int = num | 0xFFFF0000;
  else
    converted_int = num;

  return converted_int;
}
