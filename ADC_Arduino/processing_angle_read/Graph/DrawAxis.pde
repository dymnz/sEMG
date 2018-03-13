float x = 0;
float semg_last_x = 1;
float force_last_x = 1;

int[] semg_last_height = new int[semg_channel];
int[] force_last_height = new int[force_channel];

final int[][] semg_color_list = {{255, 120, 120}, {120, 255, 120}, {120, 120, 255}};

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

    if (force_draw_index < force_buffer_index) {
      stroke(0, 0, 255);
      for (int i = 0; i < force_channel; ++i) {        
        draw_value = int(map(force_buffer[i][force_draw_index], force_minValue, force_maxValue, 0, height));
        line(force_last_x, force_last_height[i], x, height - draw_value);
        
        force_last_height[i] = int(height - draw_value);
        
        buffer_str += force_buffer[i][force_draw_index] + ",";
      }
      ++force_draw_index;
      force_last_x = x;
    } else {
      buffer_str += 0 + ",";
    }
    
    semg_last_x = x;    
    x += graph_x_step;
    println(mpu_values[0]);
    file.println(buffer_str);
  }
  if (force_draw_index < force_buffer_index) {    
    println("Error: Some force data point aren't drawn");
    //exit();
  }
    
  if (x >= width) {
    x = 0;
    semg_last_x = 0;
    force_last_x = 0;
    resetGraph();
  }  
    
  force_buffer_index = 0;      
  force_draw_index = 0;
  semg_buffer_index = 0;      
  semg_draw_index = 0;
    
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

  stroke(220);   
  for (int i = 1; i < force_maxValue; ++i) {
    int y = int(map(i, force_minValue, force_maxValue, 0, height));
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

final int force_minValue = -5;
final int force_maxValue = 5;
void force_convert() {
  force_values[0] = force_values[0] / force_calibration_factor;  
}


void writeAll() {
  
}