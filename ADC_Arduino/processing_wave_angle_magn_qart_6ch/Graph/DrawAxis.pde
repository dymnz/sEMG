float x = 0;
float semg_last_x = 1;
float pot_last_x = 1;
float mpu_last_x = 1;

int[] semg_last_height = new int[semg_channel];
int[] mpu_last_height = new int[mpu_channel];

final int[][] semg_color_list = {{120, 10, 10}, {255, 170, 170}, {10, 120, 10}, {170, 255, 170}, {10, 10, 120}, {170, 170, 255}};
final int[][] mpu_color_list = {{255, 30, 30}, {30, 255, 30}, {30, 30, 255}};

final int semg_minValue = 0;
final int semg_maxValue = 4095;
final int[] semg_shift_value = {0, semg_maxValue/6, 2*semg_maxValue/6, 3*semg_maxValue/6, 4*semg_maxValue/6, 5*semg_maxValue/6};
//final int[] semg_shift_value = {0, 0, 0, 0, 0, 0};

String buffer_str = ""; 

//https://forum.processing.org/two/discussion/6738/reduce-delay-in-writing-data-to-a-graph
void drawAll() {
  int draw_value;
  strokeWeight(4);
  //println(semg_buffer_index, force                                                             _buffer_index);
  while (semg_draw_index < semg_buffer_index) {
    buffer_str = "";
    for (int i = 0; i < semg_channel; i++  ) {
      draw_value = int(map(semg_buffer[i][semg_draw_index] + semg_shift_value[i] - 2*semg_maxValue/5, semg_minValue, semg_maxValue, 0, height));
      //draw_value = int(map(semg_buffer[i][semg_draw_index], semg_minValue, semg_maxValue, 0, height));

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
        line(mpu_last_x, mpu_last_height[i], x, height - draw_value);

        mpu_last_height[i] = int(height - draw_value);

        buffer_str += mpu_buffer[i][mpu_draw_index] + ",";
      }
      ++mpu_draw_index;
      mpu_last_x = x;
    } else {
      for (int i = 0; i < mpu_channel; ++i)
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



  ///*
  stroke(130, 130, 130);
  for (int i = RPY_maxValue[0] + RPY_minValue[0]; i < RPY_maxValue[0] - RPY_minValue[0]; i+=15) {
    int y = int(map(i, RPY_maxValue[0] + RPY_minValue[0], RPY_maxValue[0] - RPY_minValue[0], 0, height));
    line(0, height - y, width, height - y);
    line(0, y, width, y);
  }
  //*/

  stroke(0); 
  line(0, height / 2, width, height / 2);
}

void semg_convert() {
}

final int semg_minValue_abs = -2048;
final int semg_maxValue_abs = 2048;
void semg_convert_abs() {
  semg_values[0] = abs(semg_values[0] - 2048) + 2048;
}


final int [] RPY_minValue = {-180, -180, -180};
final int [] RPY_maxValue = {+180, +180, +180};

float [][][] rot_list = new float[3][3][3];
void mpu_convert() {
  
  
  mpu_values = quart_to_angle(mpu_values);
  
  
  /*
  for (int i = 0; i < mpu_channel; ++i) {
    mpu_values[i] = convert_to_int16((int) mpu_values[i]);
    if (mpu_values[i] < -180) mpu_values[i] += 360;
    if (mpu_values[i] > +180) mpu_values[i] -= 360;
  }
  

  if (tared) {
    
    for (int i = 0; i < mpu_channel; ++i) {
      mpu_values = angle_rotate(mpu_values, rot_list[i]);
      //if (mpu_values[i] < -180) mpu_values[i] += 360;
      //if (mpu_values[i] > +180) mpu_values[i] -= 360;
    }
   
    
    mpu_values = angle_rotate(mpu_values, rot_list[0]);
  }
     */ 
  
}

// Use the last value stored in pot_buffer to tare;
int [] mpu_angle_0d_diff = {0, 0, 0}; // The diff of angle when hand resting and 0d; 
void mpu_tare() {
  println("MPU Tared!");
  for (int i = 0; i < mpu_channel; ++i)
    mpu_angle_0d_diff[i] = (int) mpu_buffer[i][mpu_buffer_index] + mpu_angle_0d_diff[i];
   
  // P/R/Y = X/Y/Z ... R/P/Y = Y/X/Z
  rot_list[0] = get_rotate_Y(-mpu_angle_0d_diff[0]);
  rot_list[1] = get_rotate_X(-mpu_angle_0d_diff[1]); 
  rot_list[2] = get_rotate_Z(-mpu_angle_0d_diff[2]);
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

float[] angle_rotate(float [] ang, float [][] rot) {
  float[] res = new float[3];
  
  for (int i = 0; i < 3; ++i) {
    for (int j = 0; j < 3; ++j) {
      res[i] += rot[i][j] * ang[j];
    }
  }
  
  return res;
}

float[][] get_rotate_X(float ang) {
  float[][] rot = new float[][]{
    {1, 0, 0},
    {0, cos(ang), -sin(ang)},
    {0, sin(ang), cos(ang)}
  };
  
  return rot;
}


float[][] get_rotate_Y(float ang) {
  float[][] rot = new float[][]{
    {cos(ang), 0, sin(ang)},
    {0, 1, 0},
    {-sin(ang), 0, cos(ang)}
  };
  
  return rot;
}

float[][] get_rotate_Z(float ang) {
  float[][] rot = new float[][]{
    {cos(ang), -sin(ang), 0},
    {sin(ang), cos(ang),0},
    {0, 0, 1}
  };
  
  return rot;
}


float[] quart_to_angle(float [] q) {
  float a12, a22, a31, a32, a33; 
  float [] rpy = new float[3];
 
  a12 =   2.0f * (q[1] * q[2] + q[0] * q[3]);
  a22 =   q[0] * q[0] + q[1] * q[1] - q[2] * q[2] - q[3] * q[3];
  a31 =   2.0f * (q[0] * q[1] + q[2] * q[3]);
  a32 =   2.0f * (q[1] * q[3] - q[0] * q[2]);
  a33 =   q[0] * q[0] - q[1] * q[1] - q[2] * q[2] + q[3] * q[3];
  rpy[1] = -asin(a32);
  rpy[0]  = atan2(a31, a33);
  rpy[2]   = atan2(a12, a22);
  rpy[1] *= 180.0f / PI;
  rpy[2]   *= 180.0f / PI;
  rpy[2]   += 4.31f; // http://www.magnetic-declination.com/Myanmar/E-yaw/1625256.html#
  if (rpy[2] < 0) rpy[2]   += 360.0f; // Ensure yaw stays between 0 and 360
  rpy[2] -= 180.0f;  // Restrict yaw to [-180 180] like roll/pitch
  rpy[0] *= 180.0f / PI;
  
  return rpy;
}
