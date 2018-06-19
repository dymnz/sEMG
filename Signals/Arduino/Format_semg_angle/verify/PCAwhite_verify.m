% PCAwhite before Downsample

clear; close all;

set(0,'DefaultFigureVisible','on');
% set(0,'DefaultFigureVisible','off');

addpath('../../matlab_lib');

%% Setting
file_loc_prepend = '../data/raw_';
file_extension = '.txt';

filename_prepend = 'S2WA_10_';
file_to_test = {'FLX_1', 'EXT_1', 'PRO_1', 'SUP_1'};

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

%% Filename Prepend

PCA_file_label_list = file_to_test;

%% File

PCA_filename_list = cell(1, length(PCA_file_label_list));
for i = 1 : length(PCA_file_label_list)
    PCA_filename_list{i} = ...
        [file_loc_prepend, filename_prepend, ...
            PCA_file_label_list{i}, file_extension];
    
end

%% PCA is processed on the concated semg
concat_semg = [];
for i = 1 : length(PCA_filename_list)
    raw_data = csvread(PCA_filename_list{i});
    semg = raw_data(:, semg_channel);

    % Remove front and end to avoid noise
    semg = semg(10:end - 10, :);
    semg = semg - mean(semg);
  
    concat_semg = [concat_semg semg'];    
end


[pca_semg, U] = PCAwhiten(concat_semg);
pca_coeff = U';

% pca_semg = pca_coeff' * concat_semg;
pca_semg = U(:,1:semg_channel_count-1)' * concat_semg; % reduced dimension representation of the data, 
                        % where k is the number of eigenvectors to keep
pca_semg = U * [pca_semg; zeros(1, size(pca_semg, 2))];

% figure;
% plot(concat_semg(2, :), concat_semg(4, :), 'x');
% 
% figure;
% plot(pca_semg(2, :), pca_semg(4, :), 'x');


figure;
subplot_helper(1:length(concat_semg), concat_semg(1, :), ...
                [4 1 1], {'sample' 'amplitude' 'Before PCA'}, '-');                                                                  
subplot_helper(1:length(concat_semg), concat_semg(2, :), ...    
                [4 1 2], {'sample' 'amplitude' 'Before PCA'}, '-'); 
subplot_helper(1:length(concat_semg), concat_semg(3, :), ...
                [4 1 3], {'sample' 'amplitude' 'Before PCA'}, '-');                                                                  
subplot_helper(1:length(concat_semg), concat_semg(4, :), ...    
                [4 1 4], {'sample' 'amplitude' 'Before PCA'}, '-'); 



figure;
subplot_helper(1:length(pca_semg), pca_semg(1, :), ...
                [4 1 1], {'sample' 'amplitude' 'After PCA'}, '-');                                                                  
subplot_helper(1:length(pca_semg), pca_semg(2, :), ...    
                [4 1 2], {'sample' 'amplitude' 'After PCA'}, '-'); 
subplot_helper(1:length(pca_semg), pca_semg(3, :), ...
                [4 1 3], {'sample' 'amplitude' 'After PCA'}, '-');                                                                  
subplot_helper(1:length(pca_semg), pca_semg(4, :), ...    
                [4 1 4], {'sample' 'amplitude' 'After PCA'}, '-'); 

similarity_list = zeros(semg_channel_count);
for i = 1 : semg_channel_count
    for r = 1 : semg_channel_count
         coef = corrcoef(pca_semg(i, :), pca_semg(r, :));
         similarity_list(i, r) = coef(1, 2);
    end
end

similarity_list


rms_concat_semg = RMS_calc(concat_semg', RMS_window_size)';

rms_concat_semg =  rms_concat_semg...
        ./ (max(rms_concat_semg, [], 2) - min(rms_concat_semg, [], 2));  
figure;
subplot_helper(1:length(rms_concat_semg), rms_concat_semg(1, :), ...
                [4 1 1], {'sample' 'amplitude' 'Before ICA'}, '-');                                                                  
subplot_helper(1:length(rms_concat_semg), rms_concat_semg(2, :), ...    
                [4 1 2], {'sample' 'amplitude' 'Before ICA'}, '-'); 
subplot_helper(1:length(rms_concat_semg), rms_concat_semg(3, :), ...
                [4 1 3], {'sample' 'amplitude' 'Before ICA'}, '-');                                                                  
subplot_helper(1:length(rms_concat_semg), rms_concat_semg(4, :), ...    
                [4 1 4], {'sample' 'amplitude' 'Before ICA'}, '-');             
   
rms_pca_semg = RMS_calc(pca_semg', RMS_window_size)';

rms_pca_semg =  rms_pca_semg...
        ./ (max(rms_pca_semg, [], 2) - min(rms_pca_semg, [], 2));  
figure;
subplot_helper(1:length(rms_pca_semg), rms_pca_semg(1, :), ...
                [4 1 1], {'sample' 'amplitude' 'Before ICA'}, '-');                                                                  
subplot_helper(1:length(rms_pca_semg), rms_pca_semg(2, :), ...    
                [4 1 2], {'sample' 'amplitude' 'Before ICA'}, '-'); 
subplot_helper(1:length(rms_pca_semg), rms_pca_semg(3, :), ...
                [4 1 3], {'sample' 'amplitude' 'Before ICA'}, '-');                                                                  
subplot_helper(1:length(rms_pca_semg), rms_pca_semg(4, :), ...    
                [4 1 4], {'sample' 'amplitude' 'Before ICA'}, '-');              
            