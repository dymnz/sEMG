% Constant
file_path = '/home/dymnz/Documents/sEMG/Signals/';
filename = '4kg_2.lvm';
SamplingRate = 1000; % 1kHz Sampling rate

% Read data from .lvm
datamat = lvmread(strcat(file_path, filename));

% Remove mean
datamat(:, 2) = datamat(:, 2) - mean(datamat(:, 2));
disp(sprintf('avg amp. %f', mean(abs(datamat(:, 2)))));

% Plot
plot(datamat(:, 1), datamat(:, 2));

title(sprintf('sEMG singal: %s', filename), 'FontSize', 20);
xlabel('time (sec)', 'FontSize', 20); ylabel('voltage (V)', 'FontSize', 20)
ylim([-10 10])


hold on;


file_path = '/home/dymnz/Documents/sEMG/Signals/';
filename = '3kg_2.lvm';
SamplingRate = 1000; % 5kHz Sampling rate

% Read data from .lvm
datamat = lvmread(strcat(file_path, filename));

% Plot
plot(datamat(:, 1), datamat(:, 2));

% Remove mean
datamat(:, 2) = datamat(:, 2) - mean(datamat(:, 2));
disp(sprintf('avg amp. %f', mean(abs(datamat(:, 2)))));

title(sprintf('sEMG singal: %s', filename), 'FontSize', 20);
xlabel('time (sec)', 'FontSize', 20); ylabel('voltage (V)', 'FontSize', 20)
ylim([-10 10])