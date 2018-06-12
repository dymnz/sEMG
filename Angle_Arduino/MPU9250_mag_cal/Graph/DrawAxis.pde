int xPos = 0;    // horizontal graph position
// variables to draw a continuous line
int lastxPos = 1;
int lastHeight = 0;

//https://forum.processing.org/two/discussion/6738/reduce-delay-in-writing-data-to-a-graph
void drawAxisX() {
	// Draw a line from last inByte to new one
	
	strokeWeight(5);
    
  while (draw_index < buffer_index) {
    stroke(255, 0, 0);
    point(convertHeight(value_buffer[0][draw_index]), convertHeight(value_buffer[1][draw_index]));
    
    stroke(0, 255, 0);
    point(convertHeight(value_buffer[0][draw_index]), convertHeight(value_buffer[2][draw_index]));
    
    stroke(0, 0, 255);
    point(convertHeight(value_buffer[1][draw_index]), convertHeight(value_buffer[2][draw_index]));
    
    ++draw_index;
  }
  buffer_index = 0;
  draw_index = 0;
}


final int minValue = -1024;
final int maxValue = 1024;

int convertHeight(int value) {
  return int(map(value, minValue, maxValue, 0, height));
}

int convertWidth(int value) {
  return int(map(value, minValue, maxValue, 0, width));
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

int[] mag_max = {-32760, -32760, -32760};
int[] mag_min = {32760, 32760, 32760};
int[] mag_bias = {0, 0, 0};
float[] mag_scale = {0, 0, 0};

void bias_calc() {
   // Get hard iron correction
  

  
  for (int i = 0; i < channel; ++i) {
    if (read_values[i] > mag_max[i])
      mag_max[i] = read_values[i];
    if (read_values[i] < mag_min[i])
      mag_min[i] = read_values[i];
      
    mag_bias[i]  = (mag_max[i] + mag_min[i]) / 2;
    mag_scale[i] = (mag_max[i] - mag_min[i]) / 2;
    
  }
  
  float avg_rad = mag_scale[0] + mag_scale[1] + mag_scale[2];
  avg_rad /= 3.0;
  
  for (int i = 0; i < channel; ++i)
      mag_scale[i] = avg_rad / mag_scale[i];
}
