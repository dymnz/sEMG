% Read samples from serial port and plot the samples
% Modified from code by Moidu thavot.


%% Clear serial port connection
clear all;   
snew = instrfind;
if ~isempty(snew)
    fclose(snew);
end

%% Init all variables
SerialPort='/dev/cu.usbmodem1411'; %serial port
SampleSize = 1000;
N = SampleSize;

%% Start reading
s = serial(SerialPort, 'BaudRate', 115200);
fopen(s);

storage = zeros(SampleSize, 1);
for i = 1 : SampleSize
    storage(i) = fscanf(s, '%d');
end

%% Clean up the serial port
fclose(s);
delete(s);
clear s;

%% Plot
% scatter(1:1:SampleSize, storage);
plot([1:SampleSize], storage, '-o');