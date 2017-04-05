%%real time data plot from a serial port 
% This matlab script is for ploting a graph by accessing serial port data in
% real time. Change the com values and all variable values accroding to
% your requirements. Dont forget to add terminator in to your serial device program.
% This script can be modified to be used on any platform by changing the
% serialPort variable. 
% Author: Moidu thavot.

%%Clear all variables

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
tElapsed = toc(tStart)

%% Clean up the serial port
fclose(s);
delete(s);
clear s;


   %% Time specifications:
   StopTime = tElapsed*1000; 
   Fs = SampleSize/StopTime;                      % samples per msecond
   dt = 1/Fs;                     % mseconds per sample
                    % seconds
   t = (0:dt:StopTime-dt)';
   N = size(t,1);
   %% Fourier Transform:
   X = fftshift(fft(storage));
   %% Frequency specifications:
   dF = Fs/N;                      % hertz
   f = -Fs/2:dF:Fs/2-dF;           % hertz
   %% Plot the spectrum:
   figure;
   plot(f,abs(X)/N);
