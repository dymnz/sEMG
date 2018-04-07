float x = 0;
float semg_last_x = 1;
float force_last_x = 1;
float mpu_last_x = 1;

int[] semg_last_height = new int[semg_channel];
int[] mpu_last_height = new int[mpu_channel];

final int[][] semg_color_list = {{255, 120, 120}, {120, 255, 120}, {120, 120, 255}};
final int[][] mpu_color_list = {{30, 30, 255}, {140, 140, 255}};

String buffer_str = ""; 

//https://forum.processing.org/two/discussion/6738/reduce-delay-in-writing-data-to-a-graph
void drawAll() {
  int draw_value;
  strokeWeight(4);
  //println(semg_buffer_index, force_buffer_index);
  while (semg_draw_index < semg_buffer_index) {
    buffer_str = "";
    for (int i = 0; i < semg_channel; ++i) {     
      draw_value = int(map(semg_buffer[i][semg_draw_index], semg_minValue, semg_maxValue, 0, height));
      stroke(semg_color_list[i][0], semg_color_list[i][1], semg_color_list[i][2]);
      line(semg_last_x, semg_last_height[i], x, height - draw_value);
      
      semg_last_height[i] = int(height - draw_value);
      
      buffer_str += semg_buffer[i][semg_draw_index] + ",";
    }
    ++semg_draw_index;

    if (mpu_draw_index < mpu_buffer_index) {      
      for (int i = 0; i < mpu_channel; ++i) {
        stroke(semg_color_list[i][0], semg_color_list[i][1], semg_color_list[i][2]);
        draw_value = int(map(mpu_buffer[i][mpu_draw_index], angle_minValue, angle_maxValue, 0, height));
        line(mpu_last_x, mpu_last_height[i], x, height - draw_value);
        
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

    file.println(buffer_str);
  }

    
  if (x >= width) {
    x = 0;
    semg_last_x = 0;
    force_last_x = 0;
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
  strokeWeight(1);
  /*
  stroke(220); 
  for (int i = 0; i < width; i += grid_size) {
    line(i, 0, i, height);
  }
  for (int i = 0; i < height; i += grid_size) {
    line(0, i, width, i);
  }
  */
  strokeWeight(1);
  
  stroke(0); 
  line(0, height / 2, width, height / 2);


  /*
  stroke(0, 0, 100);   
  for (int i = 1; i < force_maxValue; ++i) {
    int y = int(map(i, force_minValue, force_maxValue, 0, height));
    line(0, height - y, width, height - y);
    line(0, y, width, y);
  }
  */ 
  stroke(130, 130, 130);
  for (int i = angle_maxValue + angle_minValue; i < angle_maxValue - angle_minValue; i+=15) {
    int y = int(map(i, angle_maxValue + angle_minValue, angle_maxValue - angle_minValue, 0, height));
    line(0, height - y, width, height - y);
    line(0, y, width, y);
  }
}

final int semg_minValue = 0;
final int semg_maxValue = 4096;
void semg_convert() {
}

final int semg_minValue_abs = -2048;
final int semg_maxValue_abs = 2048;
void semg_convert_abs() {
  semg_values[0] = abs(semg_values[0] - 2048) + 2048;  
}


final int angle_minValue = -180;
final int angle_maxValue = 180;
void angle_convert() {
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