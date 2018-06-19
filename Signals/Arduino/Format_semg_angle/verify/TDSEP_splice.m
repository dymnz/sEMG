% TDSEP

clear; close all;

set(0,'DefaultFigureVisible','on');
% set(0,'DefaultFigureVisible','off');

addpath('../../matlab_lib');
addpath('../matlab_lib/TDSEP');

%% Setting

% tdsep_file_list = {'FLX_1', 'EXT_1', 'PRO_1', 'SUP_1'};
tdsep_file_list = {'FLX_1'};
tdsep_range_list = {[1:2820], [1:2500], [1:1400], [1:2000]};
tdsep_tau = [0:6];


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

semg_sample_rate = 460; % Approximate
semg_max_value = 2048;
semg_min_value = -2048;
mpu_max_value = 90;
mpu_min_value = -90;

semg_channel_count = 4;
mpu_channel_count = 2;

semg_channel = 1:4;
mpu_channel = 5:6;  % 3: Roll(SUP/SUP) / 4: Pitch(Flx/Ext)

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
  
    concat_semg = [concat_semg semg'];    
end

concat_semg = concat_semg - ones(size(concat_semg)) .* mean(concat_semg, 2);
variance = (sqrt(var(concat_semg'))') .* ones(semg_channel_count, length(concat_semg));
concat_semg = concat_semg ./ variance;


C = tdsep2(concat_semg, tdsep_tau);
pca_semg = C \ concat_semg; 

figure;
subplot_helper(1:length(concat_semg), concat_semg(1, :)', ...
                [4 1 1], {'sample' 'amplitude' 'Before TDSEP'}, '-');                                                                  
subplot_helper(1:length(concat_semg), concat_semg(2, :)'', ...    
                [4 1 2], {'sample' 'amplitude' 'Before TDSEP'}, '-'); 
subplot_helper(1:length(concat_semg), concat_semg(3, :)', ...
                [4 1 3], {'sample' 'amplitude' 'Before TDSEP'}, '-');                                                                  
subplot_helper(1:length(concat_semg), concat_semg(4, :)'', ...    
                [4 1 4], {'sample' 'amplitude' 'Before TDSEP'}, '-'); 

figure;
subplot_helper(1:length(pca_semg), pca_semg(1, :)', ...
                [4 1 1], {'sample' 'amplitude' 'After TDSEP'}, '-');                                                                  
subplot_helper(1:length(pca_semg), pca_semg(2, :)'', ...    
                [4 1 2], {'sample' 'amplitude' 'After TDSEP'}, '-'); 
subplot_helper(1:length(pca_semg), pca_semg(3, :)', ...
                [4 1 3], {'sample' 'amplitude' 'After TDSEP'}, '-');                                                                  
subplot_helper(1:length(pca_semg), pca_semg(4, :)'', ...    
                [4 1 4], {'sample' 'amplitude' 'After TDSEP'}, '-'); 

similarity_list = zeros(semg_channel_count);
for i = 1 : semg_channel_count
    for r = 1 : semg_channel_count
         coef = corrcoef(pca_semg(i, :), pca_semg(r, :));
         similarity_list(i, r) = coef(1, 2);
    end
end
similarity_list
return;
%%

concat_semg = RMS_calc(concat_semg', RMS_window_size)';
pca_semg = RMS_calc(pca_semg', RMS_window_size)';

downsample_ratio = floor(semg_sample_rate / target_sample_rate);
filter_order = 6;
[concat_semg, cb, ca] = butter_filter( ...
        concat_semg', filter_order, target_sample_rate, semg_sample_rate);   
concat_semg = downsample(concat_semg, downsample_ratio)';
[pca_semg, cb, ca] = butter_filter( ...
        pca_semg', filter_order, target_sample_rate, semg_sample_rate);   
pca_semg = downsample(pca_semg, downsample_ratio)';



semg_max_value = max(max(pca_semg)) * 1.5;
semg_min_value = 0;

