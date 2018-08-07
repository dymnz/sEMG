% Interpolate angle data and output data splice
% Output consists of all semg channel and 
% 'mpu_segment_index' mpu channel

clear; close all;

set(0,'DefaultFigureVisible','on');
% set(0,'DefaultFigureVisible','off');

addpath('../matlab_lib');
addpath('../matlab_lib/FastICA_21');

% Setting
file_loc_prepend = './data/';
file_extension = '.txt';

filename_prepend = 'raw_S2WA_21_';
output_filename_prepend = 'exp_S2WA_21_RMSDOWN_';
file_to_splice = { 
    'ICA_1'
};

mpu_segment_threshold = -10; % Degree
mpu_segment_index = 2; % 1-Roll/2-Pitch/3-Yaw


semg_channel_count = 4;
mpu_channel_count = 3;

semg_channel = 1:4;
mpu_channel = 5:7;  % Roll/Pitch/Yaw

% Signal param
semg_sample_rate = 2660; % Approximate

% Downsample/RMS param
RMS_window_size = 500;    % RMS window in pts
target_sample_rate = 100;
downsample_filter_order = 6;


semg_max_value = 2048 / 4;
semg_min_value = -2048 / 4;
mpu_max_value = 90;
mpu_min_value = -90;

% Normalize mpu_segment_threshold
mpu_segment_threshold = 2 * (mpu_segment_threshold - mpu_min_value) ...
        / (mpu_max_value - mpu_min_value) - 1;

graph_count = semg_channel_count + mpu_channel_count;


% Construct filename list
file_label_list = file_to_splice;
filename_list = cell(1, length(file_label_list));
for i = 1 : length(file_label_list)
    filename_list{i} = ...
        [file_loc_prepend, filename_prepend, ...
            file_label_list{i}, file_extension];
end

output_filename_list = cell(1, length(file_label_list));
for i = 1 : length(file_label_list)
    output_filename_list{i} = ...
        [file_loc_prepend, output_filename_prepend, ...
            file_label_list{i}, file_extension];
end


processed_segments_list = {};

%% Process
for f = 1 : length(file_label_list)
    input_filename = filename_list{f};
    output_fileID = fopen(output_filename_list{f}, 'w');
    fprintf(['Output:  ' output_filename_list{f} '\n']);
    
    raw_data = csvread(input_filename);
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
    
    if (max(max(semg)) > 1) || (min(min(semg)) < -1)
        disp('Range error');
        return;
    end
        
        
    % Display
    figure('Name', input_filename);
    
    for ch = 1 : semg_channel_count
    subplot_helper(1:length(semg), semg(:, ch), ...
                    [graph_count 1 ch], {'' '' ''}, ':x');
    end
    ylim([-1 1]);
    
    for ch = 1 : mpu_channel_count
	subplot_helper(1:length(mpu), mpu(:, ch), ...
                    [graph_count 1 ch+semg_channel_count], ...
                    {'' '' ''}, ...
                    '-');                                                         
    ylim([-1 1]);
    
    end
   
    
    % Angle segmentation
    % Divide the data from the middle of each angle action
    % Force action: Angle >= angle_threshold

    mpu_segments = zeros(size(mpu, 1), 1);

    if mpu_segment_threshold < 0
        mpu_segments(mpu(:, mpu_segment_index) < mpu_segment_threshold) = 1;
    else 
        mpu_segments(mpu(:, mpu_segment_index) > mpu_segment_threshold) = 1;
    end
    
    figure;
    subplot_helper(1:length(mpu), mpu(:, mpu_segment_index), ...
                    [1 1 1], {'sample' 'amplitude' 'Normalized angle'}, 'o');         
    subplot_helper(1:length(mpu_segments), mpu_segment_threshold .* mpu_segments, ...
                    [1 1 1], {'sample' 'amplitude' 'Normalized sEMG'}, '-');                       
    subplot_helper(1:length(mpu_segments),mpu_threshold * ones(size(mpu_segments)), ...
                    [1 1 1], {'sample' 'amplitude' 'Normalized sEMG'}, '-');                                   
    ylim([-1 1]);
   return;
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
    
    processed_segments_list{f} = processed_segments;
    
    num_of_sample = length(mid_segment_indices) - 1;
    fprintf('# of sample: %d\n', num_of_sample);
    fprintf(output_fileID, '%d\n', num_of_sample);
    for i = 2 : length(mid_segment_indices)
        cutoff_range = mid_segment_indices(i - 1) : mid_segment_indices(i);

        cutoff_semg = semg(cutoff_range, :);
        cutoff_mpu = mpu(cutoff_range, mpu_segment_index);


        % Input: sEMG
        fprintf(output_fileID, '%d %d\n', length(cutoff_semg), ...
                semg_channel_count);
        fprintf(output_fileID, '%f\t', cutoff_semg');
        fprintf(output_fileID, '\n');

        % Output: Force + Angle
        fprintf(output_fileID, '%d %d\n', length(cutoff_semg), ...
                1);
        fprintf(output_fileID, '%f\t', cutoff_mpu');
        fprintf(output_fileID, '\n'); 

        
%         figure;
%         subplot_helper(1:length(cutoff_semg), cutoff_semg, ...
%                         [2 1 1], {'sample' 'amplitude' 'Interpolated sEMG'}, '-');                       
%         ylim([-1 1]);     
%         subplot_helper(1:length(cutoff_mpu), cutoff_mpu, ...
%                         [2 1 2], {'sample' 'amplitude' 'Interpolated Angle'}, '-');                                       
%         ylim([-1 1]);
    end

end