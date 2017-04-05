clear all;   
snew = instrfind;
fclose(snew);
%%Variables (Edit yourself)

SerialPort='/dev/cu.usbmodem1421'; %serial port
SampleSize = 3000;

s = serial(SerialPort, 'BaudRate', 115200);
fopen(s);


storage = zeros(SampleSize, 1);
tStart = tic;
for i = 1 : SampleSize
      
    storage(i) = fscanf(s, '%d');
end
tElapsed = toc(tStart);

%% Clean up the serial port
fclose(s);
delete(s);
clear s;

SPS = round(SampleSize/tElapsed);

plot(storage);
axis([0 3000 0 4096])