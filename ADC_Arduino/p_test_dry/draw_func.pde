
final int[][] NN_color_list = {{255, 0, 0}, {0, 255, 0}};
final int[][] GT_color_list = {{255, 180, 180}, {180, 255, 180}};


///*
final int [] RPY_minValue = {-90, -90, -90};
final int [] RPY_maxValue = {90, 90, 90};
//*/

/*
final int semg_max_val = 2048 * 2;
final int [] RPY_minValue = { -1, -1};
final int [] RPY_maxValue = { 1, 1};
*/

int last_draw_idx = 0;
int max_valid_buffer_idx = 0;

float x = 0;
float last_x = 0;

int [] GT_last_height = new int[NN_channel];
int [] NN_last_height = new int[NN_channel];

void drawAll() {
  int draw_value;
  strokeWeight(4);

  max_valid_buffer_idx = get_max_valid_buffer_idx() % value_buffer_size;

  if (last_draw_idx < max_valid_buffer_idx) {
    RMSE = calculate_RMSE();
    fill(255); noStroke();
    rect(0, 0, 900, 100);
    String s = "Pitch error: " + str(round2(RMSE[0], 2)) + "°";
    
    fill(0); textSize(30);
    text(s, 0, 0, 900, 100);  // Text wraps within text box
  }

  while (last_draw_idx < max_valid_buffer_idx) {
    // Sanity check for synced NN-GT
   // for (int ch = 0; ch < NN_channel; ++ch) {
       /*
    for (int ch = 0; ch < 1; ++ch) {        
      if (NN_buffer_idx[ch] < max_valid_buffer_idx || GT_buffer_idx[ch] < NN_buffer_idx[ch]) {
        println("max_valid_buffer_idx: " + max_valid_buffer_idx);
        println("NN_buffer_idx: " + NN_buffer_idx[ch]);
        println("GT_buffer_idx: " + GT_buffer_idx[ch]);
        exit();
      }
    }
    */
    // Draw GT angles
    //for (int i = 0; i < NN_channel; ++i) {
    for (int i = 0; i < 1; ++i) {
      stroke(GT_color_list[i][0], GT_color_list[i][1], GT_color_list[i][2]);
      draw_value = int(map(GT_buffer[i][last_draw_idx % value_buffer_size], RPY_minValue[i], RPY_maxValue[i], 0, height));
      line(last_x, GT_last_height[i], x, height - draw_value);

      GT_last_height[i] = int(height - draw_value);
    }

    // Draw NN angles
    //for (int i = 0; i < NN_channel; ++i) {
    for (int i = 0; i < 1; ++i) {
      stroke(NN_color_list[i][0], NN_color_list[i][1], NN_color_list[i][2]);
      draw_value = int(map(NN_buffer[i][last_draw_idx % value_buffer_size], RPY_minValue[i], RPY_maxValue[i], 0, height));
      line(last_x, NN_last_height[i], x, height - draw_value);

      NN_last_height[i] = int(height - draw_value);
    }
    ++last_draw_idx;

    last_x = x;
    x += graph_x_step;

  }

  if (x >= width) {
    x = 0;
    last_x = 0;
    resetGraph();
  }
}

void resetGraph() {
  background(255);
  strokeWeight(2);
  
  stroke(0); 
  line(0, height / 2, width, height / 2);
}


int get_max_valid_buffer_idx() {

  int max_valid_idx = GT_buffer_idx[0];

  // Find min for NN
  for (int ch = 0; ch < NN_channel; ++ch) {
    max_valid_idx = min(max_valid_idx, NN_buffer_idx[ch]);
  }

  // Find min for GT
  for (int ch = 0; ch < NN_channel; ++ch) {
    max_valid_idx = min(max_valid_idx, GT_buffer_idx[ch]);
  }

  return max_valid_idx;
}

float round2(float number, int scale) {
    int pow = 10;
    for (int i = 1; i < scale; i++)
        pow *= 10;
    float tmp = number * pow;
    return ( (float) ( (int) ((tmp - (int) tmp) >= 0.5f ? tmp + 1 : tmp) ) ) / pow;
}
