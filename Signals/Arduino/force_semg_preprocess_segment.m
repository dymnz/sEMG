clear; close all;

file_name = './data/test_2semg_12345.txt';
semg_channel = 1:2;
semg_channel_count = 2;
force_channel = 3;

semg_max_value = 2048;
semg_min_value = -2048;
force_max_value = 5;
semg_sample_rate = 5100; % Approximate
target_sample_rate = 200;

train_output_filename = './data/output/exp_ard_DS100_FORCE_SEG.txt';
test_output_filename = './data/output/exp_ard_full.txt';

raw_data = csvread(file_name);
force = raw_data(:, force_channel);
semg = raw_data(:, semg_channel);

% Remove mean
semg = semg - mean(semg);

%% Original

fprintf('original signal time: %.2f\n', length(semg)/semg_sample_rate);

% figure;
% subplot_helper(1:length(force), force, ...
%                 [2 1 1], {'sample' 'kg' 'Force'}, '-o');
% subplot_helper(1:length(semg), semg, ...
%                 [2 1 2], {'sample' 'au' 'sEMG'}, '-o');            
%% Force data interpolation
force(force<1e-3) = 0;

start_point = 1;

i = 1;
while i + 1 < length(force)
   i = i + 1; 
   if force(i) > 0
    end_point = i;
    xq = start_point : 1 : end_point;
    force(start_point:end_point) = ...
        interp1([start_point end_point], ...
            [force(start_point) force(end_point)], xq);            
   start_point = i;
   end
end

end_point = length(force);
xq = start_point : 1 : end_point;
force(start_point:end_point) = ...
    interp1([start_point end_point], ...
        [force(start_point) force(end_point)], xq);            


% figure;
% subplot_helper(1:length(force), force, ...
%                 [2 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         
% subplot_helper(1:length(semg), semg, ...
%                 [2 1 2], {'sample' 'amplitude' 'Interpolated force and sEMG'}, '-');

%% Downsample
downsample_ratio = floor(semg_sample_rate / target_sample_rate);

filter_order = 6;
[force, cb, ca] = butter_filter( ...
        force, filter_order, target_sample_rate, semg_sample_rate);
[semg, cb, ca] = butter_filter( ...
        semg, filter_order, target_sample_rate, semg_sample_rate);

force = downsample(force, downsample_ratio);
semg = downsample(semg, downsample_ratio);

figure;
subplot_helper(1:length(force), force, ...
                [2 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         
subplot_helper(1:length(semg), semg, ...
                [2 1 2], {'sample' 'amplitude' 'Downsample force and sEMG'}, '-x');
            
%% Restrain SEMG range
semg(semg > semg_max_value) = semg_max_value;
semg(semg < semg_min_value) = semg_min_value;


%% Remove faulty data
usable_data_range = 1 : min(length(semg), length(force));
force = force(usable_data_range);
semg = semg(usable_data_range, :);

figure;
subplot_helper(1:length(force), force, ...
                [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         
subplot_helper(1:length(semg), semg, ...
                [1 1 1], {'sample' 'amplitude' 'Truncated force and sEMG'}, '-');

%% Rectify and Normalization
force = force / force_max_value;

semg = semg - mean(semg);
% semg = abs(semg);
semg =  2.*(semg - semg_min_value)...
        ./ (semg_max_value - semg_min_value) - 1;

figure;
subplot_helper(1:length(force), force, ...
                [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         
subplot_helper(1:length(semg), semg, ...
                [1 1 1], {'sample' 'amplitude' 'Normalized force and sEMG'}, '-');
ylim([-1 1]);

%% Force segmentation
% Divide the data from the middle of each force action
% Force action: Froce >= force_threshold
force_threshold = 0.05;
force_segments = zeros(size(force));
force_segments(force > force_threshold) = 1;

starting_point = 1;

% [segment start , segment end]
segment_indices = ...
    [find(([force_segments; 0] - [0; force_segments]) == 1) , ...
    find(([force_segments; 0] - [0; force_segments]) == -1)];

% (start_n+1 + end_n) / 2
mid_segment_indices = ...
    floor(([segment_indices(:, 1) ; 0] + [0 ; segment_indices(:, 2)]) / 2);
mid_segment_indices = mid_segment_indices(1:end-1, :);
output_fileID = fopen(train_output_filename, 'w');

num_of_sample = length(mid_segment_indices) - 1;
fprintf(output_fileID, '%d\n', num_of_sample);
for i = 2 : length(mid_segment_indices)
    cutoff_range = mid_segment_indices(i - 1) : mid_segment_indices(i);
    cutoff_force = force(cutoff_range);
    cutoff_semg = semg(cutoff_range, :);
    fprintf(output_fileID, '%d %d\n', length(cutoff_semg), semg_channel_count);
    fprintf(output_fileID, '%f\t', cutoff_semg');
    fprintf(output_fileID, '\n');
    fprintf(output_fileID, '%d %d\n', length(cutoff_semg), 1);
    fprintf(output_fileID, '%f\t', cutoff_force');
    fprintf(output_fileID, '\n'); 
    
    figure;
    subplot_helper(1:length(cutoff_force), cutoff_force, ...
                    [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');                    
    subplot_helper(1:length(cutoff_semg), cutoff_semg, ...
                    [1 1 1], {'sample' 'amplitude' 'Interpolated force and sEMG'}, '-');                       
    ylim([-1 1]);     
end

