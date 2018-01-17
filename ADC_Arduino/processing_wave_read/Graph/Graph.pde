import processing.serial.*;
Serial serial;

final int channel = 1;
final int width = 800;
final int height = 600;

int[] values = new int[channel];

int currentTime = 0;
int lastTime = 0;
int sampleCount = 0;

int serialCount = 0;
char[] rawPacket = new char[channel * 2];

boolean drawValues  = false;

void setup() {
	size(800, 600);
	background(0);
	frameRate(1200);
	println(Serial.list()); // Use this to print connected serial devices
	serial = new Serial(this, Serial.list()[1], 2000000); // Set this to your serial port obtained using the line above

	for (int i = 0; i < width; i++) { // center all variables
		graphValue[i] = height / 2;
	}

	drawGraph(); // Draw graph at startup
}

void draw() {
	/* Draw Graph */
	if (drawValues) {
		drawValues = false;
		drawGraph();
	}
}

void drawGraph() {
	//for (int i = 0; i < width; i++) {
	//  stroke(200); // Grey
	//  line(i*10, 0, i*10, height);
	//  line(0, i*10, width, i*10);
	//}

	//stroke(0); // Black
	//for (int i = 1; i <= 3; i++)
	//  line(0, height/4*i, width, height/4*i); // Draw line, indicating -90 deg, 0 deg and 90 deg

	convert();
	drawAxisX();
}

void serialEvent () {
	while (serial.available() > 0) {
		int ch = serial.read();
		rawPacket[serialCount++] = (char)ch;

		if (serialCount < 2)
			continue;

		serialCount = 0;

		values[0] = (rawPacket[0] << 8) | rawPacket[1];

		drawValues = true; // Draw the graph

		//printAxis(); // Used for debugging
		//println(values[0]);

		sampleCount++;
		currentTime = millis();
		if (currentTime - lastTime > 1000) {
			println(sampleCount);
			lastTime = millis();
			sampleCount = 0;
		}
	}
}

void ReceivePrint1() {
	while (serial.available() > 0) {
		int ch = serial.read();
		rawPacket[serialCount++] = (char)ch;

		if (serialCount < 2)
			continue;

		serialCount = 0;

		values[0] = (rawPacket[0] << 8) | rawPacket[1];

		drawValues = true; // Draw the graph

		//printAxis(); // Used for debugging
		//println(values[0]);

		//sampleCount++;
		//currentTime = millis();
		//if (currentTime - lastTime > 1000)
		//{
		//  println(sampleCount);
		//  lastTime = millis();
		//  sampleCount = 0;
		//}
	}
}