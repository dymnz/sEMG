clear; close all;

file_path = '../../Signals/2017_09_12/2/';
angles = [90, 105, 120, 135];
filenames = {'2kg_90d.lvm', 
    '2kg_105d.lvm', 
    '2kg_120d.lvm', 
    '2kg_135d.lvm'};

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
plot(angles, mean_amps, '-o');
ylim([0 2]);
title("Angle - sEMG @ fixed weight");
xlabel('Angle');
ylabel('avg. amplitude (AU)');
