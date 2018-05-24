% clear; close all;
addpath('../matlab_lib');


filename_list =  {'PROSUP_3'};

% Wavelet setting
wname = 'bior1.1';
wlevel = 3;

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

graph_count = semg_channel_count %+ mpu_channel_count;
%%
for i = 1 : 1
    close all;
    figure('Name', filename);
    
    for ch = 1 : semg_channel_count
%         subplot_helper(1:length(semg), semg(:, ch), ...
%                     [graph_count 1 ch], {'' '' ''}, '-');
                
        [cA,cD] = dwt(semg(:, ch), wname);        
        for w = 1 : wlevel - 1
            [cA,cD] = dwt(cA, wname);                
        end
        
        cA = idwt(cA, zeros(size(cA)), wname);    
        for w = 1 : wlevel - 1
            cA = idwt(cA, zeros(size(cA)), wname);    
        end
        X = cA;
        
        subplot_helper(1:length(X), X, ...
                    [graph_count 1 ch], {'' '' ''}, '-');
    end
    
%     for ch = 1 : mpu_channel_count
%         subplot_helper(1:length(mpu), mpu(:, ch), ...
%                     [graph_count 1 ch+semg_channel_count], ...
%                     {'' '' ''}, ...
%                     '-');                                                         
%         ylim([mpu_min_value mpu_max_value]);
%     end 

    
end


end;