// Use the last value stored in pot_buffer to tare;

float [] derotate_q = new float [4];

void quat_convert() {
  if (quat_tared) {
    quat_values = quat_derotate(derotate_q, quat_values);
  }
  radian_values = quat2radian(quat_values);

  // P' = P*cos(R) - Y*sin(R);
  ///*
  radian_values[1] = radian_values[1] * cos(radian_values[0]) -
                     radian_values[2] * sin(radian_values[0]);
  //*/

  angle_values = radian2degree(radian_values);
}

void quat_tare(float [] quat_values) {
  derotate_q = quat2conj(quat_values);
}

float [] quat2radian(float [] q) {
  float a12, a22, a31, a32, a33;
  float [] rpy = new float[3];

  a12 =   2.0f * (q[1] * q[2] + q[0] * q[3]);
  a22 =   q[0] * q[0] + q[1] * q[1] - q[2] * q[2] - q[3] * q[3];
  a31 =   2.0f * (q[0] * q[1] + q[2] * q[3]);
  a32 =   2.0f * (q[1] * q[3] - q[0] * q[2]);
  a33 =   q[0] * q[0] - q[1] * q[1] - q[2] * q[2] + q[3] * q[3];

  rpy[0]  = atan2(a31, a33);
  rpy[1] = -asin(a32);
  rpy[2]   = atan2(a12, a22);

  return rpy;
}

float [] radian2degree(float [] rpy) {
  rpy[0] *= 180.0f / PI;
  rpy[1] *= 180.0f / PI;

  rpy[2]   *= 180.0f / PI;
  rpy[2]   += 4.31f; // http://www.magnetic-declination.com/Myanmar/E-yaw/1625256.html#
  if (rpy[2] < 0) rpy[2]   += 360.0f; // Ensure yaw stays between 0 and 360
  rpy[2] -= 180.0f;  // Restrict yaw to [-180 180] like roll/pitch

  return rpy;
}


float [] quat2conj(float [] q) {
  float [] qc = {q[0], -q[1], -q[2], -q[3]};

  return qc;
}

float [] quat_derotate(float [] p, float [] q) {
  float [] r = new float[4];
  float pw, px, py, pz, qw, qx, qy, qz;

  pw = p[0]; px = p[1]; py = p[2]; pz = p[3];
  qw = q[0]; qx = q[1]; qy = q[2]; qz = q[3];

  r[0] = pw * qw - px * qx - py * qy - pz * qz;
  r[1] = pw * qx + px * qw + py * qz - pz * qy;
  r[2] = pw * qy - px * qz + py * qw + pz * qx;
  r[3] = pw * qz + px * qy - py * qx + pz * qw;

  return r;
}
