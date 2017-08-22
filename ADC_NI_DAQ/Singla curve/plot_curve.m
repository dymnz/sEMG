clear; close all;

file_path = '/home/dymnz/Documents/sEMG/Signals/2017_8_9/';
filenames = {'1kg.lvm', '2kg.lvm', '3kg.lvm', '4kg.lvm'};

mean_amps = zeros(length(filenames), 1);
for i =  1:length(filenames)

% Read data from .lvm
datamat = lvmread(strcat(file_path, filenames{i}));

% Remove mean
datamat(:, 2) = datamat(:, 2) - mean(datamat(:, 2));
mean_amp = mean(abs(datamat(:, 2)));

disp(mean_amp);
mean_amps(i) = mean_amp;
end


figure;
plot([1: length(filenames)], mean_amps, '-o');
ylim([0 2]);
xlim([1 length(filenames)]);
title("Weight - sEMG relationship");
xlabel('weight (kg)');
ylabel('avg. amplitude (AU)');
