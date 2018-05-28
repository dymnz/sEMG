clear; close all;

set(0,'DefaultFigureVisible','on');
% set(0,'DefaultFigureVisible','off');

addpath('../matlab_lib');
addpath('../matlab_lib/FastICA_21');

%% Setting

% Wavelet setting
wname = 'db45';
wlevel = 1;

pulse_threshold = [50 50 20 50];

file_loc_prepend = './data/raw_';
file_extension = '.txt';

filename_prepend = 'S2WA_10_';
file_to_test = {  
    % Hard self
    {{{'PRO_1', 'PRO_2', 'PRO_4', 'SUP_1', 'SUP_2', 'SUP_4', ...
       'FLX_1', 'FLX_2', 'FLX_4', 'EXT_1', 'EXT_2', 'EXT_4', ...
       'PRO_3', 'SUP_3', 'FLX_3', 'EXT_3'},...
        {'PRO_3', 'SUP_3', 'FLX_3', 'EXT_3'}}, ...
        'PRO_5'}
};



% RNN
hidden_node_count_list = {'16'};
epoch = '1000';
rand_seed = '4';
cross_valid_patience_list = {'100'};

% Signal Setting
target_sample_rate = 10;
RMS_window_size = 100;    % RMS window in pts

semg_sample_rate = 460; % Approximate
semg_max_value = 2048;
semg_min_value = -2048;
mpu_max_value = 90;
mpu_min_value = -90;

semg_channel_count = 4;
mpu_channel_count = 2;

semg_channel = 1:4;
mpu_channel = 5:6;  % 5: Pitch(Flx/Ext) / 6: Roll(SUP/SUP) 

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

ica_file_label_list = file_to_test{f}{1}{1};
train_file_label_list = file_to_test{f}{1}{1};
cross_file_label_list = file_to_test{f}{1}{2};
test_file_label = file_to_test{f}{2};


%% File

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

ica_filename_list = cell(1, length(ica_file_label_list));
for i = 1 : length(train_file_label_list)
    ica_filename_list{i} = ...
        [file_loc_prepend, filename_prepend, ...
            ica_file_label_list{i}, file_extension];
end


train_output_filename = [ ...
    filename_prepend, ...
    strjoin(train_file_label_list, '_'), ...
    '_RAW', ...
    '_DS', num2str(target_sample_rate), ...
    '_RMS', num2str(RMS_window_size), '_FULL'];

if length(train_output_filename) > 100
    truncated_train_file_label_list = train_file_label_list(1:5);
    
    train_output_filename = [ ...
    filename_prepend, ...
    strjoin(truncated_train_file_label_list, '_'), ...
    '_TRUNCAT', ...
    '_RAW', ...
    '_DS', num2str(target_sample_rate), ...
    '_RMS', num2str(RMS_window_size), '_FULL'];
end

train_output_file = ...
   [ '../../../../RNN/LSTM/data/input/exp_', ...
            train_output_filename, file_extension];


cross_output_filename = [ ...
    filename_prepend, ...
    strjoin(cross_file_label_list, '_'), ...
    '_RAW', ...
    '_DS', num2str(target_sample_rate), ...
    '_RMS', num2str(RMS_window_size), '_FULL'];
cross_output_file = ...
   [ '../../../../RNN/LSTM/data/input/exp_', ...
           cross_output_filename, file_extension];              
        
mpu_shift_val = [0 0]; % Roll/Pitch The bias of mpu in degree

test_filename = [ ...
    file_loc_prepend, filename_prepend, test_file_label, file_extension];
test_output_filename = [ ...
    filename_prepend, ...
    test_file_label, ...
    '_DNO', ...
    '_DS', num2str(target_sample_rate), ...
    '_RMS', num2str(RMS_window_size), '_FULL'];
test_output_file = [ ...
    '../../../../RNN/LSTM/data/input/exp_', ...
        test_output_filename, file_extension];              

num_of_train_file = length(train_filename_list);
num_of_cross_file = length(cross_filename_list);

%% Filtering is processed on the concated semg to get the max/min value
concat_semg = [];
for i = 1 : length(ica_filename_list)
    raw_data = csvread(ica_filename_list{i});
    semg = raw_data(:, semg_channel);

    % Remove front and end to avoid noise
    semg = semg(10:end-10,:);
    semg = semg - mean(semg);
  
    concat_semg = [concat_semg semg'];    
end


concat_semg = concat_semg - ones(size(concat_semg)) .* mean(concat_semg, 2);
% variance = (sqrt(var(concat_semg'))') .* ones(semg_channel_count, length(concat_semg));
% concat_semg = concat_semg ./ variance;

wavelet_concat_semg = zeros(semg_channel_count, 1);
for ch = 1 : semg_channel_count
    [cA,cD] = dwt(concat_semg(ch, :), wname);        
    for w = 1 : wlevel - 1
        [cA,cD] = dwt(cA, wname);                
    end
    
    cA = idwt(cA, zeros(size(cA)), wname);    
    for w = 1 : wlevel - 1
        cA = idwt(cA, zeros(size(cA)), wname);    
    end
    
    wavelet_concat_semg(ch, 1 : length(cA)) = cA';
end

filtered_semg = semg_find_pulse(wavelet_concat_semg', pulse_threshold);

filter_order = 6;
downsample_ratio = floor(semg_sample_rate / target_sample_rate);
[filtered_semg, cb, ca] = butter_filter( ...
        filtered_semg, filter_order, target_sample_rate, semg_sample_rate);   
filtered_semg = downsample(filtered_semg, downsample_ratio);


filtered_semg(filtered_semg < 0) = 0;
% 
% figure;
% subplot_helper(1:length(wavelet_concat_semg), wavelet_concat_semg(1, :), ...
%                 [4 1 1], {'sample' 'amplitude' 'Before ICA'}, '-');                                                                  
% subplot_helper(1:length(wavelet_concat_semg), wavelet_concat_semg(2, :), ...    
%                 [4 1 2], {'sample' 'amplitude' 'Before ICA'}, '-'); 
% subplot_helper(1:length(wavelet_concat_semg), wavelet_concat_semg(3, :), ...
%                 [4 1 3], {'sample' 'amplitude' 'Before ICA'}, '-');                                                                  
% subplot_helper(1:length(wavelet_concat_semg), wavelet_concat_semg(4, :), ...    
%                 [4 1 4], {'sample' 'amplitude' 'Before ICA'}, '-');        
% figure;
% subplot_helper(1:length(filtered_semg), filtered_semg(:, 1), ...
%                 [4 1 1], {'sample' 'amplitude' 'Before ICA'}, '-o'); 
% subplot_helper(1:length(filtered_semg), filtered_semg(:, 2), ...    
%                 [4 1 2], {'sample' 'amplitude' 'Before ICA'}, '-o'); 
% subplot_helper(1:length(filtered_semg), filtered_semg(:, 3), ...
%                 [4 1 3], {'sample' 'amplitude' 'Before ICA'}, '-o'); 
% subplot_helper(1:length(filtered_semg), filtered_semg(:, 4), ...    
%                 [4 1 4], {'sample' 'amplitude' 'Before ICA'}, '-o'); 
%    
% semg_max_value = max(filtered_semg) .* 1.5;
% semg_min_value = zeros(1, semg_channel_count);         
%             
% filtered_semg =  filtered_semg ...
%         ./ (semg_max_value - semg_min_value); 
% figure;
% subplot_helper(1:length(filtered_semg), filtered_semg(:, 1), ...
%                 [4 1 1], {'sample' 'amplitude' 'Before ICA'}, '-o'); 
% ylim([0 1]);
% subplot_helper(1:length(filtered_semg), filtered_semg(:, 2), ...    
%                 [4 1 2], {'sample' 'amplitude' 'Before ICA'}, '-o'); 
% ylim([0 1]);
% subplot_helper(1:length(filtered_semg), filtered_semg(:, 3), ...
%                 [4 1 3], {'sample' 'amplitude' 'Before ICA'}, '-o'); 
% ylim([0 1]);
% subplot_helper(1:length(filtered_semg), filtered_semg(:, 4), ...    
%                 [4 1 4], {'sample' 'amplitude' 'Before ICA'}, '-o'); 
% ylim([0 1]);
% return;



semg_max_value = max(filtered_semg) .* 2;
semg_min_value = zeros(1, semg_channel_count);

%% Process & Output - Train

join_segment_list = cell(num_of_train_file, 1);
for i = 1 : num_of_train_file    
    % Input/Output/Length  % num_of_segments
    join_segment_list{i} = ...
        semg_mpu_full_process_wavelet_PULSE(train_filename_list{i}, target_sample_rate, RMS_window_size, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, mpu_shift_val, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel, pulse_threshold, wlevel, wname);    
    %fprintf('Processed File %d\n', i);
end

output_fileID = fopen(train_output_file, 'w');

%fprintf('# of sample: %d\n', num_of_file);
fprintf(output_fileID, '%d\n', num_of_train_file);

for i = 1 : num_of_train_file
    input = join_segment_list{i}{1};
    output = join_segment_list{i}{2};

    % Input
    fprintf(output_fileID, '%d %d\n', ...
            join_segment_list{i}{3}, ...
            semg_channel_count);
    fprintf(output_fileID, '%f\t', input);
    fprintf(output_fileID, '\n');

    % Output: Force + Angle
    fprintf(output_fileID, '%d %d\n', ...
            join_segment_list{i}{3}, ...
            mpu_channel_count);
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

fclose(output_fileID);

%% Process & Output - Cross
    
join_segment_list = cell(num_of_cross_file, 1);
for i = 1 : num_of_cross_file
    
    % Input/Output/Length  % num_of_segments
    join_segment_list{i} = ...
        semg_mpu_full_process_wavelet_PULSE(cross_filename_list{i}, target_sample_rate, RMS_window_size, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, mpu_shift_val, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel, pulse_threshold, wlevel, wname);      
    %fprintf('Processed File %d\n', i);
end


output_fileID = fopen(cross_output_file, 'w');

%fprintf('# of sample: %d\n', num_of_file);
fprintf(output_fileID, '%d\n', num_of_cross_file);

for i = 1 : num_of_cross_file
    input = join_segment_list{i}{1};
    output = join_segment_list{i}{2};

    % Input
    fprintf(output_fileID, '%d %d\n', ...
            join_segment_list{i}{3}, ...
            semg_channel_count);
    fprintf(output_fileID, '%f\t', input);
    fprintf(output_fileID, '\n');

    % Output: Force + Angle
    fprintf(output_fileID, '%d %d\n', ...
            join_segment_list{i}{3}, ...
            mpu_channel_count);
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

fclose(output_fileID);


%% Output full

% Input/Output/Length  % num_of_segments
full_sig = ...    
    semg_mpu_full_process_wavelet_PULSE(test_filename, target_sample_rate, RMS_window_size, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, mpu_shift_val, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel, pulse_threshold, wlevel, wname);


output_fileID = fopen(test_output_file, 'w');

input = full_sig{1};
output = full_sig{2};
        
fprintf(output_fileID, '%d\n', 1);
% Input: sEMG
fprintf(output_fileID, '%d %d\n', ...
        full_sig{3}, ...
        semg_channel_count);
fprintf(output_fileID, '%f\t', input);
fprintf(output_fileID, '\n');

% Output: Force + Angle
fprintf(output_fileID, '%d %d\n', ...
        full_sig{3}, ...
        mpu_channel_count);
fprintf(output_fileID, '%f\t', output);
fprintf(output_fileID, '\n'); 

fclose(output_fileID);


%% Run

fprintf(['./rnn ', train_output_filename, ' ', ...
    test_output_filename, ' ', cross_output_filename, ...
    ' ', hidden_node_count, ' ', epoch, ' ', cross_valid_patience, ...
    ' 10 100000 ', rand_seed, '\n']);

origin_dir = pwd;
cd('../../../../RNN/LSTM/');
[status,cmdout] = system(['./rnn ', train_output_filename, ' ', ...
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
beep2();
