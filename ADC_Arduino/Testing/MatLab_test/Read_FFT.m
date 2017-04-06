%%real time data plot from a serial port 
% This matlab script is for ploting a graph by accessing serial port data in
% real time. Change the com values and all variable values accroding to
% your requirements. Dont forget to add terminator in to your serial device program.
% This script can be modified to be used on any platform by changing the
% serialPort variable. 
% Author: Moidu thavot.

%% Init all variables

clear all;   
snew = instrfind;
fclose(snew);

SerialPort='/dev/cu.usbmodem1411'; %serial port
SampleSize = 10000;

s = serial(SerialPort, 'BaudRate', 115200);
fopen(s);

%% Start reading
storage = zeros(SampleSize, 1);
tStart = tic;
for i = 1 : SampleSize
      
    storage(i) = fscanf(s, '%d');
end
tElapsed = toc(tStart)

%% Clean up the serial port
fclose(s);
delete(s);
clear s;


%% Time specifications:
StopTime = tElapsed; 
N = SampleSize;
fs = 10000;      % samples per second

%% Fourier Transform:
% X = fftshift(fft(storage));
X = fft(storage);
f = (0:N-1)*(fs/N);     %frequency range
power = abs(X).^2/N;    %power
plot(f,power)


% 
% fshift = (-N/2:N/2-1)*(fs/N); % zero-centered frequency range
% powershift = abs(X);     % zero-centered power
% figure;
% plot(fshift, powershift)