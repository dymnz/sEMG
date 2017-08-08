clear; close all;

file_path = '/home/dymnz/Documents/sEMG/Signals/';
filenames = {'1kg_2.lvm', '2kg_2.lvm', '3kg_2.lvm', '4kg_2.lvm'};

mean_amps = zeros(length(filenames), 1);
for i =  1:length(filenames)

% Read data from .lvm
datamat = lvmread(strcat(file_path, filenames{i}));

% Remove mean
datamat(:, 2) = datamat(:, 2) - mean(datamat(:, 2));
mean_amp = mean(abs(datamat(:, 2)));

disp(mean_amp);
mean_amps(i) = mean_amp;
plot(i, mean_amp, '-x');

end


figure;
plot([1: length(filenames)], mean_amps, '-o');
ylim([0 2]);
xlim([1 length(filenames)]);
title("Weight - sEMG relationship");
xlabel('weight (kg)');
ylabel('avg. amplitude (AU)');
