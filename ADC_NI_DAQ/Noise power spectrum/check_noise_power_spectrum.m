% Constant
file_path = '/Users/wangshunxing/Work/PortableSEMG/Signals/';
filename = '1.lvm';
fs = 5000; % 5kHz Sampling rate
StartT = 3; EndT = 6;
NoiseRange = [StartT*fs:1:EndT*fsg];
Length = length(NoiseRange);

% Read data from .lvm
datamat = lvmread(strcat(file_path, filename));
noise = datamat(NoiseRange, 2);

% Plot the original signal
plot(noise);

title(sprintf('sEMG singal: %s', filename), 'FontSize', 20);
xlabel('samples', 'FontSize', 20); ylabel('voltage (V)', 'FontSize', 20)
ylim([-10 10])

% Power spectrum
X = fftshift(fft(noise));
fshift = (-Length/2:Length/2-1)*(fs/Length); % zero-centered frequency range
powershift = 20*log10(abs(X));     % zero-centered power
figure;
semilogx(fshift, powershift, '-')

title('FFT of Noise', 'FontSize', 20)
xlabel('Frequency (Hz)', 'FontSize', 20)
ylabel('Magnitude (dB)', 'FontSize', 20)