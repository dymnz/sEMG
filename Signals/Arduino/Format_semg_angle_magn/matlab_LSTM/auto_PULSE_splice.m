% RMS-Downsample-nICA
% Interpolate angle data and output data splice
% Output consists of all semg channel and 
% 'mpu_segment_index' mpu channel

% Whittening and nICA demixing matrix is calculated w/
% ica_file_list and kept throughout the exp

clear; close all;
addpath('../matlab_lib');
addpath('../matlab_lib/nICA');

set(0,'DefaultFigureVisible','on');
% set(0,'DefaultFigureVisible','off');   

%% Setting

% File
file_loc_prepend = './data/raw_';
file_extension = '.txt';
filename_prepend = 'S2WA_21_';

% RNN
hidden_node_count_list = {'16'};
epoch = '1000';
rand_seed = '4';
cross_valid_patience_list = {'100'};

% Signal param
semg_sample_rate = 2660; % Approximate

% Downsample/RMS param
RMS_window_size = 500;    % RMS window in pts
target_sample_rate = 10;
downsample_filter_order = 6;

% PULSE param
semg_pulse_threshold = 100;

semg_max_value = 2048 / 4;
semg_min_value = -2048 / 4;
mpu_max_value = 120;
mpu_min_value = -120;
semg_channel_count = 4;
mpu_channel_count = 3;

semg_channel = 1:4;
mpu_channel = 5:7;  % 3: Roll(SUP/SUP) / 4: Pitch(Flx/Ext)

% Preprocessing target
% Preprocessing target
% file_to_test = {
%     {{{'FLX_1', 'EXT_1'}, ...
%         {'FLX_2', 'EXT_2'}}, ...
%         {'FLX_3', 'EXT_3'}};          
% };
% mpu_segment_index = 2; % 1-Roll/2-Pitch/3-Yaw

file_to_test = {
    {{{'PRO_3', 'SUP_3'}, ...
        {'PRO_2', 'SUP_2'}}, ...
        {'PRO_1', 'SUP_1'}};          
};
mpu_segment_index = 1; % 1-Roll/2-Pitch/3-Yaw

mpu_segment_threshold = 10; % Degree


%% For different hidden node count...
rnn_result_plaintext = [];

for h = 1 : length(hidden_node_count_list)    
for p = 1 : length(cross_valid_patience_list)
    cross_valid_patience = cross_valid_patience_list{p};
    hidden_node_count = hidden_node_count_list{h};
    rnn_result_plaintext = ...
        [rnn_result_plaintext 'H: ' hidden_node_count ' ' ...
        'P: ' cross_valid_patience newline];
for f = 1 : numel(file_to_test) % For different files...

%% Filename Prepend
train_file_label_list = file_to_test{f}{1}{1};
cross_file_label_list = file_to_test{f}{1}{2};
test_file_label_list = file_to_test{f}{2};



% Gather training filename
train_filename_list = cell(1, length(train_file_label_list));
for i = 1 : length(train_file_label_list)
    train_filename_list{i} = ...
        [file_loc_prepend, filename_prepend, ...
            train_file_label_list{i}, file_extension];    
end

cross_filename_list = cell(1, length(cross_file_label_list));
for i = 1 : length(cross_file_label_list)
    cross_filename_list{i} = ...
        [file_loc_prepend, filename_prepend, ...
            cross_file_label_list{i}, file_extension];    
end

test_filename_list = cell(1, length(test_file_label_list));
for i = 1 : length(test_file_label_list)
    test_filename_list{i} = ...
        [file_loc_prepend, filename_prepend, ...
            test_file_label_list{i}, file_extension];    
end

train_output_filename = [ ...
    filename_prepend, ...
    strjoin(train_file_label_list, '_'), ...
    '_RMSDOWN', ...
    '_DS', num2str(target_sample_rate), ...
    '_RMS', num2str(RMS_window_size), '_FULL'];
    
if length(train_output_filename) > 100
    truncated_train_file_label_list = train_file_label_list(1:5);
    
    train_output_filename = [ ...
    filename_prepend, ...
    strjoin(truncated_train_file_label_list, '_'), ...
    '_TRUNCAT', ...
    '_RMSDOWN', ...
    '_DS', num2str(target_sample_rate), ...
    '_RMS', num2str(RMS_window_size), '_FULL'];
end

train_output_file = ...
   [ '../../../../RNN/LSTM/data/input/exp_', ...
            train_output_filename, file_extension];

cross_output_filename = [ ...
    filename_prepend, ...
    strjoin(cross_file_label_list, '_'), ...
    '_RMSDOWN', ...
    '_DS', num2str(target_sample_rate), ...
    '_RMS', num2str(RMS_window_size), '_FULL'];
cross_output_file = ...
   [ '../../../../RNN/LSTM/data/input/exp_', ...
           cross_output_filename, file_extension];        
        
        
test_output_filename = [ ...
    filename_prepend, ...
    strjoin(test_file_label_list, '_'), ...
    '_RMSDOWN', ...
    '_DS', num2str(target_sample_rate), ...
    '_RMS', num2str(RMS_window_size), '_FULL'];
test_output_file = ...
   [ '../../../../RNN/LSTM/data/input/exp_', ...
           test_output_filename, file_extension];  
                  

num_of_train_file = length(train_filename_list);
num_of_test_file = length(test_filename_list);
num_of_cross_file = length(cross_filename_list);


%% Find proper normalization range

join_filename_list = [train_filename_list test_filename_list cross_filename_list];

concat_semg = [];
for i = 1 : length(join_filename_list)
    raw_data = csvread(join_filename_list{i});
    semg = raw_data(:, semg_channel);

    % Remove front and end to avoid noise
    semg = semg(10:end, :);
    semg = semg - mean(semg);
  
    concat_semg = [concat_semg; semg];    
end


concat_semg = semg_find_pulse(concat_semg, semg_pulse_threshold);

% Downsample
downsample_ratio = floor(semg_sample_rate / target_sample_rate);
[concat_semg, cb, ca] = butter_filter( ...
        concat_semg, downsample_filter_order, target_sample_rate, semg_sample_rate);   
concat_semg = downsample(concat_semg, downsample_ratio);

semg_max_value = max(concat_semg) * 2;
semg_min_value = min(concat_semg) * 2;

%% Process & Output - Train
join_train_segment_list = cell(num_of_train_file, 1);
join_train_num_of_segments = 0;
for i = 1 : num_of_train_file
    
    % Input/Output/Length  % num_of_segments
    join_train_segment_list{i} = ...
        PULSE_splice_func(train_filename_list{i}, target_sample_rate, RMS_window_size, downsample_filter_order, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel, mpu_segment_threshold, mpu_segment_index, semg_pulse_threshold);
    join_train_num_of_segments = join_train_num_of_segments ...
                            + length(join_train_segment_list{i});
%     fprintf('Processed File %d\n', i);
end

%% Process & Output - Cross

join_cross_segment_list = cell(num_of_cross_file, 1);
join_cross_num_of_segments = 0;
for i = 1 : num_of_cross_file
    
    % Input/Output/Length  % num_of_segments
    join_cross_segment_list{i} = ...
        PULSE_splice_func(cross_filename_list{i}, target_sample_rate, RMS_window_size, downsample_filter_order, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel, mpu_segment_threshold, mpu_segment_index, semg_pulse_threshold);
    join_cross_num_of_segments = join_cross_num_of_segments ...
                            + length(join_cross_segment_list{i});
%     fprintf('Processed File %d\n', i);
end

%% Process & Output - Test

join_test_segment_list = cell(num_of_test_file, 1);
join_test_num_of_segments = 0;
for i = 1 : num_of_test_file
    
    % Input/Output/Length  % num_of_segments
    join_test_segment_list{i} = ...
        PULSE_splice_func(test_filename_list{i}, target_sample_rate, RMS_window_size, downsample_filter_order, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel, mpu_segment_threshold, mpu_segment_index, semg_pulse_threshold);
    join_test_num_of_segments = join_test_num_of_segments ...
                            + length(join_test_segment_list{i});
%     fprintf('Processed File %d\n', i);
end


%% Run LSTM


% Prepare training dataset
XTrain = {};
YTrain = {};
for i = 1 : num_of_train_file
    for r = 1 : length(join_train_segment_list{i})
        XTrain = [XTrain; join_train_segment_list{i}{r, 1}];
        YTrain = [YTrain; join_train_segment_list{i}{r, 2}];
    end
end

% Prepare training (cross-validation set is used for training) dataset
for i = 1 : num_of_cross_file
    for r = 1 : length(join_cross_segment_list{i})
        XTrain = [XTrain; join_cross_segment_list{i}{r, 1}];
        YTrain = [YTrain; join_cross_segment_list{i}{r, 2}];
    end
end

% Prepare testing dataset
XTest = {};
YTest = {};
for i = 1 : num_of_test_file
    for r = 1 : length(join_test_segment_list{i})
        XTest = [XTest; join_test_segment_list{i}{r, 1}];
        YTest = [YTest; join_test_segment_list{i}{r, 2}];
    end
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

maxEpochs = 30;
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

RMSE_list = zeros(join_test_num_of_segments, 1);
for i = 1 : join_test_num_of_segments
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
end
end


clipboard('copy', rnn_result_plaintext);
fprintf(rnn_result_plaintext);

set(0,'DefaultFigureVisible','on');
% msgbox('Ding!');
beep2()
