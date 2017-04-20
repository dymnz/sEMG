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
SampleSize = 10000;
N = SampleSize;
storage = zeros(SampleSize, 1);

%% Start reading
s = serial(SerialPort, 'BaudRate', 115200);
fopen(s);
flushinput(s);
fprintf(s,'g'); % Signal Arduino to start
for i = 1 : SampleSize
    storage(i) = fscanf(s, '%d');
end

%% Clean up the serial port
fclose(s);
delete(s);
clear s;

%% Plot
plot([1:SampleSize], storage, '-o');

