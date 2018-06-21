% RMS-ICA
clear; close all;

set(0,'DefaultFigureVisible','on');
% set(0,'DefaultFigureVisible','off');

addpath('../../matlab_lib');
addpath('../../matlab_lib/FastICA_21');

%% Setting
file_loc_prepend = '../data/raw_';
file_extension = '.txt';

filename_prepend = 'S2WA_10_';
tdsep_file_list = {'FLX_1', 'EXT_1', 'PRO_1', 'SUP_1'};


% Signal Setting
target_sample_rate = 10;
RMS_window_size = 10;    % RMS window in pts

semg_sample_rate = 460; % Approximate
semg_max_value = 2048;
semg_min_value = -2048;
mpu_max_value = 90;
mpu_min_value = -90;

semg_channel_count = 4;
mpu_channel_count = 2;

semg_channel = 1:4;
mpu_channel = 5:6;  % 3: Roll(SUP/SUP) / 4: Pitch(Flx/Ext)

tdsep_file_label_list = tdsep_file_list;

%% File

tdsep_filename_list = cell(1, length(tdsep_file_label_list));
for i = 1 : length(tdsep_file_label_list)
    tdsep_filename_list{i} = ...
        [file_loc_prepend, filename_prepend, ...
            tdsep_file_label_list{i}, file_extension];
    
end


%% PCA is processed on the concated semg
concat_semg = [];
for i = 1 : length(tdsep_filename_list)
    raw_data = csvread(tdsep_filename_list{i});
    semg = raw_data(:, semg_channel);

    % Remove front and end to avoid noise
    semg = semg(10:end - 10, :);
    semg = semg - mean(semg);
  
    concat_semg = [concat_semg semg'];    
end

concat_semg = concat_semg - ones(size(concat_semg)) .* mean(concat_semg, 2);
RMS_concat_semg = RMS_calc(concat_semg', RMS_window_size)';

fsolve_max_step = 2000;
fsolve_tolerance = 1e-18;
global_tolerance_torque = 1e-8;
global_max_step = 200;
step_per_log = 100;

[nICA_semg, whitened_semg] = nICA(RMS_concat_semg, fsolve_max_step, fsolve_tolerance, global_tolerance_torque, global_max_step, step_per_log);
[ICA_semg, mixing_matrix, seperating_matrix] = fastica(RMS_concat_semg, ...
    'verbose', 'off', 'displayMode', 'off');  

if max(ICA_semg(1, :)) ~= max(abs(ICA_semg(1, :)))
    ICA_semg(1, :) = -ICA_semg(1, :);
end
if max(ICA_semg(2, :)) ~= max(abs(ICA_semg(2, :)))
    ICA_semg(2, :) = -ICA_semg(2, :);
end
if max(ICA_semg(3, :)) ~= max(abs(ICA_semg(3, :)))
    ICA_semg(3, :) = -ICA_semg(3, :);
end
if max(ICA_semg(4, :)) ~= max(abs(ICA_semg(4, :)))
    ICA_semg(4, :) = -ICA_semg(4, :);
end
    
figure;
subplot_helper(1:length(concat_semg), concat_semg(1, :), ...
                [4 1 1], {'sample' 'amplitude' 'Before ICA'}, '-');
subplot_helper(1:length(concat_semg), concat_semg(2, :), ...    
                [4 1 2], {'sample' 'amplitude' 'Before ICA'}, '-'); 
subplot_helper(1:length(concat_semg), concat_semg(3, :), ...
                [4 1 3], {'sample' 'amplitude' 'Before ICA'}, '-'); 
subplot_helper(1:length(concat_semg), concat_semg(4, :), ...    
                [4 1 4], {'sample' 'amplitude' 'Before ICA'}, '-'); 

figure;
subplot_helper(1:length(ICA_semg), ICA_semg(1, :), ...
                [4 1 1], {'sample' 'amplitude' 'After ICA'}, '-');  
subplot_helper(1:length(ICA_semg), ICA_semg(2, :), ...    
                [4 1 2], {'sample' 'amplitude' 'After ICA'}, '-');        
subplot_helper(1:length(ICA_semg), ICA_semg(3, :), ...
                [4 1 3], {'sample' 'amplitude' 'After ICA'}, '-');      
subplot_helper(1:length(ICA_semg), ICA_semg(4, :), ...    
                [4 1 4], {'sample' 'amplitude' 'After ICA'}, '-');
%%
return;
nICA_semg = nICA_semg./ max(nICA_semg, [], 2);
ICA_semg = ICA_semg./ max(ICA_semg, [], 2);

figure;
subplot_helper(1:length(nICA_semg), nICA_semg(1, :), ...
                [4 1 1], {'sample' 'amplitude' 'nICA vs ICA'}, '-');  
subplot_helper(1:length(ICA_semg), ICA_semg(2, :), ...
                [4 1 1], {'sample' 'amplitude' 'nICA vs ICA'}, '-');              
            
subplot_helper(1:length(nICA_semg), nICA_semg(2, :), ...    
                [4 1 2], {'sample' 'amplitude' 'nICA vs ICA'}, '-'); 
subplot_helper(1:length(ICA_semg), ICA_semg(1, :), ...
                [4 1 2], {'sample' 'amplitude' 'nICA vs ICA'}, '-');   
            
subplot_helper(1:length(nICA_semg), nICA_semg(3, :), ...
                [4 1 3], {'sample' 'amplitude' 'nICA vs ICA'}, '-');  
subplot_helper(1:length(ICA_semg), ICA_semg(4, :), ...
                [4 1 3], {'sample' 'amplitude' 'nICA vs ICA'}, '-');   
            
subplot_helper(1:length(nICA_semg), nICA_semg(4, :), ...    
                [4 1 4], {'sample' 'amplitude' 'nICA vs ICA'}, '-');
subplot_helper(1:length(ICA_semg), ICA_semg(3, :), ...
                [4 1 4], {'sample' 'amplitude' 'nICA vs ICA'}, '-');   
