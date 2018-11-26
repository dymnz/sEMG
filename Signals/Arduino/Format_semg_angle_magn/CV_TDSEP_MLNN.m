clear; close all;

addpath('../matlab_lib');
addpath('../matlab_lib/TDSEP');

set(0,'DefaultFigureVisible','on');   
% set(0,'DefaultFigureVisible','off');   

%% Setting
semg_sample_rate = 2500; % Approximate
% Data format
semg_channel_count = 6;
mpu_channel_count = 1;
hidden_node_count = '8';

% TDSEP
tdsep_tau = [0:2];

for exp_num = 25
for target_sample_rate = [35]
    
fprintf('============================= TDSEP S2WA%d %d_SPS =============================\n', exp_num, target_sample_rate);

% File
all_test_list = {...
    {'FLX', 'EXT'}, {'PRO', 'SUP'}, ...
    {'FLX', 'EXT'}, {'PRO', 'SUP'}, ...
    {'FLX', 'EXT'}, {'PRO', 'SUP'}, ...
    {'FLX', 'EXT'}, {'PRO', 'SUP'}, ...
    {'FLX', 'EXT'}, {'PRO', 'SUP'}, ...
    {'FLX', 'EXT'}, {'PRO', 'SUP'}, ...
    {'FLX', 'EXT'}, {'PRO', 'SUP'}, ...
    {'FLX', 'EXT'}, {'PRO', 'SUP'}, ...
    {'FLX', 'EXT'}, {'PRO', 'SUP'}, ...  
    {'FLX', 'EXT'}, {'PRO', 'SUP'}
    };

for ica_file_idx = 3
     
ica_filename = 'ICA_processed';

in_file_loc_prepend = ['./data/S2WA_' num2str(exp_num) '_'];
in_file_extension = '.mat';
out_file_loc_prepend = '../../../../RNN/LSTM/data/input/exp_';
out_file_prepend_list = {'TR_TDSEP', 'CV_TDSEP', 'TS_TDSEP'};
out_file_extension = '.txt';
 
record_filename = ['./result/S2WA_' num2str(exp_num) '_TDSEP_' ...
    num2str(ica_file_idx) '_SPS' ...
    num2str(target_sample_rate) '_h' num2str(hidden_node_count)  '_10rd_data_MLNN'];

% RNN param
epoch = '1000';
cross_valid_patience = '20';

% Rand param
rand_seed_start = 21;
rand_seed_end = 30;
rand_seed = cell(1, length(all_test_list));

seed_inc = 0;
for i = 1 : 2 : length(all_test_list)
    rand_seed{i} = num2str(rand_seed_start + seed_inc);
    rand_seed{i+1} = num2str(rand_seed_start + seed_inc);
    seed_inc = seed_inc + 1;
end    

% nICA param
fsolve_max_step = 2000;
fsolve_tolerance = 1e-18;
global_tolerance_torque = 1e-8;
global_max_step = 200;
step_per_log = 100;

% Signal param
semg_max_value = -100;
semg_min_value = -semg_max_value;
mpu_max_value = 140;
mpu_min_value = -mpu_max_value;

% Downsample/RMS param
RMS_window_size = 500;    % RMS window in pts
downsample_filter_order = 6;
downsample_ratio = floor(semg_sample_rate / target_sample_rate);



% Cross-validation param
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
                
                

% Calculate TDSEP demixing matrix
ica_file = [in_file_loc_prepend ica_filename in_file_extension];
load(ica_file);
semg = processed_segments_list{ica_file_idx, 1}{1};

% RMS
rms_semg = RMS_calc(semg, RMS_window_size);

% TDSEP
C = tdsep2(rms_semg, tdsep_tau);
tdsep_semg = C \ rms_semg;

%% Show TDSEP effect    
% tdsep_semg = normalize(tdsep_semg')';
% rms_semg = normalize(rms_semg')';
% 
% 
% figure;
% for channel = 1 : semg_channel_count
% subplot_helper(1:length(semg), semg(channel, :), ...
%                 [semg_channel_count 1 channel], ...
%                 {'sample' 'amplitude' ['Raw sEMG ch:'  num2str(channel)]}, '-');    
% ylim([min(min(semg)) max(max(semg))]);
% end
% 
% 
% figure;
% for channel = 1 : semg_channel_count
% subplot_helper(1:length(rms_semg), rms_semg(channel, :), ...
%                 [semg_channel_count 1 channel], ...
%                 {'sample' 'amplitude' ['RMS sEMG ch:'  num2str(channel)]}, '-');  
% ylim([min(min(rms_semg)) max(max(rms_semg))]);            
% end
% 
% figure;
% for channel = 1 : semg_channel_count
% subplot_helper(1:length(tdsep_semg), tdsep_semg(channel, :), ...
%                 [semg_channel_count 1 channel], ...
%                 {'sample' 'amplitude' ['TDSEP Demixed RMS sEMG ch:'  num2str(channel)]}, '-');    
% ylim([min(min(tdsep_semg)) max(max(tdsep_semg))]);
% end
% 
% rms_xc_list = zeros(semg_channel_count, semg_channel_count);
% for i = 1 : semg_channel_count
%     for r = 1 : semg_channel_count
%         rms_xc_list(i, r) = xcorr(rms_semg(i, :), rms_semg(r, :), 0);
%     end
% end
% 
% 
% ica_xc_list = zeros(semg_channel_count, semg_channel_count);
% for i = 1 : semg_channel_count
%     for r = 1 : semg_channel_count
%         ica_xc_list(i, r) = xcorr(tdsep_semg(i, :), tdsep_semg(r, :), 0);
%     end
% end
% 
% rms_xc_list
% ica_xc_list
% cov(tdsep_semg');
% 
% figure;
% equal_plot(rms_semg, [-3 3], [-3 3]);
% title('RMS signal distribution', 'FontSize', 20);
% ylabel('Channel 1');
% xlabel('Channel 2');
% 
% figure;
% equal_plot(tdsep_semg, [-3 3], [-3 3]);
% title('TDSEP signal distribution', 'FontSize', 20);
% ylabel('Channel 1');
% xlabel('Channel 2');
% 
% return;


     
%% Verify TDSEP
% ica_m_semg = C \ rms_semg  ; 
% figure;
% for channel = 1 : semg_channel_count
% subplot_helper(1:length(tdsep_semg), tdsep_semg(channel, :), ...
%                 [semg_channel_count 1 channel], ...
%                 {'sample' 'amplitude' 'Before nICA'}, '-');             
% end
% for channel = 1 : semg_channel_count
% subplot_helper(1:length(ica_m_semg), ica_m_semg(channel, :), ...
%                 [semg_channel_count 1 channel], ...
%                 {'sample' 'amplitude' 'after nICA'}, '-');    
% ylim([0 max(max(tdsep_semg))]);
% end
% return;

if length(all_test_list) ~= length(rand_seed)
    error('rand_seed length error');
end

all_RMS_list = [];

for list_idx = 1 : length(all_test_list)
gesture_list = all_test_list{list_idx};


in_filename = [strjoin(gesture_list, '_') '_processed'];
out_filename = [strjoin(gesture_list, '_') '_TDSEP'];

RMS_list = zeros(num_of_segment_per_gesture, num_of_gesture);
%% K-fold cross-validation
for round = 1 : total_partition  
close all;  % TODO: Check if this can be removed   
fprintf('---total: %d/%d \tround: %d/%d\n', ...
    list_idx, length(all_test_list), ...
    round, total_partition);

partition_offset_idx = (round - 1) * test_size;

% Read file
in_file = [in_file_loc_prepend in_filename in_file_extension];
load(in_file); % Read 'processed_segments_list'

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

% fprintf('Train data range: \t[%2d %2d]\n', train_idx(1), train_idx(end));
% fprintf('CV data range: \t\t[%2d %2d]\n', cv_idx(1), cv_idx(end));
% fprintf('Test data range: \t[%2d %2d]\n', test_idx(1), test_idx(end));

for i = 1 : num_of_gesture
    partitioned_dataset{i, 1} = ... % Train
        gesture_segments_list{i, 1}(:, train_idx);
    
    partitioned_dataset{i, 2} = ... % CV
        gesture_segments_list{i, 1}(:, cv_idx);
    
    partitioned_dataset{i, 3} = ... % Test
        gesture_segments_list{i, 1}(:, test_idx);
end

% Join different gesture in dataset
join_dataset{1} = horzcat(partitioned_dataset{:, 1});   % Train
join_dataset{2} = horzcat(partitioned_dataset{:, 2});   % CV
join_dataset{3} = horzcat(partitioned_dataset{:, 3});   % Test

% Shuffle Train set
train_rand_idx = randperm(train_size * num_of_gesture);
join_dataset{1}(:, train_rand_idx) = ...
    join_dataset{1}(:, :);

processed_join_dataset = cell(size(join_dataset));
% Processing - RMS-Downsample
num_of_segment_list =  num_of_gesture .* [train_size cv_size test_size];
for f = 1 : 3
    for i = 1 : num_of_segment_list(f)          
        semg = join_dataset{f}{1, i};
        mpu = join_dataset{f}{2, i};

        % RMS
        semg = ...
            RMS_calc(semg, RMS_window_size);

        % TDSEP
        semg = C \ semg;
        
        % Filter
        [semg, cb, ca] = butter_filter( ...
            semg', downsample_filter_order, ...
            target_sample_rate, semg_sample_rate);   
        [mpu, cb, ca] = butter_filter( ...
            mpu', downsample_filter_order, ...
            target_sample_rate, semg_sample_rate);              
                
        % Downsample            
        semg = downsample(semg, downsample_ratio);
        mpu = downsample(mpu, downsample_ratio);
        
        % Fix convention problem
        semg = semg';
        mpu = mpu';
        
        % Remove length mis-match
        usable_data_range = ...
            1 : min(length(semg), length(mpu));
        semg = semg(:, usable_data_range);
        mpu = mpu(:, usable_data_range);
    
        % MPU normalization              
        mpu = 2 .* (mpu - mpu_min_value)...
                ./ (mpu_max_value - mpu_min_value) - 1;

        % Find max/min sEMG for normalization
        semg_max_value = max(semg_max_value, max(semg, [], 2));
        semg_min_value = min(semg_min_value, min(semg, [], 2));

        processed_join_dataset{f}{1, i} = semg;
        processed_join_dataset{f}{2, i} = mpu;
        processed_join_dataset{f}{3, i} = length(usable_data_range);
    end
end

% Normalization
for f = 1 : 3
    for i = 1 : num_of_segment_list(f)
        semg = processed_join_dataset{f}{1, i};
        semg = semg ...
            ./ (semg_max_value - semg_min_value); 
        
        if max(abs(mpu)) > 1
            error('Normalization error')
        end      
        
        processed_join_dataset{f}{1, i} = semg;
    end
end


% Output dataset for LSTM
% train_out_name = [out_file_prepend_list{1}, num2str(exp_num), out_filename];  
% train_out_file = [out_file_loc_prepend, train_out_name out_file_extension];  
% generate_LSTM_data(train_out_file, processed_join_dataset{1});
% 
% cv_out_name = [out_file_prepend_list{2}, num2str(exp_num), out_filename];  
% cv_out_file = [out_file_loc_prepend, cv_out_name out_file_extension];  
% generate_LSTM_data(cv_out_file, processed_join_dataset{2});
% 
% test_out_name = [out_file_prepend_list{3}, num2str(exp_num), out_filename];  
% test_out_file = [out_file_loc_prepend, test_out_name out_file_extension];    
% generate_LSTM_data(test_out_file, processed_join_dataset{3});

%% Run LSTM

% Prepare training dataset
XTrain = {};
YTrain = {};
for r = 1 : length(join_train_segment_list)
    XTrain = [XTrain; join_train_segment_list{1, r}];
    YTrain = [YTrain; join_train_segment_list{2, r}];
end

% Prepare training (cross-validation set is used for training) dataset
XCross = {};
YCross = {};
for r = 1 : length(join_cross_segment_list)
    XCross = [XCross; join_cross_segment_list{1, r}];
    YCross = [YCross; join_cross_segment_list{2, r}];
end

% Prepare testing dataset
XTest = {};
YTest = {};
for r = 1 : length(join_test_segment_list)
    XTest = [XTest; join_test_segment_list{1, r}];
    YTest = [YTest; join_test_segment_list{2, r}];
end


numResponses = 1;
featureDimension = semg_channel_count;
numHiddenUnits = str2num(hidden_node_count);

layers = [ ...
    sequenceInputLayer(featureDimension)
    lstmLayer(numHiddenUnits,'OutputMode','sequence')
    fullyConnectedLayer(numHiddenUnits)
    dropoutLayer(0.3)
    fullyConnectedLayer(numResponses)
    regressionLayer];

maxEpochs = 60;
miniBatchSize = 1;

options = trainingOptions('adam', ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'InitialLearnRate',0.01, ...
    'LearnRateSchedule', 'piecewise', ...
    'GradientThreshold',1, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress',...
    'Verbose',0);


net = trainNetwork(XTrain,YTrain,layers,options);

YPred = predict(net,XTest,'MiniBatchSize',1);

%% Check RMSE

RMSE_list = zeros(length(join_test_segment_list), 1);
for i = 1 : length(join_test_segment_list)
    input = XTest{i};
    pred = YPred{i} .* mpu_max_value;
    target = YTest{i} .* mpu_max_value;
        
    RMSE = sqrt(mean((pred - target).^2));
    RMSE_list(i, 1) = RMSE;

    
    figure;
    subplot_helper(1:length(input), input, ...
                    [2 1 1], {'sample' 'amplitude' 'sEMG'}, ':x');
    ylim([-1 1]);           
	subplot_helper(1:length(target), target(:), ...
                    [2 1 2], ...
                    {'sample' 'amplitude' 'angle'}, ...
                    '-');                                                         
    ylim([mpu_min_value mpu_max_value]);
	subplot_helper(1:length(pred), pred(:), ...
                    [2 1 2], ...
                    {'sample' 'amplitude' 'angle'}, ...
                    '-');
    ylim([mpu_min_value mpu_max_value]);
    legend('real', 'predict');
end

RMSE_list

end

all_RMS_list = [all_RMS_list RMS_list];
end

save(record_filename, 'all_RMS_list');

end

end

end

%% Clean up
set(0,'DefaultFigureVisible','on');
% beep2();