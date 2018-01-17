int xPos = 0;    // horizontal graph position
// variables to draw a continuous line
int lastxPos = 1;
int lastHeight = 0;


//https://forum.processing.org/two/discussion/6738/reduce-delay-in-writing-data-to-a-graph
void drawAxisX() {
	// Draw a line from last inByte to new one
	stroke(255, 255, 255);
	strokeWeight(1);
	int inByte = graphValue[graphValue.length - 1];
	line(lastxPos, lastHeight, xPos, height - inByte);
	lastxPos = xPos;
	lastHeight = int(height - inByte);

	xPos++;
	// return to beginning of frame once boundary has been reached
	if (xPos >= width) {
		xPos = 0;
		lastxPos = 0;
		background(0);
	}
}

void drawAxisX_old() {
	/* Draw gyro x-axis */
	noFill();
	stroke(255, 0, 0); // Red
	// Redraw everything
	beginShape();
	vertex(0, graphValue[0]);
	for (int i = 1; i < graphValue.length; i++) {
		if ((graphValue[i] < height / 4 && graphValue[i - 1] > height / 4 * 3) || (graphValue[i] > height / 4 * 3 && graphValue[i - 1] < height / 4)) {
			endShape();
			beginShape();
		}
		vertex(i, graphValue[i]);
	}
	endShape();

	// Put all data one array back
	for (int i = 1; i < graphValue.length; i++)
		graphValue[i - 1] = graphValue[i];
}