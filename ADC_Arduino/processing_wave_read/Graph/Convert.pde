//convert all axis
final int minAngle = 0;
final int maxAngle = 4096;

void convert() {

	graphValue[graphValue.length - 1] = int(map(values[0], minAngle, maxAngle, 0, height)); // Convert to a float and map to the screen height, then save in buffer

}