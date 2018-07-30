% Interpolate angle data and output data splice

clear; close all;

set(0,'DefaultFigureVisible','on');
% set(0,'DefaultFigureVisible','off');

addpath('../matlab_lib');
addpath('../matlab_lib/FastICA_21');

% Setting
file_loc_prepend = './data/raw_';
file_extension = '.txt';

filename_prepend = 'S2WA_21_';
file_to_splice = { 
    'FLX_1', 'FLX_2', 'FLX_3'
};

semg_channel_count = 4;
mpu_channel_count = 3;

semg_channel = 1:4;
mpu_channel = 5:7;  % Roll/Pitch/Yaw

mpu_threshold = -10; 
mpu_segment_index = 2; % 1-Roll/2-Pitch/3-Yaw

% Signal Setting
target_sample_rate = 10;
RMS_window_size = 100;    % RMS window in pts

semg_sample_rate = 2660; % Approximate
semg_max_value = 2048;
semg_min_value = -2048;
mpu_max_value = 90;
mpu_min_value = -90;

graph_count = semg_channel_count + mpu_channel_count;


% Construct filename list
file_label_list = file_to_splice;
filename_list = cell(1, length(file_label_list));
for i = 1 : length(file_label_list)
    filename_list{i} = ...
        [file_loc_prepend, filename_prepend, ...
            file_label_list{i}, file_extension];
end


%%

for i = 1 : length(file_label_list)
    
    filename = filename_list{i};
    raw_data = csvread(filename);
    semg = raw_data(:, semg_channel);
    mpu = raw_data(:, mpu_channel);
    
    semg = semg(10:end-10, :);
    

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
    
    
    % Display
    figure('Name', filename);
    
    for ch = 1 : semg_channel_count
    subplot_helper(1:length(semg), semg(:, ch), ...
                    [graph_count 1 ch], {'' '' ''}, ':x');
    end
    
    for ch = 1 : mpu_channel_count
	subplot_helper(1:length(mpu), mpu(:, ch), ...
                    [graph_count 1 ch+semg_channel_count], ...
                    {'' '' ''}, ...
                    '-');                                                         
    ylim([mpu_min_value mpu_max_value]);
    
    end
    
    
    % Angle segmentation
    % Divide the data from the middle of each angle action
    % Force action: Angle >= angle_threshold

    mpu_segments = zeros(size(mpu, 1), 1);

    if mpu_threshold < 0
        mpu_segments(mpu(:, mpu_segment_index) < mpu_threshold) = 1;
    else 
        mpu_segments(mpu(:, mpu_segment_index) > mpu_threshold) = 1;
    end
    
    figure;
    subplot_helper(1:length(mpu), mpu(:, mpu_segment_index), ...
                    [1 1 1], {'sample' 'amplitude' 'Normalized angle'}, 'o');         
    subplot_helper(1:length(mpu_segments), mpu_threshold .* mpu_segments, ...
                    [1 1 1], {'sample' 'amplitude' 'Normalized sEMG'}, '-');                       
%     subplot_helper(1:length(mpu_segments),mpu_threshold * ones(size(mpu_segments)), ...
%                     [1 1 1], {'sample' 'amplitude' 'Normalized sEMG'}, '-');                                   
%     ylim([-1 1]);
 
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

end