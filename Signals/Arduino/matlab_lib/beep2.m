function beep2()

res = 22050;

len = res * 10;

hz = 1600;
lhz = 2;
ahz = 800;

X = 0.8 .* sin( hz*(2*pi*(0:len)/res) ) .* sin( lhz*(2*pi*(0:len)/res) ) .*...
    sin( ahz*(2*pi*(0:len)/res) );
sound(X , res);
