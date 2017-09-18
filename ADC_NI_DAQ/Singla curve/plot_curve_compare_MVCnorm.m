clear; close all;

%% Part 1
file_path = '../../Signals/2017_09_15/';
filenames = {'1kg_90d.lvm', 
    '2kg_90d.lvm', 
    '3kg_90d.lvm', 
    '4kg_90d.lvm'};

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
title('Normalized Weight - sEMG relationship');
xlabel('weight (kg)');
ylabel('avg. amplitude (AU)');

hold on;

%% Part 2
file_path = '../../Signals/2017_09_15/';
filenames = {'1kg_105d.lvm', 
    '2kg_105d.lvm', 
    '3kg_105d.lvm', 
    '4kg_105d.lvm'};

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