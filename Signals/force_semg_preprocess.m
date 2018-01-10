clear; close all;

force_filename = './data/loadcell_1.txt';
force_fileID = fopen(force_filename);
force_data = textscan(force_fileID, '%f');
fclose(force_fileID);
force_data = force_data{1};

semg_filename = './data/semg_1.lvm';
semg_data = lvmread(semg_filename);
sample_rate = 1000;

% Remove mean
semg_data(:, 2) = semg_data(:, 2) - mean(semg_data(:, 2));

%% Original
figure;
subplot_helper(1:length(force_data), force_data, ...
                [2 1 1], {'sample' 'kg' 'Force'}, '-o');
subplot_helper(semg_data(:, 1), semg_data(:, 2), ...
                [2 1 2], {'sample' 'au' 'sEMG'}, '-o');

                       
%% Force data truncation
force_data_front_truncate_samples = 49;
force_data_back_truncate_samples = 195;
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
%return;
%% Remove faulty data
usable_data_range = 8000 : 32000;
force_data = interpolated_force_data(usable_data_range);
semg_data = semg_data(usable_data_range, :);

figure;
subplot_helper(1:length(force_data), force_data, ...
                [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         
subplot_helper(1:length(semg_data(:, 2)), semg_data(:, 2), ...
                [1 1 1], {'sample' 'amplitude' 'Truncated force and sEMG'}, '-');

%return;
%% Downsample
semg_data = semg_data(:, 2);
target_sample_rate = 100;
downsample_ratio = floor(sample_rate / target_sample_rate);

filter_order = 6;
[force_data, cb, ca] = butter_filter( ...
        force_data, filter_order, target_sample_rate, sample_rate);
[semg_data, cb, ca] = butter_filter( ...
        semg_data, filter_order, target_sample_rate, sample_rate);

force_data = downsample(force_data, downsample_ratio);
semg_data = downsample(semg_data, downsample_ratio);


figure;
subplot_helper(1:length(force_data), force_data, ...
                [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         
subplot_helper(1:length(semg_data), semg_data, ...
                [1 1 1], {'sample' 'amplitude' 'Downsample force and sEMG'}, '-');
ylim([0 1]);


%% Rectify and Normalization
force_data = force_data / max(force_data);
semg_data = abs(semg_data);
semg_data = semg_data / max(semg_data);

figure;
subplot_helper(1:length(force_data), force_data, ...
                [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         
subplot_helper(1:length(semg_data), semg_data, ...
                [1 1 1], {'sample' 'amplitude' 'Normalized force and sEMG'}, '-');
ylim([0 1]);



%% Write train file
DATA_LENGTH = 250;
OVERLAP_LENGTH = 50;
num_of_sample = floor(length(force_data) / OVERLAP_LENGTH);

output_filename = './data/exp_train_2_ds100_lp_rec_fx_ol.txt';
output_fileID = fopen(output_filename, 'w');
fprintf(output_fileID, '%d\n', num_of_sample);

for i = 1 : num_of_sample

cutoff_range = ...
    (i-1)*(DATA_LENGTH - OVERLAP_LENGTH) + 1 : ...
    (i-1)*(DATA_LENGTH - OVERLAP_LENGTH) + DATA_LENGTH;
if (i-1)*(DATA_LENGTH - OVERLAP_LENGTH) + DATA_LENGTH > length(force_data)
cutoff_range = ...
    (i-1)*(DATA_LENGTH - OVERLAP_LENGTH) + 1 : ...
    length(force_data);
end
if length(cutoff_range) <= 1
    break
end
%% 

cutoff_force = force_data(cutoff_range);
cutoff_semg = semg_data(cutoff_range);
fprintf(output_fileID, '%d %d\n', length(cutoff_semg), 1);
fprintf(output_fileID, '%f\t', cutoff_semg);
fprintf(output_fileID, '\n');
fprintf(output_fileID, '%d %d\n', length(cutoff_semg), 1);
fprintf(output_fileID, '%f\t', cutoff_force);
fprintf(output_fileID, '\n');

figure;
subplot_helper(1:length(cutoff_force), cutoff_force, ...
                [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');                    
subplot_helper(1:length(cutoff_semg), cutoff_semg, ...
                [1 1 1], {'sample' 'amplitude' 'Interpolated force and sEMG'}, '-');                       
ylim([-1 1]);            
end

fclose(output_fileID);

%% Write test file
output_filename = './data/exp_test_2_ds100_lp_rec_fx_ol.txt';
output_fileID = fopen(output_filename, 'w');

DATA_LENGTH = length(semg_data);

fprintf(output_fileID, '1\n');
fprintf(output_fileID, '%d %d\n', DATA_LENGTH, 1);
fprintf(output_fileID, '%f\t', semg_data);
fprintf(output_fileID, '\n');
fprintf(output_fileID, '%d %d\n', DATA_LENGTH, 1);
fprintf(output_fileID, '%f\t', force_data);
fprintf(output_fileID, '\n');
fclose(output_fileID);