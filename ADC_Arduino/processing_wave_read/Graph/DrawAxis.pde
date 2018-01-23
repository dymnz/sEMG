int xPos = 0;    // horizontal graph position
// variables to draw a continuous line
int lastxPos = 1;
int lastHeight = 0;

//https://forum.processing.org/two/discussion/6738/reduce-delay-in-writing-data-to-a-graph
void drawAxisX() {
	// Draw a line from last inByte to new one
	stroke(255, 255, 255);
	strokeWeight(1);

  while (draw_index < buffer_index) {
  	int draw_value = value_buffer[0][draw_index];
   	line(lastxPos, lastHeight, xPos, height - draw_value);
  	
    lastxPos = xPos;
    lastHeight = int(height - draw_value);
    
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


final int minValue = 0;
final int maxValue = 4096;

void convert() {
  // Convert to a float and map to the screen height, then save in buffer
  read_values[0] = int(map(read_values[0], minValue, maxValue, 0, height));
}