clear; close all;
addpath('../matlab_lib');

% filename_list = {
%     'PRO_1', 'PRO_2', 'PRO_3', 'PRO_4', 'PRO_5', ...
%     'SUP_1', 'SUP_2', 'SUP_3', 'SUP_4', 'SUP_5', ...
%     'FLX_1', 'FLX_2', 'FLX_3', 'FLX_4', 'FLX_5', ...
%     'EXT_1', 'EXT_2', 'EXT_3', 'EXT_4', 'EXT_5', ...
%     'PROSUP_1', 'PROSUP_2', 'PROSUP_3', ...
%     'FLXEXT_1', 'FLXEXT_2', 'FLXEXT_3', ...
%     'FLXEXTPROSUP_1', 'FLXEXTPROSUP_2', 'FLXEXTPROSUP_3', ...
%     'FLXEXTPRO_1', 'FLXEXTSUP_1', 'FLXEXTPRO_2', 'FLXEXTSUP_2'
% };
filename_list =  {'FLXEXTPROSUP_1'};
% Signal Setting
target_sample_rate = 10;
RMS_window_size = 100;    % RMS window in pts

semg_sample_rate = 460; % Approximate
semg_max_value = 2048;
semg_min_value = -2048;
mpu_max_value = 90;
mpu_min_value = -90;

semg_channel_count = 4;
mpu_channel_count = 2;

semg_channel = 1:4;
mpu_channel = 5:6;  % 3: Roll(SUP/SUP) / 4: Pitch(Flx/Ext)

for f = 1 : numel(filename_list)
filename = filename_list{f};

file_loc_prepend = './data/raw_';
file_extension = '.txt';
filename_prepend = 'S2WA_10_';
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
    close all;
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
%     pause;
    
end


end;