clear; close all;
addpath('../matlab_lib');


filename_list =  {'FLX_1', 'FLX_2', 'FLX_3'};
% Signal Setting
target_sample_rate = 10;
RMS_window_size = 100;    % RMS window in pts

semg_sample_rate = 2660; % Approximate
semg_max_value = 2048 / 4;
semg_min_value = -2048 / 4;
mpu_max_value = 120;
mpu_min_value = -120;

semg_channel_count = 4;
mpu_channel_count = 3;

semg_channel = 1:4;
mpu_channel = 5:7;  % 3: Roll(SUP/SUP) / 4: Pitch(Flx/Ext)

for f = 1 : numel(filename_list)
filename = filename_list{f};

file_loc_prepend = './data/raw_';
file_extension = '.txt';
filename_prepend = 'S2WA_22_';
file = [file_loc_prepend, filename_prepend, ...
            filename, file_extension];
        
raw_data = csvread(file);
semg = raw_data(:, semg_channel);
mpu = raw_data(:, mpu_channel);

semg = semg(10:end - 10, :);
semg = semg - mean(semg);

graph_count = semg_channel_count + mpu_channel_count;
%%
for i = 1 : 1

    figure('Name', filename);
    
    for ch = 1 : semg_channel_count
    subplot_helper(1:length(semg), semg(:, ch), ...
                    [graph_count 1 ch], {'' '' ''}, ':x');
    ylim([semg_min_value semg_max_value]);
    end
    
    for ch = 1 : mpu_channel_count
	subplot_helper(1:length(mpu), mpu(:, ch), ...
                    [graph_count 1 ch+semg_channel_count], ...
                    {'' '' ''}, ...
                    '-');                                                         
    ylim([mpu_min_value mpu_max_value]);
    end 
    
end


end;