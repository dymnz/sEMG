clear; close all;

force_filename = './data/loadcell_2.txt';
force_fileID = fopen(force_filename);
force = textscan(force_fileID, '%f');
fclose(force_fileID);
force = force{1};
force_sample_rate = 11.2;

semg_filename = './data/semg_2.lvm';
semg = lvmread(semg_filename);
semg_sample_rate = 1000;

% Remove mean
semg = semg(:, 2) - mean(semg(:, 2));

%% Original

% figure;
% subplot_helper(1:length(force_data), force_data, ...
%                 [2 1 1], {'sample' 'kg' 'Force'}, '-o');
% subplot_helper(1:length(semg_data), semg_data, ...
%                 [2 1 2], {'sample' 'au' 'sEMG'}, '-o');

%% Force data interpolation
xq = 1 : force_sample_rate / semg_sample_rate : length(force);
force = interp1(1:length(force), force , xq);

% figure;
% subplot_helper(1:length(force_data), force_data, ...
%                 [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         
% subplot_helper(1:length(semg_data), semg_data, ...
%                 [1 1 1], {'sample' 'amplitude' 'Interpolated force and sEMG'}, '-');

            
            
%% Force data truncation
force_data_front_truncate_samples = 2800;
force_data_back_truncate_samples = 6900;

trauncated_range = 1+force_data_front_truncate_samples : ...
        length(force) - force_data_back_truncate_samples;
force = force(trauncated_range);

semg_data_front_truncate_samples = 2800;
semg_data_back_truncate_samples = 1000;
trauncated_range = 1+semg_data_front_truncate_samples : ...
        length(semg) - semg_data_back_truncate_samples;
semg = semg(trauncated_range);

% figure;
% subplot_helper(1:length(force_data), force_data, ...
%                 [2 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');        
% subplot_helper(1:length(semg_data), semg_data, ...
%                 [2 1 2], {'sample' 'amplitude' 'twitch force proto'}, '-o');
%             
         

%% Normalization
force = force / max(force);
semg = 2 * (semg - min(semg))...
        / (max(semg) - min(semg)) - 1;

figure;
subplot_helper(1:length(semg), semg, ...
                [1 1 1], {'sample' 'amplitude' 'Normalized force and sEMG'}, '-');
subplot_helper(1:length(force), force, ...
                [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         


%% Remove faulty data
usable_data_range = 1 : min(length(semg), length(force));
force = force(usable_data_range);
semg = semg(usable_data_range, :);

figure;
subplot_helper(1:length(force), force, ...
                [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         
subplot_helper(1:length(semg), semg, ...
                [1 1 1], {'sample' 'amplitude' 'Truncated force and sEMG'}, '-');

return;
%% Downsample
target_sample_rate = 300;
downsample_ratio = floor(sample_rate / target_sample_rate);

filter_order = 6;
[force_data, cb, ca] = butter_filter( ...
        force_data, filter_order, target_sample_rate, sample_rate);

force_data = downsample(force_data, downsample_ratio);
semg_data = downsample(semg_data, downsample_ratio);


figure;
subplot_helper(1:length(force_data), force_data, ...
                [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         
subplot_helper(1:length(semg_data), semg_data, ...
                [1 1 1], {'sample' 'amplitude' 'Downsample force and sEMG'}, '-');
ylim([0 1]);



%% Pulse gen
threshold = 0.5;
processed_semg = zeros(size(semg_data));
for i = 2 : length(semg_data)
    if semg_data(i) > threshold && ...
       (semg_data(i) - semg_data(i-1)) * ...
       (semg_data(i - 1) - semg_data(i)) < 0
   
        processed_semg(i) = semg_data(i);
    end
end
semg_data = processed_semg;
figure;
subplot_helper(1:length(force_data), force_data, ...
                [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         
subplot_helper(1:length(semg_data), semg_data, ...
                [1 1 1], {'sample' 'amplitude' 'Normalized force and sEMG'}, '-');
ylim([-1 1]);


%% Write train file
DATA_LENGTH = 300;
OVERLAP_LENGTH = 100;
num_of_sample = floor(length(force_data) / OVERLAP_LENGTH);

output_filename = './data/output/exp_train_semg_2.txt';
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
                [1 1 1], {'sample' 'amplitude' 'Interpolated force and sEMG'}, '-o');                       
ylim([-1 1]);            
end

fclose(output_fileID);

%% Write test file
output_filename = './data/output/exp_test_semg_2.txt';
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