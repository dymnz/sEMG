clear; close all;

addpath('../matlab_lib');
addpath('../matlab_lib/FastICA_21');

ica_filename_list = { ...
    './data/raw_S2WA_5_SUP_1.txt'
    };

train_filename_list = { ...
    './data/raw_S2WA_5_SUP_1.txt'
    };
train_output_filename = ...
    strcat('../../../../RNN/LSTM/data/input/', ...
    'exp_S2WA_5_SUP_1_ICA_DS10_RMS100_SEG.txt');

mpu_segment_index = 1; % 1: Roll / 2: Pitch
angle_threshold_list = [30]; % +15 for FLX/SUP / -15 for EXT/PRO
mpu_shift_val = [50 0]; % Roll/Pitch The bias of mpu in degree


test_filename = ...
    './data/raw_S2WA_5_SUP_1.txt';
test_output_filename = ...
    strcat('../../../../RNN/LSTM/data/input/', ...
    'exp_S2WA_5_SUP_1_ICA_DS10_RMS100_FULL.txt');

target_sample_rate = 10;
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
join_num_of_segment_list = zeros(num_of_file, 1);
for i = 1 : num_of_file
    
    % Degree divided +- 90d normalization
    mpu_threshold = angle_threshold_list(i) / mpu_max_value;
    
    % Input/Output/Length  % num_of_segments
    [join_segment_list{i}, num_of_segment] = ...
        semg_mpu_segment_process_ICA(train_filename_list{i}, target_sample_rate, RMS_window_size, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, mpu_threshold, mpu_shift_val, mpu_segment_index, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel, seperating_matrix);
    
    join_num_of_segment_list(i) = num_of_segment;
    fprintf('File %d has %d segments\n', i, num_of_segment);
end

join_num_of_segment = sum(join_num_of_segment_list);

%% Output segment

output_fileID = fopen(train_output_filename, 'w');

fprintf('# of sample: %d\n', join_num_of_segment);
fprintf(output_fileID, '%d\n', join_num_of_segment);

for i = 1 : num_of_file
    for r = 1 : join_num_of_segment_list(i)
        
        input = join_segment_list{i}{r, 1};
        output = join_segment_list{i}{r, 2};
        
        % Input
        fprintf(output_fileID, '%d %d\n', ...
                join_segment_list{i}{r, 3}, ...
                semg_channel_count);
        fprintf(output_fileID, '%f\t', input);
        fprintf(output_fileID, '\n');
        
        % Output: Force + Angle
        fprintf(output_fileID, '%d %d\n', ...
                join_segment_list{i}{r, 3}, ...
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
end   

fclose(output_fileID);

%% Output full

% Input/Output/Length  % num_of_segments
full_sig = ...    
    semg_mpu_full_process_ICA(test_filename, target_sample_rate, RMS_window_size, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, mpu_shift_val, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel, seperating_matrix);


output_fileID = fopen(test_output_filename, 'w');

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