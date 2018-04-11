clear; close all;

addpath('../matlab_lib');
addpath('../matlab_lib/FastICA_21');

filename = './data/raw_S2WA_TABLE_2_EXT_1.txt';
output_filename = ...
    strcat('../../../../Ethereun/RNN/LSTM/data/input/', ...
    'exp_S2WA_TABLE_2_EXT_1_ICA_DS10_RMS100_FULL.txt');

target_sample_rate = 10;
RMS_window_size = 100;

semg_sample_rate = 540; % Approximate

semg_channel_count = 2;
mpu_channel_count = 2;

semg_channel = 1:2;
mpu_channel = 3:4;  % 3: Roll(Pro/Sup) / 4: Pitch(Flex/Ext)

semg_max_value = 2048;
semg_min_value = -2048;
mpu_max_value = 90;
mpu_min_value = -90;


%% ICA
raw_data = csvread(filename);
semg = raw_data(:, semg_channel);
semg = semg - mean(semg);
semg = RMS_calc(semg, RMS_window_size);
semg = semg ./ semg_max_value;    



[ica_semg, icaA, seperating_matrix] = fastica(semg', ...
    'verbose', 'off', 'displayMode', 'off');
ica_semg = ica_semg';

figure;
subplot_helper(1:length(semg), semg, ...
                [2 1 1], {'sample' 'amplitude' 'Before ICA'}, '-');                       
subplot_helper(1:length(ica_semg), ica_semg, ...
                [2 1 2], {'sample' 'amplitude' 'After ICA'}, '-');  


semg_max_value = 2048 * 10;
semg_min_value = -2048 * 10;

%% Process

full_sig = ...
    semg_mpu_full_process_ICA(filename, target_sample_rate, RMS_window_size, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel, seperating_matrix);
%% Output
output_fileID = fopen(output_filename, 'w');

fprintf(output_fileID, '%d\n', 1);

% Input: sEMG
fprintf(output_fileID, '%d %d\n', full_sig{3}, ...
        semg_channel_count);
fprintf(output_fileID, '%f\t', full_sig{1});
fprintf(output_fileID, '\n');

% Output: MPU
fprintf(output_fileID, '%d %d\n', full_sig{3}, ...
        mpu_channel_count);
fprintf(output_fileID, '%f\t', full_sig{2});
fprintf(output_fileID, '\n');  

fclose(output_fileID);
