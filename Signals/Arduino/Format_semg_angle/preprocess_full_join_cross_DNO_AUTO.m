clear; close all;

set(0,'DefaultFigureVisible','on');
% set(0,'DefaultFigureVisible','off');

addpath('../matlab_lib');
addpath('../matlab_lib/FastICA_21');

file_to_test = {
    {{{'SUP_1', 'SUP_2', 'SUP_3', 'SUP_4', 'PRO_1', ...
        'PRO_2', 'PRO_3', 'PRO_4', 'PROSUP_2'}, {'PRO_5', 'SUP_5'}}, 'PROSUP_1'};   
};


%% RNN
hidden_node_count_list = {'8'};
epoch = '1000';
rand_seed = '4';
cross_valid_patience_list = {'100'};


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
file_loc_prepend = './data/raw_';
filename_prepend = 'S2WA_7_';
file_extension = '.txt';

ica_file_label_list = file_to_test{f}{1}{1};
train_file_label_list = file_to_test{f}{1}{1};
cross_file_label_list = file_to_test{f}{1}{2};
test_file_label = file_to_test{f}{2};

%% Signal Setting
target_sample_rate = 10;
RMS_window_size = 100;    % RMS window in pts


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
    '_DNO', ...
    '_DS', num2str(target_sample_rate), ...
    '_RMS', num2str(RMS_window_size), '_FULL'];
train_output_file = ...
   [ '../../../../RNN/LSTM/data/input/exp_', ...
            train_output_filename, file_extension];

cross_output_filename = [ ...
    filename_prepend, ...
    strjoin(cross_file_label_list, '_'), ...
    '_DNO', ...
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

semg_sample_rate = 540; % Approximate
semg_max_value = 2048;
semg_min_value = -2048;
mpu_max_value = 90;
mpu_min_value = -90;

semg_channel_count = 2;
mpu_channel_count = 2;

semg_channel = 1:2;
mpu_channel = 3:4;  % 3: Roll(SUP/SUP) / 4: Pitch(Flx/Ext)

num_of_train_file = length(train_filename_list);
num_of_cross_file = length(cross_filename_list);

%% ICA is processed on the concated semg
concat_semg = [];
for i = 1 : length(ica_filename_list)
    raw_data = csvread(ica_filename_list{i});
    semg = raw_data(:, semg_channel);

    % Remove unstable value
    semg = semg(10:end - 10, :);
  
    concat_semg = [concat_semg semg'];    
end

concat_semg = concat_semg - mean(concat_semg, 2) * ones(1, length(concat_semg));

concat_semg = RMS_calc(concat_semg', RMS_window_size)';

filter_order = 6;
downsample_ratio = floor(semg_sample_rate / target_sample_rate);
[concat_semg, cb, ca] = butter_filter( ...
        concat_semg', filter_order, target_sample_rate, semg_sample_rate);   
concat_semg = downsample(concat_semg, downsample_ratio)';

semg_max_value = max(max(concat_semg)) * 1.3;
semg_min_value = min(0, min(min(concat_semg)) * 1.3);
seperating_matrix = [];
%% Process & Output - Train

join_segment_list = cell(num_of_train_file, 1);
for i = 1 : num_of_train_file    
    % Input/Output/Length  % num_of_segments
    join_segment_list{i} = ...
        semg_mpu_full_process(train_filename_list{i}, target_sample_rate, RMS_window_size, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, mpu_shift_val, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel, seperating_matrix);        
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
        semg_mpu_full_process(cross_filename_list{i}, target_sample_rate, RMS_window_size, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, mpu_shift_val, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel, seperating_matrix);        
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
    semg_mpu_full_process(test_filename, target_sample_rate, RMS_window_size, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, mpu_shift_val, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel, seperating_matrix);


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


close all;
% Show test file result
verify_multi_semg(test_output_filename);

rnn_result = regexp(cmdout, '[\f\n\r]', 'split');
rnn_result = rnn_result(end-4:end-1);

rnn_result_plaintext = [rnn_result_plaintext rnn_result{1} newline rnn_result{2} newline rnn_result{3} newline rnn_result{4} newline];

end
end
rnn_result_plaintext = [rnn_result_plaintext newline];
end


clipboard('copy', rnn_result_plaintext);
fprintf(rnn_result_plaintext);

set(0,'DefaultFigureVisible','on');
msgbox('Ding!');
beep2();
