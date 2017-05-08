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
storage(1) = storage(2);    % Sometimes the first data is 0
plot([1:SampleSize], storage, '-o');

%% Interval prob
minV = min(storage);
maxV = min(max(storage), minV+10);
a = zeros(maxV-minV+1, 1);
for i = 0 : maxV-minV
 a(i+1) = length(find(storage==minV+i))/length(storage);
end 
plot(linspace(minV,maxV, maxV-minV+1), a, '-o');
ylim([0 1]);


title('micros() call prob.', 'FontSize', 20)
xlabel('microseconds', 'FontSize', 20)
ylabel('prob', 'FontSize', 20)

