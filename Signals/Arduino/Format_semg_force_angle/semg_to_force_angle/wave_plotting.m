% Constant
file_path = 'C:\Users\Dymnz\Desktop\sEMG\Signals\2017_8_29\';
filename = '1kg_90d.lvm';
SamplingRate = 1000; % 5kHz Sampling rate

% Read data from .lvm
datamat = lvmread(strcat(file_path, filename));

% Plot
plot(datamat(:, 1), datamat(:, 2));

title(sprintf('sEMG singal: %s', filename), 'FontSize', 20);
xlabel('time (sec)', 'FontSize', 20); ylabel('voltage (V)', 'FontSize', 20)
ylim([-10 10]);


disp(sprintf('avg amp. %f', mean(abs(datamat(:, 2)))));