function beep2()

res = 22050;

len = 0.2 * res;

hz = 1000;

sound( 0.2 .* sin( hz*(2*pi*(0:len)/res) ), res);
