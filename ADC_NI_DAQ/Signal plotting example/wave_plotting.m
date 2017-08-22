% Constant
file_path = '/home/dymnz/Documents/sEMG/Signals/';
filename = '1kg.lvm';
SamplingRate = 1000; % 5kHz Sampling rate

% Read data from .lvm
datamat = lvmread(strcat(file_path, filename));

% Plot
plot(datamat(:, 1), datamat(:, 2));

title(sprintf('sEMG singal: %s', filename), 'FontSize', 20);
xlabel('time (sec)', 'FontSize', 20); ylabel('voltage (V)', 'FontSize', 20)
ylim([-10 10]);


disp(sprintf('avg amp. %f', mean(abs(datamat(:, 2)))));