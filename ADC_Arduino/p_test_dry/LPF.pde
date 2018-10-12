/* Digital filter designed by mkfilter/mkshape/gencode   A.J. Fisher
   Command line: /www/usr/fisher/helpers/mkfilter -Bu -Lp -o 6 -a 1.4000000000e-02 0.0000000000e+00 -l */

final int NZEROS = 1;
final int NPOLES = 1;
final float GAIN = 1.211091000e1;

float [] xv[] = new float[angle_channel][NZEROS + 1];
float [] yv[] = new float[angle_channel][NPOLES + 1];


// 6th order butterworth LPF w/ 35Hz -3db @ 2500Hz
float LPF_step(int ch, float next_val) {
    xv[ch][0] = xv[ch][1];
    xv[ch][1] = next_val / GAIN;
    yv[ch][0] = yv[ch][1];
    yv[ch][1] =   (xv[ch][0] + xv[ch][1])
                     + (  0.8348596431 * yv[ch][0]);
    return yv[ch][1];
}
