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
% variance = (sqrt(var(concat_semg'))') .* ones(semg_channel_count, length(concat_semg));
% concat_semg = concat_semg ./ variance;

concat_semg = RMS_calc(concat_semg', RMS_window_size)';

[ica_semg, mixing_matrix, seperating_matrix] = fastica(concat_semg, ...
    'verbose', 'off', 'displayMode', 'off');  

norm_concat_semg =  2.*(concat_semg - min(concat_semg, [], 2))...
        ./ (max(concat_semg, [], 2) - min(concat_semg, [], 2));  
norm_concat_semg = norm_concat_semg - mean(norm_concat_semg, 2);


figure;
subplot_helper(1:length(concat_semg), norm_concat_semg(1, :), ...
                [4 1 1], {'sample' 'amplitude' 'Before ICA'}, '-');
subplot_helper(1:length(concat_semg), norm_concat_semg(2, :), ...    
                [4 1 2], {'sample' 'amplitude' 'Before ICA'}, '-'); 
subplot_helper(1:length(concat_semg), norm_concat_semg(3, :), ...
                [4 1 3], {'sample' 'amplitude' 'Before ICA'}, '-'); 
subplot_helper(1:length(concat_semg), norm_concat_semg(4, :), ...    
                [4 1 4], {'sample' 'amplitude' 'Before ICA'}, '-'); 

            
norm_tdsep_semg =  2.*(ica_semg - min(ica_semg, [], 2))...
        ./ (max(ica_semg, [], 2) - min(ica_semg, [], 2));  
norm_tdsep_semg = norm_tdsep_semg - mean(norm_tdsep_semg, 2); 

% norm_tdsep_semg = abs(norm_tdsep_semg);  

figure;
subplot_helper(1:length(ica_semg), norm_tdsep_semg(1, :), ...
                [4 1 1], {'sample' 'amplitude' 'After ICA'}, '-');  
subplot_helper(1:length(ica_semg), norm_tdsep_semg(2, :), ...    
                [4 1 2], {'sample' 'amplitude' 'After ICA'}, '-');        
subplot_helper(1:length(ica_semg), norm_tdsep_semg(3, :), ...
                [4 1 3], {'sample' 'amplitude' 'After ICA'}, '-');      
subplot_helper(1:length(ica_semg), norm_tdsep_semg(4, :), ...    
                [4 1 4], {'sample' 'amplitude' 'After ICA'}, '-');

figure;
scatter(norm_concat_semg(2, :), norm_concat_semg(4, :));
figure;
scatter(norm_tdsep_semg(2, :), norm_tdsep_semg(4, :));

