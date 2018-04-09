clear; close all;

addpath('../matlab_lib');

file_name = './data/raw_S2WA_TABLE_EXT_4.txt';
test_output_filename = ...
    strcat('../../../../Ethereun/RNN/LSTM/data/input/', ...
    'exp_S2WA_TABLE_EXT_4_DS200_RMS0_FULL.txt');

target_sample_rate = 200;
RMS_window_size = 0;
semg_sample_rate = 540; % Approximate

semg_channel_count = 2;
mpu_channel_count = 2;

semg_channel = 1:2;
mpu_channel = 3:4;  % 3: Roll(Pro/Sup) / 4: Pitch(Flex/Ext)

semg_max_value = 2048;
semg_min_value = -2048;
mpu_max_value = 90;
mpu_min_value = -90;

raw_data = csvread(file_name);
semg = raw_data(:, semg_channel);
mpu = raw_data(:, mpu_channel);

% Remove mean
semg = semg - mean(semg);

%% Original

fprintf('original signal time: %.2f\n', length(semg)/semg_sample_rate);

% figure;
% subplot_helper(1:length(semg), semg, ...
%                 [2 1 1], {'sample' 'au' 'sEMG'}, '-o');
% subplot_helper(1:length(mpu), mpu, ...
%                 [2 1 1], {'sample' 'au' 'Angle'}, '-o');


%% Angle data interpolation
%mpu(abs(mpu)<1e-3) = 0;

for ch = 1 : mpu_channel_count
    start_point = 1;
    i = 1;
    while i + 1 < length(mpu)
       i = i + 1; 
       if abs(mpu(i, ch)) > 0
        end_point = i;
        xq = start_point : 1 : end_point;
        mpu(start_point:end_point, ch) = ...
            interp1([start_point end_point], ...
                [mpu(start_point, ch) mpu(end_point, ch)], xq);            
       start_point = i;
       end
    end
    end_point = length(mpu);
    xq = start_point : 1 : end_point;
    mpu(start_point:end_point, ch) = ...
        interp1([start_point end_point], ...
            [mpu(start_point, ch) mpu(end_point, ch)], xq);        
end    

% figure;
% subplot_helper(1:length(semg), semg, ...
%                 [2 1 1], {'sample' 'amplitude' 'sEMG'}, '-');
% subplot_helper(1:length(mpu), mpu, ...
%                 [2 1 2], {'sample' 'amplitude' 'Interpolated angle'}, '-');         
% ylim([-90 90]);

%% sEMG RMS & Angle delay
semg = RMS_calc(semg, RMS_window_size);
mpu = [(mpu(1, :) .* ones(RMS_window_size, size(mpu, 2))) ; mpu];

figure;
subplot_helper(1:length(semg), semg, ...
                [2 1 1], {'sample' 'amplitude' 'sEMG'}, '-');
subplot_helper(1:length(mpu), mpu, ...
                [2 1 2], {'sample' 'amplitude' 'Interpolated angle'}, '-');         
ylim([-90 90]);


%% Downsample
downsample_ratio = floor(semg_sample_rate / target_sample_rate);

filter_order = 6;
[semg, cb, ca] = butter_filter( ...
        semg, filter_order, target_sample_rate, semg_sample_rate);
[mpu, cb, ca] = butter_filter( ...
        mpu, filter_order, target_sample_rate, semg_sample_rate);    

semg = downsample(semg, downsample_ratio);
mpu = downsample(mpu, downsample_ratio);


% figure;
% subplot_helper(1:length(semg), semg, ...
%                 [2 1 1], {'sample' 'amplitude' 'Downsampled sEMG'}, '-');
% subplot_helper(1:length(mpu), mpu, ...
%                 [2 1 2], {'sample' 'amplitude' 'Downsampled angle'}, '-');         
% ylim([-90 90]);    

%% Restrain SEMG range
semg(semg > semg_max_value) = semg_max_value;
semg(semg < semg_min_value) = semg_min_value;


%% Remove faulty data
usable_data_range = 1 : min(length(semg), length(mpu));
semg = semg(usable_data_range, :);
mpu = mpu(usable_data_range, :);

% figure;
% subplot_helper(1:length(semg), semg, ...
%                 [2 1 1], {'sample' 'amplitude' 'Truncated sEMG'}, '-');
% subplot_helper(1:length(mpu), mpu, ...
%                 [2 1 2], {'sample' 'amplitude' 'Truncated angle'}, '-');         
% ylim([-90 90]);  

%% Rectify and Normalization
semg = semg - mean(semg);
% semg = abs(semg);
semg =  2.*(semg - semg_min_value)...
        ./ (semg_max_value - semg_min_value) - 1;

mpu =  2.*(mpu - mpu_min_value)...
        ./ (mpu_max_value - mpu_min_value) - 1;    
    
    
figure;
subplot_helper(1:length(semg), semg, ...
                [1 1 1], {'sample' 'amplitude' 'Normalized sEMG'}, '-');           
subplot_helper(1:length(mpu), mpu, ...
                [1 1 1], {'sample' 'amplitude' 'Normalized angle'}, '-');         
ylim([-1 1]);
%% Force segmentation
% Divide the data from the middle of each force action
% Force action: Froce >= force_threshold
output_fileID = fopen(test_output_filename, 'w');


fprintf(output_fileID, '%d\n', 1);
% Input: sEMG
fprintf(output_fileID, '%d %d\n', length(semg), ...
        semg_channel_count);
fprintf(output_fileID, '%f\t', semg');
fprintf(output_fileID, '\n');

% Output: MPU
fprintf(output_fileID, '%d %d\n', length(semg), ...
        mpu_channel_count);
fprintf(output_fileID, '%f\t', mpu');
fprintf(output_fileID, '\n');  

fclose(output_fileID);
