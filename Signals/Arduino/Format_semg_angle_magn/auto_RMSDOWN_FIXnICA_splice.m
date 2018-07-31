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
target_sample_rate = 100;
downsample_filter_order = 6;

% nICA param
fsolve_max_step = 2000;
fsolve_tolerance = 1e-18;
global_tolerance_torque = 1e-8;
global_max_step = 200;
step_per_log = 100;

semg_max_value = 2048 / 4;
semg_min_value = -2048 / 4;
mpu_max_value = 120;
mpu_min_value = -120;
semg_channel_count = 4;
mpu_channel_count = 3;

semg_channel = 1:4;
mpu_channel = 5:7;  % 3: Roll(SUP/SUP) / 4: Pitch(Flx/Ext)

% Preprocessing target
% ica_file_list = {'FLX_1', 'EXT_1', 'PRO_1', 'SUP_1'};
ica_file_list = {'ICA_3'};
% file_to_test = {
%     {{{'FLX_1', 'EXT_1'}, ...
%         {'FLX_2', 'EXT_2'}}, ...
%         {'FLX_3', 'EXT_3'}};          
% };
file_to_test = {
    {{{'PRO_1', 'SUP_1'}, ...
        {'PRO_2', 'SUP_2'}}, ...
        {'PRO_3', 'SUP_3'}};          
};
mpu_segment_threshold = 10; % Degree
mpu_segment_index = 1; % 1-Roll/2-Pitch/3-Yaw


% Preprocessing matrix
ica_file_label_list = ica_file_list;
ica_filename_list = cell(1, length(ica_file_label_list));

for i = 1 : length(ica_file_label_list)
    ica_filename_list{i} = ...
        [file_loc_prepend, filename_prepend, ...
            ica_file_label_list{i}, file_extension];    
end

%% ICA is processed on the concated semg
concat_semg = [];
for i = 1 : length(ica_filename_list)
    raw_data = csvread(ica_filename_list{i});
    semg = raw_data(:, semg_channel);

    % Remove front and end to avoid noise
    semg = semg(50:end - 50, :);
    semg = semg - mean(semg);
  
    concat_semg = [concat_semg; semg];    
end

% RMS-Downsample
rms_semg = RMS_calc(concat_semg, RMS_window_size);
downsample_ratio = floor(semg_sample_rate / target_sample_rate);
[RMSDOWN_semg, cb, ca] = butter_filter( ...
        rms_semg, downsample_filter_order, target_sample_rate, semg_sample_rate);   
RMSDOWN_semg = downsample(RMSDOWN_semg, downsample_ratio);

% nICA
% W: demix V: whitten
[rms_nica_semg, whittened, W, V] = nICA(RMSDOWN_semg, fsolve_max_step, fsolve_tolerance, global_tolerance_torque, global_max_step, step_per_log);

figure;
subplot_helper(1:length(RMSDOWN_semg), RMSDOWN_semg(:, 1), ...
                [4 1 1], {'sample' 'amplitude' 'Before nICA'}, '-');
subplot_helper(1:length(RMSDOWN_semg), RMSDOWN_semg(:, 2), ...    
                [4 1 2], {'sample' 'amplitude' 'Before nICA'}, '-'); 
subplot_helper(1:length(RMSDOWN_semg), RMSDOWN_semg(:, 3), ...
                [4 1 3], {'sample' 'amplitude' 'Before nICA'}, '-'); 
subplot_helper(1:length(RMSDOWN_semg), RMSDOWN_semg(:, 4), ...    
                [4 1 4], {'sample' 'amplitude' 'Before nICA'}, '-');  

figure;
subplot_helper(1:length(rms_nica_semg), rms_nica_semg(:, 1), ...
                [4 1 1], {'sample' 'amplitude' 'After nICA'}, '-');  
ylim([0 0.3]);            
subplot_helper(1:length(rms_nica_semg), rms_nica_semg(:, 2), ...    
                [4 1 2], {'sample' 'amplitude' 'After nICA'}, '-'); 
ylim([0 0.3]);            
subplot_helper(1:length(rms_nica_semg), rms_nica_semg(:, 3), ...
                [4 1 3], {'sample' 'amplitude' 'After nICA'}, '-');    
ylim([0 0.3]);            
subplot_helper(1:length(rms_nica_semg), rms_nica_semg(:, 4), ...    
                [4 1 4], {'sample' 'amplitude' 'After nICA'}, '-');      
ylim([0 0.3]);           
            
% Reconstruct test            
% RMSDOWN_semg = (W * V * RMSDOWN_semg')';            
%             
% subplot_helper(1:length(RMSDOWN_semg), RMSDOWN_semg(:, 1), ...
%                 [4 1 1], {'sample' 'amplitude' 'After nICA'}, '-');
% subplot_helper(1:length(RMSDOWN_semg), RMSDOWN_semg(:, 2), ...    
%                 [4 1 2], {'sample' 'amplitude' 'After nICA'}, '-'); 
% subplot_helper(1:length(RMSDOWN_semg), RMSDOWN_semg(:, 3), ...
%                 [4 1 3], {'sample' 'amplitude' 'After nICA'}, '-'); 
% subplot_helper(1:length(RMSDOWN_semg), RMSDOWN_semg(:, 4), ...    
%                 [4 1 4], {'sample' 'amplitude' 'After nICA'}, '-');  
            
% Why is there a difference            
return
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

% RMS-Downsample
rms_semg = RMS_calc(concat_semg, RMS_window_size);
downsample_ratio = floor(semg_sample_rate / target_sample_rate);
[RMSDOWN_semg, cb, ca] = butter_filter( ...
        rms_semg, downsample_filter_order, target_sample_rate, semg_sample_rate);   
RMSDOWN_semg = downsample(RMSDOWN_semg, downsample_ratio);

% Whitten-nICA
RMSDOWN_semg = (W * V * RMSDOWN_semg')';  

semg_max_value = max(RMSDOWN_semg);
semg_min_value = min(RMSDOWN_semg);

%% Process & Output - Train

join_segment_list = cell(num_of_train_file, 1);
join_num_of_segments = 0;
for i = 1 : num_of_train_file
    
    % Input/Output/Length  % num_of_segments
    join_segment_list{i} = ...
        RMSDOWN_FIXnICA_splice_func(train_filename_list{i}, target_sample_rate, RMS_window_size, downsample_filter_order, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel, mpu_segment_threshold, mpu_segment_index, V, W);
    join_num_of_segments = join_num_of_segments ...
                            + length(join_segment_list{i});
%     fprintf('Processed File %d\n', i);
end

output_fileID = fopen(train_output_file, 'w');

%fprintf('# of sample: %d\n', num_of_file);
fprintf(output_fileID, '%d\n', join_num_of_segments);

for i = 1 : num_of_train_file
    num_of_segments = length(join_segment_list{i});
    for r = 1 : num_of_segments
        input = join_segment_list{i}{r, 1};
        output = join_segment_list{i}{r, 2};
        segment_length = join_segment_list{i}{r, 3};

        % Input
        fprintf(output_fileID, '%d %d\n', ...
                segment_length, ...
                semg_channel_count);
        fprintf(output_fileID, '%f\t', input);
        fprintf(output_fileID, '\n');

        % Output: Force + Angle
        fprintf(output_fileID, '%d %d\n', ...
                segment_length, ...
                1);
        fprintf(output_fileID, '%f\t', output);
        fprintf(output_fileID, '\n'); 

    %         figure;
    %         subplot_helper(1:length(input), input, ...
    %                         [2 1 1], {'sample' 'amplitude' 'Interpolated sEMG'}, '-');                       
    %         ylim([-1 1]);     
    %         subplot_helper(1:length(output), output, ...
    %                         [2 1 2], {'sample' 'amplitude' 'Interpolated Angle'}, '-');                                       
    %         ylim([-1 1]); 
    end  
end

fclose(output_fileID);

%% Process & Output - Cross

join_segment_list = cell(num_of_cross_file, 1);
join_num_of_segments = 0;
for i = 1 : num_of_cross_file
    
    % Input/Output/Length  % num_of_segments
    join_segment_list{i} = ...
        RMSDOWN_FIXnICA_splice_func(cross_filename_list{i}, target_sample_rate, RMS_window_size, downsample_filter_order, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel, mpu_segment_threshold, mpu_segment_index, V, W);
    join_num_of_segments = join_num_of_segments ...
                            + length(join_segment_list{i});
%     fprintf('Processed File %d\n', i);
end

output_fileID = fopen(cross_output_file, 'w');

%fprintf('# of sample: %d\n', num_of_file);
fprintf(output_fileID, '%d\n', join_num_of_segments);

for i = 1 : num_of_train_file
    num_of_segments = length(join_segment_list{i});
    for r = 1 : num_of_segments
        input = join_segment_list{i}{r, 1};
        output = join_segment_list{i}{r, 2};
        segment_length = join_segment_list{i}{r, 3};

        % Input
        fprintf(output_fileID, '%d %d\n', ...
                segment_length, ...
                semg_channel_count);
        fprintf(output_fileID, '%f\t', input);
        fprintf(output_fileID, '\n');

        % Output: Force + Angle
        fprintf(output_fileID, '%d %d\n', ...
                segment_length, ...
                1);
        fprintf(output_fileID, '%f\t', output);
        fprintf(output_fileID, '\n'); 

    %         figure;
    %         subplot_helper(1:length(input), input, ...
    %                         [2 1 1], {'sample' 'amplitude' 'Interpolated sEMG'}, '-');                       
    %         ylim([-1 1]);     
    %         subplot_helper(1:length(output), output, ...
    %                         [2 1 2], {'sample' 'amplitude' 'Interpolated Angle'}, '-');                                       
    %         ylim([-1 1]); 
    end  
end

fclose(output_fileID);

%% Output full

% Input/Output/Length  % num_of_segments

join_segment_list = cell(num_of_test_file, 1);
join_num_of_segments = 0;
for i = 1 : num_of_test_file
    
    % Input/Output/Length  % num_of_segments
    join_segment_list{i} = ...
        RMSDOWN_FIXnICA_splice_func(test_filename_list{i}, target_sample_rate, RMS_window_size, downsample_filter_order, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel, mpu_segment_threshold, mpu_segment_index, V, W);
    join_num_of_segments = join_num_of_segments ...
                            + length(join_segment_list{i});
%     fprintf('Processed File %d\n', i);
end

output_fileID = fopen(test_output_file, 'w');

%fprintf('# of sample: %d\n', num_of_file);
fprintf(output_fileID, '%d\n', join_num_of_segments);

for i = 1 : num_of_test_file
    num_of_segments = length(join_segment_list{i});
    for r = 1 : num_of_segments
        input = join_segment_list{i}{r, 1};
        output = join_segment_list{i}{r, 2};
        segment_length = join_segment_list{i}{r, 3};

        % Input
        fprintf(output_fileID, '%d %d\n', ...
                segment_length, ...
                semg_channel_count);
        fprintf(output_fileID, '%f\t', input);
        fprintf(output_fileID, '\n');

        % Output: Force + Angle
        fprintf(output_fileID, '%d %d\n', ...
                segment_length, ...
                1);
        fprintf(output_fileID, '%f\t', output);
        fprintf(output_fileID, '\n'); 

    %         figure;
    %         subplot_helper(1:length(input), input, ...
    %                         [2 1 1], {'sample' 'amplitude' 'Interpolated sEMG'}, '-');                       
    %         ylim([-1 1]);     
    %         subplot_helper(1:length(output), output, ...
    %                         [2 1 2], {'sample' 'amplitude' 'Interpolated Angle'}, '-');                                       
    %         ylim([-1 1]); 
    end  
end

fclose(output_fileID);

%% Run

fprintf(['./rnn.exe ', train_output_filename, ' ', ...
    test_output_filename, ' ', cross_output_filename, ...
    ' ', hidden_node_count, ' ', epoch, ' ', cross_valid_patience, ...
    ' 10 100000 ', rand_seed, '\n']);

origin_dir = pwd;
cd('../../../../RNN/LSTM/');
[status,cmdout] = system(['rnn.exe ', train_output_filename, ' ', ...
    test_output_filename, ' ', cross_output_filename, ...
    ' ', hidden_node_count, ' ', epoch, ' ', cross_valid_patience, ...
    ' 10 100000 ', rand_seed, '\n']);
cd(origin_dir);


rnn_result = regexp(cmdout, '[\f\n\r]', 'split');
rnn_result = rnn_result(end-4:end-1);
fprintf([rnn_result{1} newline rnn_result{2} newline rnn_result{3} newline rnn_result{4} newline]);

rnn_result_plaintext = [rnn_result_plaintext rnn_result{1} newline rnn_result{2} newline rnn_result{3} newline rnn_result{4} newline];

% close all;
% Show test file result
verify_multi_semg(test_output_filename);

end
end
rnn_result_plaintext = [rnn_result_plaintext newline];
end


clipboard('copy', rnn_result_plaintext);
fprintf(rnn_result_plaintext);

set(0,'DefaultFigureVisible','on');
msgbox('Ding!');
% beep2()
