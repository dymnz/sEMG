% Wavelet ICA before Downsample

clear; close all;

set(0,'DefaultFigureVisible','on');
% set(0,'DefaultFigureVisible','off');

addpath('../matlab_lib');
addpath('../matlab_lib/FastICA_21');

%% Setting

% Wavelet setting
wname = 'db4';
wlevel = 4;

tdsep_tau = [0:1];

ica_file_list = {'FLX_1', 'EXT_1', 'PRO_1', 'SUP_1'};
ica_range_list = {[1:2820], [1:2500], [1:1400], [1:2000]};

file_loc_prepend = './data/raw_';
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

ica_file_label_list = ica_file_list;


%% File

ica_filename_list = cell(1, length(ica_file_label_list));
for i = 1 : length(ica_file_label_list)
    ica_filename_list{i} = ...
        [file_loc_prepend, filename_prepend, ...
            ica_file_label_list{i}, file_extension];
    
end


%% PCA is processed on the concated semg
concat_semg = [];
for i = 1 : length(ica_filename_list)
    raw_data = csvread(ica_filename_list{i});
    semg = raw_data(:, semg_channel);

    % Remove front and end to avoid noise
    
    semg = semg(ica_range_list{i}, :);
    
    semg = semg(10:end, :);
    semg = semg - mean(semg);
  
    concat_semg = [concat_semg semg'];    
end

concat_semg = concat_semg - ones(size(concat_semg)) .* mean(concat_semg, 2);
variance = (sqrt(var(concat_semg'))') .* ones(semg_channel_count, length(concat_semg));
concat_semg = concat_semg ./ variance;


wavelet_concat_semg = zeros(semg_channel_count, 1);
for ch = 1 : semg_channel_count
    [cA,cD] = dwt(concat_semg(ch, :), wname);        
    for w = 1 : wlevel - 1
        [cA,cD] = dwt(cA, wname);                
    end
    
    cA = idwt(cA, zeros(size(cA)), wname);    
    for w = 1 : wlevel - 1
        cA = idwt(cA, zeros(size(cA)), wname);    
    end
    
    wavelet_concat_semg(ch, 1 : length(cA)) = cA';
end

% concat_semg =  2.*(concat_semg - min(concat_semg, [], 2))...
%         ./ (max(concat_semg, [], 2) - min(concat_semg, [], 2));  
% concat_semg = concat_semg - mean(concat_semg, 2);
% 
% figure;
% subplot_helper(1:length(concat_semg), concat_semg(1, :), ...
%                 [4 1 1], {'sample' 'amplitude' 'Before TDSEP'}, '-');                                                                  
% subplot_helper(1:length(concat_semg), concat_semg(2, :), ...    
%                 [4 1 2], {'sample' 'amplitude' 'Before TDSEP'}, '-'); 
% subplot_helper(1:length(concat_semg), concat_semg(3, :), ...
%                 [4 1 3], {'sample' 'amplitude' 'Before TDSEP'}, '-');                                                                  
% subplot_helper(1:length(concat_semg), concat_semg(4, :), ...    
%                 [4 1 4], {'sample' 'amplitude' 'Before TDSEP'}, '-'); 

% wavelet_concat_semg =  2.*(wavelet_concat_semg - min(wavelet_concat_semg, [], 2))...
%         ./ (max(wavelet_concat_semg, [], 2) - min(wavelet_concat_semg, [], 2));  
% wavelet_concat_semg = wavelet_concat_semg - mean(wavelet_concat_semg, 2);

% figure
% subplot_helper(1:length(wavelet_concat_semg), wavelet_concat_semg(1, :), ...
%                 [4 1 1], {'sample' 'amplitude' 'Before TDSEP'}, '-');                                                                  
% subplot_helper(1:length(wavelet_concat_semg), wavelet_concat_semg(2, :), ...    
%                 [4 1 2], {'sample' 'amplitude' 'Before TDSEP'}, '-'); 
% subplot_helper(1:length(wavelet_concat_semg), wavelet_concat_semg(3, :), ...
%                 [4 1 3], {'sample' 'amplitude' 'Before TDSEP'}, '-');                                                                  
% subplot_helper(1:length(wavelet_concat_semg), wavelet_concat_semg(4, :), ...    
%                 [4 1 4], {'sample' 'amplitude' 'Before TDSEP'}, '-'); 
         
rms_wavelet_concat_semg = RMS_calc(wavelet_concat_semg', RMS_window_size)';


rms_wavelet_concat_semg =  rms_wavelet_concat_semg...
        ./ (max(rms_wavelet_concat_semg, [], 2) - min(rms_wavelet_concat_semg, [], 2));  
figure;
subplot_helper(1:length(rms_wavelet_concat_semg), rms_wavelet_concat_semg(1, :), ...
                [4 1 1], {'sample' 'amplitude' 'Before ICA'}, '-');                                                                  
subplot_helper(1:length(rms_wavelet_concat_semg), rms_wavelet_concat_semg(2, :), ...    
                [4 1 2], {'sample' 'amplitude' 'Before ICA'}, '-'); 
subplot_helper(1:length(rms_wavelet_concat_semg), rms_wavelet_concat_semg(3, :), ...
                [4 1 3], {'sample' 'amplitude' 'Before ICA'}, '-');                                                                  
subplot_helper(1:length(rms_wavelet_concat_semg), rms_wavelet_concat_semg(4, :), ...    
                [4 1 4], {'sample' 'amplitude' 'Before ICA'}, '-');             
            
%             
% C = tdsep2(wavelet_concat_semg, tdsep_tau);
% tdsep_concat_semg = C \ wavelet_concat_semg; 
            
% C = tdsep2(wavelet_concat_semg, tdsep_tau);
[ica_concat_semg, mixing_matrix, seperating_matrix] = fastica(wavelet_concat_semg, ...
    'verbose', 'off', 'displayMode', 'off');   


% figure;
% subplot_helper(1:length(tdsep_concat_semg), tdsep_concat_semg(1, :), ...
%                 [4 1 1], {'sample' 'amplitude' 'After TDSEP'}, '-');                                                                  
% subplot_helper(1:length(tdsep_concat_semg), tdsep_concat_semg(2, :), ...    
%                 [4 1 2], {'sample' 'amplitude' 'After TDSEP'}, '-'); 
% subplot_helper(1:length(tdsep_concat_semg), tdsep_concat_semg(3, :), ...
%                 [4 1 3], {'sample' 'amplitude' 'After TDSEP'}, '-');                                                                  
% subplot_helper(1:length(tdsep_concat_semg), tdsep_concat_semg(4, :), ...    
%                 [4 1 4], {'sample' 'amplitude' 'After TDSEP'}, '-'); 


rms_tdsep_concat_semg = RMS_calc(ica_concat_semg', RMS_window_size)';
rms_tdsep_concat_semgrms_tdsep_concat_semg =  rms_wavelet_concat_semg...
        ./ (max(rms_tdsep_concat_semg, [], 2) - min(rms_tdsep_concat_semg, [], 2)); 
figure;
subplot_helper(1:length(rms_tdsep_concat_semg), rms_tdsep_concat_semg(1, :), ...
                [4 1 1], {'sample' 'amplitude' 'After ICA'}, '-');                                                                  
subplot_helper(1:length(rms_tdsep_concat_semg), rms_tdsep_concat_semg(2, :), ...    
                [4 1 2], {'sample' 'amplitude' 'After ICA'}, '-'); 
subplot_helper(1:length(rms_tdsep_concat_semg), rms_tdsep_concat_semg(3, :), ...
                [4 1 3], {'sample' 'amplitude' 'After ICA'}, '-');                                                                  
subplot_helper(1:length(rms_tdsep_concat_semg), rms_tdsep_concat_semg(4, :), ...    
                [4 1 4], {'sample' 'amplitude' 'After ICA'}, '-');              
           
            
C = tdsep2(ica_concat_semg, tdsep_tau);
tdsep_ica_concat_semg = C \ ica_concat_semg; 

rms_tdsep_ica_concat_semg = RMS_calc(tdsep_ica_concat_semg', RMS_window_size)';
rms_tdsep_ica_concat_semg =  rms_tdsep_ica_concat_semg...
        ./ (max(rms_tdsep_ica_concat_semg, [], 2) - min(rms_tdsep_ica_concat_semg, [], 2)); 
figure;
subplot_helper(1:length(rms_tdsep_ica_concat_semg), rms_tdsep_ica_concat_semg(1, :), ...
                [4 1 1], {'sample' 'amplitude' 'After TDSEP-ICA'}, '-');                                                                  
subplot_helper(1:length(rms_tdsep_ica_concat_semg), rms_tdsep_ica_concat_semg(2, :), ...    
                [4 1 2], {'sample' 'amplitude' 'After TDSEP-ICA'}, '-'); 
subplot_helper(1:length(rms_tdsep_ica_concat_semg), rms_tdsep_ica_concat_semg(3, :), ...
                [4 1 3], {'sample' 'amplitude' 'After TDSEP-ICA'}, '-');                                                                  
subplot_helper(1:length(rms_tdsep_ica_concat_semg), rms_tdsep_ica_concat_semg(4, :), ...    
                [4 1 4], {'sample' 'amplitude' 'After TDSEP-ICA'}, '-');  

similarity_list = zeros(semg_channel_count);
for i = 1 : semg_channel_count
    for r = 1 : semg_channel_count
         coef = corrcoef(wavelet_concat_semg(i, :), tdsep_ica_concat_semg(r, :));
         similarity_list(i, r) = coef(1, 2);
    end
end
similarity_list


