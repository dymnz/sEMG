% Interpolate angle data and output data splice
% Output consists of all semg channel and 
% 'mpu_segment_index' mpu channel

clear; close all;

set(0,'DefaultFigureVisible','on');

addpath('../matlab_lib');
addpath('../matlab_lib/FastICA_21');

% Setting
file_loc_prepend = './data/';
file_extension = '.txt';

semg_channel_count = 6;
mpu_channel_count = 2;

semg_channel = 1:semg_channel_count;
mpu_channel = semg_channel_count+1:semg_channel_count+mpu_channel_count;  % Roll/Pitch/Yaw

record_filename = './data/S2WA_YAO_611_ICA_processed';

filename_prepend = 'raw_S2WA_YAO_611_';
file_to_splice = { 
    'ICA_1', 'ICA_2', 'ICA_3', 'ICA_4'
};

mpu_segment_threshold = 20; % Degree
mpu_segment_index = 1; % 1-Roll/2-Pitch/3-Yaw


semg_max_value = 2048 / 2;
semg_min_value = -semg_max_value;
mpu_max_value = 140;
mpu_min_value = -mpu_max_value;

graph_count = semg_channel_count + mpu_channel_count;


% Construct filename list
file_label_list = file_to_splice;
filename_list = cell(1, length(file_label_list));
for i = 1 : length(file_label_list)
    filename_list{i} = ...
        [file_loc_prepend, filename_prepend, ...
            file_label_list{i}, file_extension];
end

processed_segments_list = {};

%% Process
for f = 1 : length(file_label_list)
    input_filename = filename_list{f};
    
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
  
    
    % Display
    figure('Name', input_filename);
    for ch = 1 : semg_channel_count
    subplot_helper(1:length(semg), semg(:, ch), ...
                    [graph_count 1 ch], {'' '' ''}, ':x');
    end
    ylim([semg_min_value semg_max_value]);
    
    for ch = 1 : mpu_channel_count
	subplot_helper(1:length(mpu), mpu(:, ch), ...
                    [graph_count 1 ch+semg_channel_count], ...
                    {'' '' ''}, ...
                    '-');                                                         
    ylim([mpu_min_value mpu_max_value]);
    
    end
    
    processed_segments = {semg' mpu' length(semg)};
    processed_segments_list = [processed_segments_list; {processed_segments  file_to_splice{f}}]; 
end

save(record_filename, 'processed_segments_list');

set(0,'DefaultFigureVisible','on');