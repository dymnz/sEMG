clear; close all;

%% Part 1
file_path = '..\..\Signals\2017_8_29\1\';
filenames = {'1kg_90d.lvm', '2kg_90d.lvm', '3kg_90d.lvm', '4kg_90d.lvm'};

mean_amps = zeros(length(filenames), 1);
for i =  1:length(filenames)

% Read data from .lvm
datamat = lvmread(strcat(file_path, filenames{i}));

% Remove mean
datamat(:, 2) = datamat(:, 2) - mean(datamat(:, 2));
mean_amp = mean(abs(datamat(:, 2)));

mean_amps(i) = mean_amp;
end

figure;
plot([1: length(filenames)], mean_amps, '-o');


hold on;

%% Part 2
file_path = '..\..\Signals\2017_8_30\';
filenames = {'1kg_105d.lvm', '2kg_105d.lvm', '3kg_105d.lvm', '4kg_105d.lvm'};

mean_amps = zeros(length(filenames), 1);
for i =  1:length(filenames)

% Read data from .lvm
datamat = lvmread(strcat(file_path, filenames{i}));

% Remove mean
datamat(:, 2) = datamat(:, 2) - mean(datamat(:, 2));
mean_amp = mean(abs(datamat(:, 2)));

mean_amps(i) = mean_amp;
end

plot([1: length(filenames)], mean_amps, '-o');

%% Part 3
file_path = '..\..\Signals\2017_8_29\2\';
filenames = {'1kg_135d.lvm', '2kg_135d.lvm', '3kg_135d.lvm', '4kg_135d.lvm'};

mean_amps = zeros(length(filenames), 1);
for i =  1:length(filenames)

% Read data from .lvm
datamat = lvmread(strcat(file_path, filenames{i}));

% Remove mean
datamat(:, 2) = datamat(:, 2) - mean(datamat(:, 2));
mean_amp = mean(abs(datamat(:, 2)));

mean_amps(i) = mean_amp;
end

plot([1: length(filenames)], mean_amps, '-o');

ylim([0 2]);
xlim([1 length(filenames)]);
title('90d vs 105d vs 135d raw', 'FontSize', 22);
xlabel('weight (kg)', 'FontSize', 22);
ylabel('avg. amplitude (AU)', 'FontSize', 22);
legend('90d', '105d', '135d');
