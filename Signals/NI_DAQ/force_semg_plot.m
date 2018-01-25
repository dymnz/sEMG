clear; close all;

force_filename = './data/loadcell_1.txt';
force_fileID = fopen(force_filename);
force_data = textscan(force_fileID, '%f');
force_data = force_data{1};

semg_filename = './data/semg_1.lvm';
semg_data = lvmread(semg_filename);

% Remove mean
semg_data(:, 2) = semg_data(:, 2) - mean(semg_data(:, 2));

%% Original
figure;
subplot_helper(1:length(force_data), force_data, ...
                [2 1 1], {'sample' 'kg' 'Force'}, '-o');
subplot_helper(semg_data(:, 1), semg_data(:, 2), ...
                [2 1 2], {'sample' 'au' 'sEMG'}, '-o');

                       
%% Force data truncation
force_data_front_truncate_samples = 45;
force_data_back_truncate_samples = 184;
trauncated_range = force_data_front_truncate_samples : ...
        length(force_data) - force_data_back_truncate_samples;
force_data = force_data(trauncated_range);

figure;
subplot_helper(1:length(force_data), force_data, ...
                [2 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');
xlim([1 length(force_data)]);         
subplot_helper(semg_data(:, 1), semg_data(:, 2), ...
                [2 1 2], {'sample' 'amplitude' 'twitch force proto'}, '-o');
            
%% Force data interpolation
xq = 1 : length(force_data) / length(semg_data) : length(force_data);
interpolated_force_data = interp1(1:length(force_data), force_data , xq);

figure;
subplot_helper(1:length(interpolated_force_data), interpolated_force_data, ...
                [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         
subplot_helper(1:length(semg_data(:, 2)), semg_data(:, 2), ...
                [1 1 1], {'sample' 'amplitude' 'Interpolated force and sEMG'}, '-');

%% Remove faulty data
usable_data_range = 1 : 30000;
force_data = interpolated_force_data(usable_data_range);
semg_data = semg_data(usable_data_range, :);

figure;
subplot_helper(1:length(force_data), force_data, ...
                [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         
subplot_helper(1:length(semg_data(:, 2)), semg_data(:, 2), ...
                [1 1 1], {'sample' 'amplitude' 'Interpolated force and sEMG'}, '-');

%% Normalization
force_data = force_data / max(force_data);
semg_data(:, 2) = semg_data(:, 2) / max(semg_data(:, 2));

            
%% sEMG moving average
movmean_semg_data = semg_data;
movmean_semg_data(:, 2) = movmean(semg_data(:, 2), 50);
movmean_semg_data(:, 2) = movmean_semg_data(:, 2) / max(movmean_semg_data(:, 2));

figure;
subplot_helper(1:length(force_data), force_data, ...
                [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         
subplot_helper(1:length(movmean_semg_data(:, 2)), movmean_semg_data(:, 2), ...
                [1 1 1], {'sample' 'amplitude' 'Interpolated force and sEMG'}, '-');

