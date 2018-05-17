clear; close all;

addpath('../matlab_lib');

filename_list =  {'MPU_VS_POT_1'};
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

file_loc_prepend = './data/';
file_extension = '.txt';
filename_prepend = '';
file = [file_loc_prepend, filename_prepend, ...
            filename, file_extension];
        
raw_data = csvread(file);
semg = raw_data(:, semg_channel);
mpu = raw_data(:, mpu_channel);

semg = semg(10:end - 10, :);
semg = semg - mean(semg);

graph_count = mpu_channel_count + 1;
%%

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


	subplot_helper(1:length(mpu), mpu(:, 1), ...
                    [graph_count 1 1], ...
                    {'' 'Angle' 'Pot'}, ...
                    '-');                    
    ylim([mpu_min_value mpu_max_value]);
	subplot_helper(1:length(mpu), mpu(:, 2), ...
                    [graph_count 1 2], ...
                    {'' 'Angle' 'IMU'}, ...
                    '-');       
    ylim([mpu_min_value mpu_max_value]);            
	subplot_helper(1:length(mpu), mpu(:, 1) - mean(mpu(:, 1)), ...
                    [graph_count 1 graph_count], ...
                    {'' 'Angle' 'Pot/IMU'}, ...
                    '-');    
    hold on;
 	subplot_helper(1:length(mpu), mpu(:, 2) - mean(mpu(:, 2)), ...
                    [graph_count 1 graph_count], ...
                    {'' 'Angle' 'Pot/IMU'}, ...
                    '-');     

end;