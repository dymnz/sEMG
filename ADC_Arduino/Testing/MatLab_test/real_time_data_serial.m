clear all;   
snew = instrfind;
fclose(snew);

%%Variables (Edit yourself)

SerialPort='/dev/cu.usbmodem1411'; %serial port
SampleSize = 10000;
fs = 10000;

s = serial(SerialPort, 'BaudRate', 115200);
fopen(s);


storage = zeros(SampleSize, 1);
for i = 1 : SampleSize
    storage(i) = fscanf(s, '%d');
end
tElapsed = SampleSize/fs;

%% Clean up the serial port
fclose(s);
delete(s);
clear s;

SPS = round(SampleSize/tElapsed);

scatter(1:1:SampleSize, storage);