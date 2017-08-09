clear; close all;

file_path = '/home/dymnz/Documents/sEMG/Signals/2017_8_9/';
filenames = {'1kg.lvm', '2kg.lvm', '3kg_2.lvm', '4kg.lvm'};

MVC = lvmread(strcat(file_path, 'MVC.lvm'));
MVC(:, 2) = MVC(:, 2) - mean(MVC(:, 2));
MVC_mean_amp = mean(abs(MVC(:, 2)));

norm_mean_amps = zeros(length(filenames), 1);
for i =  1:length(filenames)

% Read data from .lvm
datamat = lvmread(strcat(file_path, filenames{i}));

% Remove mean
datamat(:, 2) = datamat(:, 2) - mean(datamat(:, 2));
mean_amp = mean(abs(datamat(:, 2)));

% Norm
norm_mean_amp = mean_amp / MVC_mean_amp;

disp(norm_mean_amp);
norm_mean_amps(i) = norm_mean_amp;
end

figure;
plot([1: length(filenames)], norm_mean_amps, '-o');
ylim([0 1]);
xlim([1 length(filenames)]);
title("Normalized Weight - sEMG relationship");
xlabel('weight (kg)');
ylabel('avg. amplitude (AU)');



hold on;

file_path = '/home/dymnz/Documents/sEMG/Signals/2017_8_8/';
filenames = {'1kg_2.lvm', '2kg_2.lvm', '3kg_2.lvm', '4kg_2.lvm'};

MVC = lvmread(strcat(file_path, 'MVC.lvm'));
MVC(:, 2) = MVC(:, 2) - mean(MVC(:, 2));
MVC_mean_amp = mean(abs(MVC(:, 2)));

norm_mean_amps = zeros(length(filenames), 1);
for i =  1:length(filenames)

% Read data from .lvm
datamat = lvmread(strcat(file_path, filenames{i}));

% Remove mean
datamat(:, 2) = datamat(:, 2) - mean(datamat(:, 2));
mean_amp = mean(abs(datamat(:, 2)));

% Norm
norm_mean_amp = mean_amp / MVC_mean_amp;

disp(norm_mean_amp);
norm_mean_amps(i) = norm_mean_amp;
end

plot([1: length(filenames)], norm_mean_amps, '-o');

legend('session1', 'session2');