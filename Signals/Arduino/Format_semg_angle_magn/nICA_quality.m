%% Check correlation of nICA processed signal

clear; close all;
addpath('../matlab_lib');
addpath('../matlab_lib/nICA');

set(0,'DefaultFigureVisible','on');     

%% Setting
% File
all_test_list = {...
    {'FLX', 'EXT'}, {'PRO', 'SUP'}, ...
    {'FLX', 'EXT'}, {'PRO', 'SUP'}, ...
    {'FLX', 'EXT'}, {'PRO', 'SUP'}, ...
    {'FLX', 'EXT'}, {'PRO', 'SUP'}, ...
    {'FLX', 'EXT'}, {'PRO', 'SUP'}, ...
    {'FLX', 'EXT'}, {'PRO', 'SUP'}, ...
    {'FLX', 'EXT'}, {'PRO', 'SUP'}, ...
    {'FLX', 'EXT'}, {'PRO', 'SUP'}, ...
    {'FLX', 'EXT'}, {'PRO', 'SUP'}, ...  
    {'FLX', 'EXT'}, {'PRO', 'SUP'}
    };

for ica_file_idx = 1 : 4
    
ica_filename = 'ICA_processed';

in_file_loc_prepend = './data/S2WA_22_';
in_file_extension = '.mat';
out_file_loc_prepend = '../../../../RNN/LSTM/data/input/exp_';
out_file_prepend_list = {'TR_', 'CV_', 'TS_'};
out_file_extension = '.txt';
 
record_filename = ['S2WA_22_nICA_' num2str(ica_file_idx) '_SPS30_10rd_data'];

% RNN param
hidden_node_count = '8';
epoch = '1000';
rand_seed = {'5', '5', '6', '6', '7', '7', '8', '8', '9', '9', '10', '10', ...
             '11', '11', '12', '12', '13', '13', '14', '14'};
cross_valid_patience = '20';

% nICA param
fsolve_max_step = 2000;
fsolve_tolerance = 1e-18;
global_tolerance_torque = 1e-8;
global_max_step = 200;
step_per_log = 100;

% Signal param
semg_sample_rate = 2660; % Approximate
semg_max_value = -100;
semg_min_value = -semg_max_value;
mpu_max_value = 130;
mpu_min_value = -mpu_max_value;

% Downsample/RMS param
RMS_window_size = 500;    % RMS window in pts
target_sample_rate = 30;
downsample_filter_order = 6;
downsample_ratio = floor(semg_sample_rate / target_sample_rate);

% Data format
semg_channel_count = 4;
mpu_channel_count = 1;

% Cross-validation param
partition_ratio = [3 1 1]; % Train/CV/Test
total_partition = sum(partition_ratio);

num_of_gesture = 2;
num_of_iteration_per_gesture = 3;
num_of_segment_per_iteration = 20; % e.g. num of segment in 'FLX_1'
                                    % Anything more is removed
num_of_segment_per_gesture = ...
    num_of_iteration_per_gesture * num_of_segment_per_iteration;

train_size = partition_ratio(1) / total_partition ...
                    * num_of_segment_per_gesture;               
cv_size = partition_ratio(2) / total_partition ...
                    * num_of_segment_per_gesture;
test_size = partition_ratio(3) / total_partition ...
                    * num_of_segment_per_gesture;     
                
                

% Calculate nICA demixing matrix
ica_file = [in_file_loc_prepend ica_filename in_file_extension];
load(ica_file);
semg = processed_segments_list{ica_file_idx, 1}{1};

% RMS
rms_semg = RMS_calc(semg, RMS_window_size);

% nICA - W: demix V: whitten
[ica_semg, whittened, W, V] = ...
    nICA(rms_semg, fsolve_max_step, ...
         fsolve_tolerance, global_tolerance_torque, ...
         global_max_step, step_per_log);

%% Show nICA effect     
figure;
subplot_helper(1:length(rms_semg), rms_semg(1, :), ...
                [4 1 1], {'sample' 'amplitude' ...
                ['Before nICA-' num2str(ica_file_idx)]}, '-');             
subplot_helper(1:length(rms_semg), rms_semg(2, :), ...    
                [4 1 2], {'sample' 'amplitude' ...
                ['Before nICA-' num2str(ica_file_idx)]}, '-');        
subplot_helper(1:length(rms_semg), rms_semg(3, :), ...
                [4 1 3], {'sample' 'amplitude' ...
                ['Before nICA-' num2str(ica_file_idx)]}, '-');            
subplot_helper(1:length(rms_semg), rms_semg(4, :), ...    
                [4 1 4], {'sample' 'amplitude' ...
                ['Before nICA-' num2str(ica_file_idx)]}, '-');      
figure
subplot_helper(1:length(ica_semg), ica_semg(1, :), ...
                [4 1 1], {'sample' 'amplitude' ...
                ['After nICA-' num2str(ica_file_idx)]}, '-');         
subplot_helper(1:length(ica_semg), ica_semg(2, :), ...    
                [4 1 2], {'sample' 'amplitude' ...
                ['After nICA-' num2str(ica_file_idx)]}, '-'); 
subplot_helper(1:length(ica_semg), ica_semg(3, :), ...
                [4 1 3], {'sample' 'amplitude' ...
                ['After nICA-' num2str(ica_file_idx)]}, '-');   
subplot_helper(1:length(ica_semg), ica_semg(4, :), ...    
                [4 1 4], {'sample' 'amplitude' ...
                ['After nICA-' num2str(ica_file_idx)]}, '-'); 
     
%% Verify nICA
% ica_m_semg = (W * V * rms_semg); 
% figure;
% subplot_helper(1:length(ica_semg), ica_semg(1, :), ...
%                 [4 1 1], {'sample' 'amplitude' 'After nICA'}, '-');             
% subplot_helper(1:length(ica_semg), ica_semg(2, :), ...    
%                 [4 1 2], {'sample' 'amplitude' 'After nICA'}, '-');           
% subplot_helper(1:length(ica_semg), ica_semg(3, :), ...
%                 [4 1 3], {'sample' 'amplitude' 'After nICA'}, '-');              
% subplot_helper(1:length(ica_semg), ica_semg(4, :), ...    
%                 [4 1 4], {'sample' 'amplitude' 'After nICA'}, '-');                
% subplot_helper(1:length(ica_m_semg), ica_m_semg(1, :), ...
%                 [4 1 1], {'sample' 'amplitude' 'After nICA'}, '-');             
% subplot_helper(1:length(ica_m_semg), ica_m_semg(2, :), ...    
%                 [4 1 2], {'sample' 'amplitude' 'After nICA'}, '-');            
% subplot_helper(1:length(ica_m_semg), ica_m_semg(3, :), ...
%                 [4 1 3], {'sample' 'amplitude' 'After nICA'}, '-');               
% subplot_helper(1:length(ica_m_semg), ica_m_semg(4, :), ...    
%                 [4 1 4], {'sample' 'amplitude' 'After nICA'}, '-');            


end