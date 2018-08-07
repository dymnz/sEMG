clear; close all;
addpath('../matlab_lib');

set(0,'DefaultFigureVisible','off');   

%% Setting
% File
file_loc_prepend = './data/S2WA_22_';
file_extension = '.mat';
filename = 'FLX_EXT_processed';

% RNN param
hidden_node_count = '16';
epoch = '1000';
rand_seed = '4';
cross_valid_patience = '100';

% Signal param
semg_sample_rate = 2660; % Approximate
semg_max_value = 2048;
semg_min_value = -semg_max_value;
mpu_max_value = 130;
mpu_min_value = -mpu_max_value;

% Downsample/RMS param
RMS_window_size = 500;    % RMS window in pts
target_sample_rate = 100;
downsample_filter_order = 6;

% Data format
semg_channel_count = 4;
mpu_channel_count = 1;

% Cross-validation param
partition_offset_idx = 0;
partition_ratio = [3 1 1]; % Train/CV/Test
total_partition = sum(partition_ratio);

num_of_gesture = 2;
num_of_iteration_per_gesture = 3;
num_of_segment_per_iteration = 20; % e.g. num of segment in 'FLX_1'
                                    % Anything more is removed
num_of_segment_per_gesture = ...
    num_of_iteration_per_gesture * num_of_segment_per_iteration;

train_size = partition_ratio(1) / total_partition ...
                    * num_of_segment_per_gesture;               
cv_size = partition_ratio(2) / total_partition ...
                    * num_of_segment_per_gesture;
test_size = partition_ratio(3) / total_partition ...
                    * num_of_segment_per_gesture;                
%% Prepare dataset

% Read file
file = [file_loc_prepend filename file_extension];
load(file); % Read 'processed_segments_list'

num_of_session = num_of_gesture * num_of_iteration_per_gesture;
if num_of_session ~= length(processed_segments_list)
    error('session count mis-match');
end

% Remove data > num_of_segment_per_interation
for i = 1 : num_of_session
    processed_segments_list{i, 1} = ...
        processed_segments_list{i, 1}(1:num_of_segment_per_iteration, :);
end

% Combine segments from the same gesture
gesture_segments_list = cell(num_of_gesture, 1);
for i = 1 : num_of_gesture
    gesture_segments_list{i} = ...
        vertcat(processed_segments_list{ ...
            (i-1) * num_of_iteration_per_gesture + 1 : ...
                i * num_of_iteration_per_gesture, ...
             1})';
end

% Partition dataset
partitioned_dataset = cell(num_of_gesture, 3);

train_idx = ...
    mod(partition_offset_idx : ...
    (partition_offset_idx + train_size - 1), num_of_segment_per_gesture) + 1;
cv_idx = ...
    mod(partition_offset_idx + train_size : ...
    (partition_offset_idx + train_size + cv_size - 1), num_of_segment_per_gesture) + 1;
test_idx = ...
    mod(partition_offset_idx + train_size + cv_size : ...
    (partition_offset_idx + train_size + cv_size + test_size - 1), num_of_segment_per_gesture) + 1;

fprintf('Train data range: \t[%2d %2d]\n', train_idx(1), train_idx(end));
fprintf('CV data range: \t\t[%2d %2d]\n', cv_idx(1), cv_idx(end));
fprintf('Test data range: \t[%2d %2d]\n', test_idx(1), test_idx(end));


for i = 1 : num_of_gesture
    partitioned_dataset{i, 1} = ... % Train
        gesture_segments_list{i, 1}(:, train_idx);
    partitioned_dataset{i, 2} = ... % CV
        gesture_segments_list{i, 1}(:, cv_idx);
    partitioned_dataset{i, 3} = ... % Test
        gesture_segments_list{i, 1}(:, test_idx);
end

% Shuffle within dataset
for i = 1 : num_of_gesture
    train_rand_idx = randperm(train_size);
    partitioned_dataset{i, 1}(:, train_rand_idx) = ...
        partitioned_dataset{i, 1}(:, :);
    cv_rand_idx = randperm(cv_size);
    partitioned_dataset{i, 2}(:, cv_rand_idx) = ...
        partitioned_dataset{i, 2}(:, :);
    test_rand_idx = randperm(test_size);
    partitioned_dataset{i, 3}(:, test_rand_idx) = ...
        partitioned_dataset{i, 3}(:, :);    
end

% 

set(0,'DefaultFigureVisible','on');