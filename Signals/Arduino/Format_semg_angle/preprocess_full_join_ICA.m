clear; close all;

addpath('../matlab_lib');
addpath('../matlab_lib/FastICA_21');

%% RNN
hidden_node_count = '8';
epoch = '1000';
rand_seed = '4';


%% File
ica_filename_list = { ...
    './data/raw_S2WA_6_SUP_3.txt'
    };

train_filename_list = { ...
    './data/raw_S2WA_6_SUP_3.txt'
    };

train_output_filename = 'S2WA_6_SUP_3_ICA_DS4_RMS100_FULL';
train_output_file = ...
    strcat('../../../../RNN/LSTM/data/input/exp_', ...
            train_output_filename, '.txt');

mpu_shift_val = [50 0]; % Roll/Pitch The bias of mpu in degree


test_filename = ...
    './data/raw_S2WA_6_SUP_3.txt';

test_output_filename = 'S2WA_6_SUP_3_ICA_DS4_RMS100_FULL';
test_output_file = ...
    strcat('../../../../RNN/LSTM/data/input/exp_', ...
            test_output_filename, '.txt');
               
target_sample_rate = 4;
RMS_window_size = 100;    % RMS window in pts

semg_sample_rate = 540; % ApSUPximate
semg_max_value = 2048;
semg_min_value = -2048;
mpu_max_value = 90;
mpu_min_value = -90;

semg_channel_count = 2;
mpu_channel_count = 2;

semg_channel = 1:2;
mpu_channel = 3:4;  % 3: Roll(SUP/SUP) / 4: Pitch(Flx/Ext)


num_of_file = length(train_filename_list);


%% ICA is processed on the concated semg
concat_semg = [];
for i = 1 : length(ica_filename_list)
    raw_data = csvread(ica_filename_list{i});
    semg = raw_data(:, semg_channel);
    semg = semg - mean(semg);
    semg = RMS_calc(semg, RMS_window_size);
    semg = semg ./ semg_max_value;    
    
    % Remove unstable value
    semg = semg(10:end - 10, :);
  
    concat_semg = [concat_semg semg'];    
end


[icasig, mixing_matrix, seperating_matrix] = fastica(concat_semg, ...
    'verbose', 'off', 'displayMode', 'off');

figure;
subplot_helper(1:length(concat_semg), concat_semg, ...
                [2 1 1], {'sample' 'amplitude' 'Before ICA'}, '-');                       
subplot_helper(1:length(icasig), icasig, ...
                [2 1 2], {'sample' 'amplitude' 'After ICA'}, '-');  

% Why does the amplitude of ICA_sig change?
% x10 because it seems to be the min/max of JOINT_ICA_sig
semg_max_value = 2048 * 10;
semg_min_value = -2048 * 10;
% return;
%% process

join_segment_list = cell(num_of_file, 1);
for i = 1 : num_of_file
    
    % Input/Output/Length  % num_of_segments
    join_segment_list{i} = ...
        semg_mpu_full_process_ICA(train_filename_list{i}, target_sample_rate, RMS_window_size, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, mpu_shift_val, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel, seperating_matrix);        
    fprintf('Processed File %d\n', i);
end


%% Output segment

output_fileID = fopen(train_output_file, 'w');

fprintf('# of sample: %d\n', num_of_file);
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
    semg_mpu_full_process_ICA(test_filename, target_sample_rate, RMS_window_size, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, mpu_shift_val, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel, seperating_matrix);


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
    ' ', hidden_node_count, ' ', epoch, ' 10 100000 ', rand_seed, '\n']);
cd(origin_dir);

rnn_result = regexp(cmdout, '[\f\n\r]', 'split');
rnn_result = rnn_result(end-3:end-1);

rnn_result_plaintext = [rnn_result{1} newline rnn_result{2} newline rnn_result{3} newline];
fprintf(rnn_result_plaintext);
clipboard('copy', rnn_result_plaintext);
