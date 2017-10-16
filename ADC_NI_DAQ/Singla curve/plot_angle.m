clear; close all;

file_path = '../../Signals/2017_09_16/1/';
angles = [90, 105, 120, 135];
filenames = {'2kg_90d.lvm', 
    '2kg_105d.lvm', 
    '2kg_120d.lvm', 
    '2kg_135d.lvm'};
range = [1000:9000];

mean_amps = zeros(length(filenames), 1);
for i =  1:length(filenames)

% Read data from .lvm
datamat = lvmread(strcat(file_path, filenames{i}));

% Remove mean
datamat(range, 2) = datamat(range, 2) - mean(datamat(range, 2));
mean_amp = mean(abs(datamat(range, 2)));

disp(mean_amp);
mean_amps(i) = mean_amp;
end


figure;
plot(angles, mean_amps, '-o');

hold on;
%%

file_path = '../../Signals/2017_09_16/2/';
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
datamat(range, 2) = datamat(range, 2) - mean(datamat(range, 2));
mean_amp = mean(abs(datamat(range, 2)));

disp(mean_amp);
mean_amps(i) = mean_amp;
end

plot(angles, mean_amps, '-o');
%%
file_path = '../../Signals/2017_09_16/3/';
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
datamat(range, 2) = datamat(range, 2) - mean(datamat(range, 2));
mean_amp = mean(abs(datamat(range, 2)));

disp(mean_amp);
mean_amps(i) = mean_amp;
end

plot(angles, mean_amps, '-o');


%%

file_path = '../../Signals/2017_09_16/4/';
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
datamat(range, 2) = datamat(range, 2) - mean(datamat(range, 2));
mean_amp = mean(abs(datamat(range, 2)));

disp(mean_amp);
mean_amps(i) = mean_amp;
end

plot(angles, mean_amps, '-o');
%%

file_path = '../../Signals/2017_09_16/5/';
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
datamat(range, 2) = datamat(range, 2) - mean(datamat(range, 2));
mean_amp = mean(abs(datamat(range, 2)));

disp(mean_amp);
mean_amps(i) = mean_amp;
end

plot(angles, mean_amps, '-o');

ylim([0 2]);
title("Angle - sEMG @ 2kg", 'FontSize', 20);
xlabel('Angle', 'FontSize', 20);
ylabel('avg. amplitude (AU)', 'FontSize', 20);
legend("s-1", "s-2", "s-3", "s-4", "s-5");
