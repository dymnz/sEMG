% nICA splice

clear; close all;

set(0,'DefaultFigureVisible','on');
% set(0,'DefaultFigureVisible','off');

addpath('../../matlab_lib');
addpath('../../matlab_lib/nICA');

%% Setting

tdsep_file_list = {'FLX_1', 'EXT_1', 'PRO_1', 'SUP_1'};
tdsep_range_list = {[1:2820], [1:2500], [1:1400], [1:2000]};


file_loc_prepend = '../data/raw_';
file_extension = '.txt';

filename_prepend = 'S2WA_10_';


% RNN
hidden_node_count_list = {'12'};
epoch = '1000';
rand_seed = '4';
cross_valid_patience_list = {'100'};

% Signal Setting
target_sample_rate = 10;
RMS_window_size = 100;    % RMS window in pts

semg_sample_rate = 2660; % Approximate
semg_max_value = 2048;
semg_min_value = -2048;
mpu_max_value = 90;
mpu_min_value = -90;

semg_channel_count = 4;
mpu_channel_count = 3;

semg_channel = 1:4;
mpu_channel = 5:7; 

%% For different hidden node count...
rnn_result_plaintext = [];

cross_valid_patience = cross_valid_patience_list{1};
hidden_node_count = hidden_node_count_list{1};

%% Filename Prepend

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
    semg = semg(tdsep_range_list{i}, :);
    semg = semg(10:end, :);
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

nICA_semg = nICA(RMS_concat_semg, fsolve_max_step, fsolve_tolerance, global_tolerance_torque, global_max_step, step_per_log);


norm_RMS_concat_semg =  2.*(RMS_concat_semg - min(RMS_concat_semg, [], 2))...
        ./ (max(RMS_concat_semg, [], 2) - min(RMS_concat_semg, [], 2));  

figure;
subplot_helper(1:length(RMS_concat_semg), norm_RMS_concat_semg(1, :), ...
                [4 1 1], {'sample' 'amplitude' 'Before nICA'}, '-');
subplot_helper(1:length(RMS_concat_semg), norm_RMS_concat_semg(2, :), ...    
                [4 1 2], {'sample' 'amplitude' 'Before nICA'}, '-'); 
subplot_helper(1:length(RMS_concat_semg), norm_RMS_concat_semg(3, :), ...
                [4 1 3], {'sample' 'amplitude' 'Before nICA'}, '-'); 
subplot_helper(1:length(RMS_concat_semg), norm_RMS_concat_semg(4, :), ...    
                [4 1 4], {'sample' 'amplitude' 'Before nICA'}, '-'); 
             
norm_nICA_semg =  2.*(nICA_semg - min(nICA_semg, [], 2))...
        ./ (max(nICA_semg, [], 2) - min(nICA_semg, [], 2));  

figure;
subplot_helper(1:length(nICA_semg), norm_nICA_semg(1, :), ...
                [4 1 1], {'sample' 'amplitude' 'After nICA'}, '-');  
subplot_helper(1:length(nICA_semg), norm_nICA_semg(2, :), ...    
                [4 1 2], {'sample' 'amplitude' 'After nICA'}, '-');        
subplot_helper(1:length(nICA_semg), norm_nICA_semg(3, :), ...
                [4 1 3], {'sample' 'amplitude' 'After nICA'}, '-');      
subplot_helper(1:length(nICA_semg), norm_nICA_semg(4, :), ...    
                [4 1 4], {'sample' 'amplitude' 'After nICA'}, '-');


