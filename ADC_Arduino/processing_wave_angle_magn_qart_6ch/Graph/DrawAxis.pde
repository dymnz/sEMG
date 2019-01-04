float x = 0;
float semg_last_x = 1;
float pot_last_x = 1;
float mpu_last_x = 1;

int[] semg_last_height = new int[semg_channel];
int[] mpu_last_height = new int[quat_channel];

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
      line(semg_last_x, semg_last_height[i], x, height - draw_value);

      semg_last_height[i] = int(height - draw_value);

      buffer_str += semg_buffer[i][semg_draw_index] + ",";
    }
    ++semg_draw_index;

    if (mpu_draw_index < angle_buffer_index) {      
      for (int i = 0; i < angle_channel - 1; ++i) {
        stroke(mpu_color_list[i][0], mpu_color_list[i][1], mpu_color_list[i][2]);
        draw_value = int(map(angle_buffer[i][mpu_draw_index], RPY_minValue[i], RPY_maxValue[i], 0, height));
        line(mpu_last_x, mpu_last_height[i], x, height - draw_value);

        mpu_last_height[i] = int(height - draw_value);

        buffer_str += angle_buffer[i][mpu_draw_index] + ",";
      }
      ++mpu_draw_index;
      mpu_last_x = x;
    } else {
        /*
      for (int i = 0; i < angle_channel - 1; ++i)
        buffer_str +=  "0.0,";
        */
        
        // Not appending extra 0 to show that there's not angle data in this sample
        buffer_str +=  "0";
        
    }

    semg_last_x = x;    
    x += graph_x_step;

    if (quat_tared == true)
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
  angle_buffer_index = 0;      
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

void quat_convert() {
  
  
  if (quat_tared) {
    quat_values = quat_derotate(derotate_q, quat_values);
  }
  radian_values = quat2radian(quat_values);
  
  // P' = P*cos(R) - Y*sin(R);
  /*
  radian_values[1] = radian_values[1] * cos(radian_values[0]) - 
                     radian_values[2] * sin(radian_values[0]);
  */
  
  angle_values = radian2degree(radian_values);
  
  
  /*
  for (int i = 0; i < quat_channel; ++i) {
    quat_values[i] = convert2int16((int) quat_values[i]);
    if (quat_values[i] < -180) quat_values[i] += 360;
    if (quat_values[i] > +180) quat_values[i] -= 360;
  }
  

  
    
    for (int i = 0; i < quat_channel; ++i) {
      quat_values = angle_rotate(quat_values, rot_list[i]);
      //if (quat_values[i] < -180) quat_values[i] += 360;
      //if (quat_values[i] > +180) quat_values[i] -= 360;
    }
   
    
    quat_values = angle_rotate(quat_values, rot_list[0]);
  }
     */ 
  
}



void writeAll() {
}

int convert2int16(int num) {
  boolean negative = (num & (1 << 15)) != 0;
  int converted_int;

  if (negative)
    converted_int = num | 0xFFFF0000;
  else
    converted_int = num;

  return converted_int;
}


// Use the last value stored in pot_buffer to tare;
float [] derotate_q = new float [4];
void mpu_tare() {
  derotate_q = quat2conj(quat_values);
}

float [] quat2radian(float [] q) {
  float a12, a22, a31, a32, a33; 
  float [] rpy = new float[3];
 
  a12 =   2.0f * (q[1] * q[2] + q[0] * q[3]);
  a22 =   q[0] * q[0] + q[1] * q[1] - q[2] * q[2] - q[3] * q[3];
  a31 =   2.0f * (q[0] * q[1] + q[2] * q[3]);
  a32 =   2.0f * (q[1] * q[3] - q[0] * q[2]);
  a33 =   q[0] * q[0] - q[1] * q[1] - q[2] * q[2] + q[3] * q[3];
  
  rpy[0]  = atan2(a31, a33);
  rpy[1] = -asin(a32);
  rpy[2]   = atan2(a12, a22);
  
  return rpy;
}

float [] radian2degree(float [] rpy) {
  rpy[0] *= 180.0f / PI;
  rpy[1] *= 180.0f / PI;
  
  rpy[2]   *= 180.0f / PI;
  rpy[2]   += 4.31f; // http://www.magnetic-declination.com/Myanmar/E-yaw/1625256.html#
  if (rpy[2] < 0) rpy[2]   += 360.0f; // Ensure yaw stays between 0 and 360
  rpy[2] -= 180.0f;  // Restrict yaw to [-180 180] like roll/pitch
  
  return rpy;
}


float [] quat2conj(float [] q) {
  float [] qc = {q[0], -q[1], -q[2], -q[3]};
  
  return qc;
}

float [] quat_derotate(float [] p, float [] q) {
  float [] r = new float[4];
  float pw, px, py, pz, qw, qx, qy, qz;
  
  pw = p[0]; px = p[1]; py = p[2]; pz = p[3];
  qw = q[0]; qx = q[1]; qy = q[2]; qz = q[3];
  
  r[0] = pw*qw - px*qx - py*qy - pz*qz;
  r[1] = pw*qx + px*qw + py*qz - pz*qy;
  r[2] = pw*qy - px*qz + py*qw + pz*qx;
  r[3] = pw*qz + px*qy - py*qx + pz*qw;
  
  return r;
}
