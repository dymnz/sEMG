float x = 0;
float semg_last_x = 1;
float force_last_x = 1;

int[] semg_last_height = new int[semg_channel];
int[] force_last_height = new int[force_channel];

//https://forum.processing.org/two/discussion/6738/reduce-delay-in-writing-data-to-a-graph
void drawAll() {
  strokeWeight(4);

  while (semg_draw_index < semg_buffer_index) {
    stroke(255, 0, 0);
    for (int i = 0; i < semg_channel; ++i) {      
      int draw_value = semg_buffer[i][semg_draw_index];
      line(semg_last_x, semg_last_height[i], x, height - draw_value);
      
      semg_last_height[i] = int(height - draw_value);
    }
    ++semg_draw_index;
        
    if (force_draw_index < force_buffer_index) {
      stroke(0, 0, 255);
      for (int i = 0; i < force_channel; ++i) {        
        int draw_value = force_buffer[i][force_draw_index];
        line(force_last_x, force_last_height[i], x, height - draw_value);
        
        force_last_height[i] = int(height - draw_value);      
      }
      ++force_draw_index;
      force_last_x = x;
    }    
    
    semg_last_x = x;
    x += graph_x_step;   
  }
  if (force_draw_index < force_buffer_index) {    
    println("Some force data point aren't drawn!!!!!!");
    delay(999999);
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
  // Convert to a float and map to the screen height, then save in buffer
  semg_values[0] = int(map(semg_values[0], semg_minValue, semg_maxValue, 0, height));
}

final int semg_minValue_abs = -2048;
final int semg_maxValue_abs = 2048;
void semg_convert_abs() {
  // Convert to a float and map to the screen height, then save in buffer
  semg_values[0] = abs(semg_values[0] - 2048) + 2048;
  semg_values[0] = int(map(semg_values[0], semg_minValue_abs, semg_maxValue_abs, 0, height));
}

final int force_minValue = -10;
final int force_maxValue = 10;
void force_convert() {
  // Convert to a float and map to the screen height, then save in buffer
  force_values[0] = force_values[0] / force_calibration_factor;
  force_values[0] = map(force_values[0], force_minValue, force_maxValue, 0, height);
}