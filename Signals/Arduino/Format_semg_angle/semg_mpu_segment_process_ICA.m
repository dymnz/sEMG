function [processed_segments, num_of_sample] = semg_mpu_segment_process_ICA(filename, target_sample_rate, RMS_window_size, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, mpu_threshold, mpu_segment_index, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel, seperating_matrix)


raw_data = csvread(filename);
semg = raw_data(:, semg_channel);
mpu = raw_data(:, mpu_channel);

% Remove mean
semg = semg - mean(semg);

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

% figure;
% subplot_helper(1:length(semg), semg, ...
%                 [2 1 1], {'sample' 'amplitude' 'sEMG'}, '-');
% subplot_helper(1:length(mpu), mpu, ...
%                 [2 1 2], {'sample' 'amplitude' 'Interpolated angle'}, '-');         
% ylim([-90 90]);


%% ICA demix
semg = (seperating_matrix * semg')';

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

if RMS_window_size <= 0
    semg = semg - mean(semg);
end
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
legend('EMG-1', 'EMG-2', 'Angle-1', 'Angle-2');
%% Angle segmentation
% Divide the data from the middle of each angle action
% Force action: Angle >= angle_threshold

[smoothed_mpu, cb, ca] = butter_filter( ...
        mpu(:, mpu_segment_index), filter_order, 2, target_sample_rate);
mpu_segments = zeros(length(mpu), 1);

if mpu_threshold < 0
    mpu_segments(smoothed_mpu < mpu_threshold) = 1;
else 
    mpu_segments(smoothed_mpu > mpu_threshold) = 1;
end

% figure;
% subplot_helper(1:length(mpu), mpu, ...
%                 [1 1 1], {'sample' 'amplitude' 'Normalized angle'}, '-');         
% subplot_helper(1:length(mpu_segments), mpu_segments, ...
%                 [1 1 1], {'sample' 'amplitude' 'Normalized sEMG'}, '-');                       
% subplot_helper(1:length(mpu_segments),mpu_threshold * ones(size(mpu_segments)), ...
%                 [1 1 1], {'sample' 'amplitude' 'Normalized sEMG'}, '-');                                   
% ylim([-1 1]);

% [segment start , segment end]
segment_indices = ...
    [find(([mpu_segments; 0] - [0; mpu_segments]) == 1) , ...
    find(([mpu_segments; 0] - [0; mpu_segments]) == -1)];

% (start_n+1 + end_n) / 2
mid_segment_indices = ...
    floor(([segment_indices(:, 1) ; segment_indices(end, 2)] + [0 ; segment_indices(:, 2)]) / 2);
mid_segment_indices(mid_segment_indices < 1) = 1;
% mid_segment_indices = mid_segment_indices(1:end-1, :);

num_of_sample = length(mid_segment_indices) - 1;

processed_segments = cell(num_of_sample, 3);
for i = 2 : length(mid_segment_indices)
    cutoff_range = mid_segment_indices(i - 1) : mid_segment_indices(i);
    
    cutoff_semg = semg(cutoff_range, :);
    cutoff_mpu = mpu(cutoff_range, :);
    
    processed_segments{i - 1, 1} = cutoff_semg';
    processed_segments{i - 1, 2} = cutoff_mpu';
    processed_segments{i - 1, 3} = length(cutoff_range);       
end