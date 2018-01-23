int xPos = 0;    // horizontal graph position
// variables to draw a continuous line
int lastxPos = 1;
int[] lastHeight = new int[total_channel];

//https://forum.processing.org/two/discussion/6738/reduce-delay-in-writing-data-to-a-graph
void drawAxisX() {
	// Draw a line from last inByte to new one
	stroke(255, 255, 255);
	strokeWeight(1);

  while (draw_index < buffer_index) {
    for (int i = 0; i < total_channel; ++i) {      

    	int draw_value = value_buffer[i][draw_index];
     	line(lastxPos, lastHeight[i], xPos, height - draw_value);
      //println(lastxPos, lastHeight[i], xPos, height - draw_value);
      lastHeight[i] = int(height - draw_value);
    }
    lastxPos = xPos;
    ++xPos;  
    ++draw_index;
    
    // return to beginning of frame once boundary has been reached
    if (xPos >= width) {
      xPos = 0;
      lastxPos = 0;
      background(0);
    }    
  }
  buffer_index = 0;
  draw_index = 0;
}


final int semg_minValue = 0;
final int semg_maxValue = 4096;
final int force_minValue = -5;
final int force_maxValue = 5;

void convert() {
  // Convert to a float and map to the screen height, then save in buffer
  
  force_values[0] = force_values[0] / force_calibration_factor;
  force_values[0] = map(force_values[0], force_minValue, force_maxValue, 0, height);
  
  semg_values[0] = int(map(semg_values[0], semg_minValue, semg_maxValue, 0, height));
}