clear; close all;
% Theory
% There's a constant weight relationship between sessions


%% Part 1
file_path = '../../Signals/2017_09_15/';
filenames = {'1kg_90d.lvm', 
    '2kg_90d.lvm', 
    '3kg_90d.lvm', 
    '4kg_90d.lvm'};

norm_mean_amps1 = zeros(length(filenames), 1);
for i =  1:length(filenames)

% Read data from .lvm
datamat = lvmread(strcat(file_path, filenames{i}));

% Remove mean
datamat(:, 2) = datamat(:, 2) - mean(datamat(:, 2));
mean_amp = mean(abs(datamat(:, 2)));

% Norm
norm_mean_amp = mean_amp;

disp(norm_mean_amp);
norm_mean_amps1(i) = norm_mean_amp;
end

figure;
plot([1: length(filenames)], norm_mean_amps1, '-o');
ylim([0 2]);
xlim([1 length(filenames)]);
title('Raw Weight - sEMG relationship');
xlabel('weight (kg)');
ylabel('avg. amplitude (AU)');
hold on;

%% Part 2
file_path = '../../Signals/2017_09_15/';
filenames = {'1kg_105d.lvm', 
    '2kg_105d.lvm', 
    '3kg_105d.lvm', 
    '4kg_105d.lvm'};
norm_mean_amps2 = zeros(length(filenames), 1);
for i =  1:length(filenames)

% Read data from .lvm
datamat = lvmread(strcat(file_path, filenames{i}));

% Remove mean
datamat(:, 2) = datamat(:, 2) - mean(datamat(:, 2));
mean_amp = mean(abs(datamat(:, 2)));

% Norm
norm_mean_amp = mean_amp;

disp(norm_mean_amp);
norm_mean_amps2(i) = norm_mean_amp;
end

plot([1: length(filenames)], norm_mean_amps2, '-o');
legend('session1', 'session2');

%% Find weight constant
figure;
plot(norm_mean_amps2./norm_mean_amps1, '-o');
ylim([0 ceil(max(norm_mean_amps2./norm_mean_amps1))]);
xlim([1 length(filenames)]);
title('Raw Ratio accross tests');
xlabel('weight (kg)');
ylabel('ratio (AU)');
weight = mean(norm_mean_amps2./norm_mean_amps1);
norm_mean_amps1 = norm_mean_amps1 * weight;

%% Plot adjusted compare
figure; hold on;
plot([1: length(filenames)], norm_mean_amps1, '-o');
plot([1: length(filenames)], norm_mean_amps2, '-o');
ylim([0 ceil(max(max(norm_mean_amps2, norm_mean_amps1)))]);
xlim([1 length(filenames)]);
title('Adjusted Raw Weight - sEMG relationship');
xlabel('weight (kg)');
ylabel('avg. amplitude (AU)');
legend('session1', 'session2');