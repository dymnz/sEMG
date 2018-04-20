clear; close all;

set(0,'DefaultFigureVisible','off');

addpath('../matlab_lib');
addpath('../matlab_lib/FastICA_21');

%% Filename Prepend
file_loc_prepend = './data/raw_';
filename_prepend = 'S2WA_6_';
file_extension = '.txt';

train_file_label_list = {'PRO_1' 'PRO_2' 'PRO_3' 'SUP_1' 'SUP_2' 'SUP_3' 'PROSUP_1'};
test_file_label = 'PROSUP_2';


%% Signal Setting
target_sample_rate = 10;
RMS_window_size = 100;    % RMS window in pts

%% RNN
hidden_node_count = '8';
epoch_list = {'1000'};
rand_seed = '4';

%% For different epoch...

rnn_result_plaintext = [];
for e = 1 : length(epoch_list)
    
epoch = epoch_list{e};

% File

% Gather training filename
train_filename_list = cell(1, length(train_file_label_list));
for i = 1 : length(train_file_label_list)
    train_filename_list{i} = ...
        [file_loc_prepend, filename_prepend, ...
            train_file_label_list{i}, file_extension];
    
end

train_output_filename = [ ...
    filename_prepend, ...
    strjoin(train_file_label_list, '_'), ...
    '_DS', num2str(target_sample_rate), ...
    '_RMS', num2str(RMS_window_size), '_FULL'];
train_output_file = ...
   [ '../../../../RNN/LSTM/data/input/exp_', ...
            train_output_filename, file_extension];

mpu_shift_val = [50 0]; % Roll/Pitch The bias of mpu in degree

test_filename = [ ...
    file_loc_prepend, filename_prepend, test_file_label, file_extension];
test_output_filename = [ ...
    filename_prepend, ...
    test_file_label, ...
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


num_of_file = length(train_filename_list);

%% process

join_segment_list = cell(num_of_file, 1);
for i = 1 : num_of_file
    
    % Input/Output/Length  % num_of_segments
    join_segment_list{i} = ...
        semg_mpu_full_process(train_filename_list{i}, target_sample_rate, RMS_window_size, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, mpu_shift_val, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel);        
    %fprintf('Processed File %d\n', i);
end


%% Output segment

output_fileID = fopen(train_output_file, 'w');

%fprintf('# of sample: %d\n', num_of_file);
fprintf(output_fileID, '%d\n', num_of_file);

for i = 1 : num_of_file
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
    semg_mpu_full_process(test_filename, target_sample_rate, RMS_window_size, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, mpu_shift_val, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel);


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
    test_output_filename, ...
    ' ', hidden_node_count, ' ', epoch, ' 10 100000 ', rand_seed, '\n']);

origin_dir = pwd;
cd('../../../../RNN/LSTM/');
[status,cmdout] = system(['./rnn ', train_output_filename, ' ', ...
    test_output_filename, ...
    ' ', hidden_node_count, ' ', epoch, ' 10 100000 ', rand_seed, '\n']);cd(origin_dir);

close all;
% Show test file result
verify_multi_semg(test_output_filename);

rnn_result = regexp(cmdout, '[\f\n\r]', 'split');
rnn_result = rnn_result(end-3:end-1);

rnn_result_plaintext = [rnn_result_plaintext rnn_result{1} newline rnn_result{2} newline rnn_result{3} newline];
end

clipboard('copy', rnn_result_plaintext);
fprintf(rnn_result_plaintext);

set(0,'DefaultFigureVisible','on');
msgbox('Ding!');
beep2()