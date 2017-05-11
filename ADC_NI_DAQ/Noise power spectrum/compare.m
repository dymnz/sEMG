% Constant
file_path = '/Users/wangshunxing/Work/PortableSEMG/Signals/';
filename = '1.lvm';
fs = 5000; % 5kHz Sampling rate
StartT = 3; EndT = 6;
SignalRange = [StartT*fs:1:EndT*fs];
Length = length(SignalRange);

% Read data from .lvm
datamat = lvmread(strcat(file_path, filename));
signal = datamat(SignalRange, 2);

% Plot the original signal
plot(signal);

title(sprintf('sEMG singal: %s', filename), 'FontSize', 20);
xlabel('samples', 'FontSize', 20); ylabel('voltage (V)', 'FontSize', 20)
ylim([-10 10])
hold on;

% Constant
file_path = '/Users/wangshunxing/Work/PortableSEMG/Signals/';
filename = '1.lvm';
fs = 5000; % 5kHz Sampling rate
StartT = 1; EndT = 2;
SignalRange = [StartT*fs:1:EndT*fs];
Length = length(SignalRange);

% Read data from .lvm
datamat = lvmread(strcat(file_path, filename));
signal = datamat(SignalRange, 2);

% Plot the original signal
plot(signal);

title(sprintf('sEMG singal: %s', filename), 'FontSize', 20);
xlabel('samples', 'FontSize', 20); ylabel('voltage (V)', 'FontSize', 20)
ylim([-10 10])

