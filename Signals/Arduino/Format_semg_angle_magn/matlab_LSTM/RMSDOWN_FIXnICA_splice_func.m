function processed_segments = RMSDOWN_FIXnICA_splice_func(train_filename, target_sample_rate, RMS_window_size, downsample_filter_order, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel, mpu_segment_threshold, mpu_segment_index, V, W)

% Interpolate angle data and output data splice
% Output consists of all semg channel and 
% 'mpu_segment_index' mpu channel

% Normalize mpu_segment_threshold
mpu_segment_threshold = 2 * (mpu_segment_threshold - mpu_min_value) ...
        / (mpu_max_value - mpu_min_value) - 1;



%% Process
raw_data = csvread(train_filename);
semg = raw_data(:, semg_channel);
mpu = raw_data(:, mpu_channel);

semg = semg(10:end-10, :);
semg = semg - mean(semg);

% Angle data interpolation
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

% RMS
semg = RMS_calc(semg, RMS_window_size);

  
% Whitten-nICA demix
semg = (W * V * semg')'; 

% Downsample
downsample_ratio = floor(semg_sample_rate / target_sample_rate);
[semg, cb, ca] = butter_filter( ...
        semg, downsample_filter_order, target_sample_rate, semg_sample_rate);   
semg = downsample(semg, downsample_ratio);
[mpu, cb, ca] = butter_filter( ...
        mpu, downsample_filter_order, target_sample_rate, semg_sample_rate);   
mpu = downsample(mpu, downsample_ratio); 


% Normalization
semg =  semg ...
        ./ (semg_max_value - semg_min_value);    

mpu =  2.*(mpu - mpu_min_value)...
        ./ (mpu_max_value - mpu_min_value) - 1;

if max(max(semg)) > 1
    disp('Range error');
    max(max(semg))
    return;
end



% Angle segmentation
% Divide the data from the middle of each angle action
% Force action: Angle >= angle_threshold

mpu_segments = zeros(size(mpu, 1), 1);
mpu_segments(abs(mpu(:, mpu_segment_index)) > mpu_segment_threshold) = 1;

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
    cutoff_mpu = mpu(cutoff_range, mpu_segment_index);

    processed_segments{i - 1, 1} = cutoff_semg';
    processed_segments{i - 1, 2} = cutoff_mpu';
    processed_segments{i - 1, 3} = length(cutoff_range);       
end   