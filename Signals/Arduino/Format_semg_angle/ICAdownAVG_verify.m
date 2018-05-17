% ICA before Downsample

clear; close all;

set(0,'DefaultFigureVisible','on');
% set(0,'DefaultFigureVisible','off');

addpath('../matlab_lib');
addpath('../matlab_lib/FastICA_21');

%% Setting
file_loc_prepend = './data/raw_';
file_extension = '.txt';

filename_prepend = 'S2WA_10_';
file_to_test = { ...     
    % Complex MIX, Partial CV
   {{{'FLX_1', ...
       'EXT_1', ...
       'PRO_1', ...
       'SUP_1', ...
       }, ...
       {'FLXEXTPRO_1', 'FLXEXTSUP_1', 'FLXEXTPRO_2', 'FLXEXTSUP_2'}}, ...
       'FLXEXTPROSUP_1'};     
};

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

ica_file_label_list = file_to_test{1}{1}{1};
train_file_label_list = file_to_test{1}{1}{1};
cross_file_label_list = file_to_test{1}{1}{2};
test_file_label = file_to_test{1}{2};


%% File

% Gather training filename
train_filename_list = cell(1, length(train_file_label_list));
for i = 1 : length(train_file_label_list)
    train_filename_list{i} = ...
        [file_loc_prepend, filename_prepend, ...
            train_file_label_list{i}, file_extension];    
end

cross_filename_list = cell(1, length(cross_file_label_list));
for i = 1 : length(cross_file_label_list)
    cross_filename_list{i} = ...
        [file_loc_prepend, filename_prepend, ...
            cross_file_label_list{i}, file_extension];    
end

ica_filename_list = cell(1, length(ica_file_label_list));
for i = 1 : length(train_file_label_list)
    ica_filename_list{i} = ...
        [file_loc_prepend, filename_prepend, ...
            ica_file_label_list{i}, file_extension];
    
end


train_output_filename = [ ...
    filename_prepend, ...
    strjoin(train_file_label_list, '_'), ...
    '_ICAdown', ...
    '_DS', num2str(target_sample_rate), ...
    '_RMS', num2str(RMS_window_size), '_FULL'];

if length(train_output_filename) > 100
    truncated_train_file_label_list = train_file_label_list(1:5);
    
    train_output_filename = [ ...
    filename_prepend, ...
    strjoin(truncated_train_file_label_list, '_'), ...
    '_TRUNCAT', ...
    '_ICAdown', ...
    '_DS', num2str(target_sample_rate), ...
    '_RMS', num2str(RMS_window_size), '_FULL'];
end

train_output_file = ...
   [ '../../../../RNN/LSTM/data/input/exp_', ...
            train_output_filename, file_extension];

cross_output_filename = [ ...
    filename_prepend, ...
    strjoin(cross_file_label_list, '_'), ...
    '_ICAdown', ...
    '_DS', num2str(target_sample_rate), ...
    '_RMS', num2str(RMS_window_size), '_FULL'];
cross_output_file = ...
   [ '../../../../RNN/LSTM/data/input/exp_', ...
           cross_output_filename, file_extension];              
        
mpu_shift_val = [0 0]; % Roll/Pitch The bias of mpu in degree

test_filename = [ ...
    file_loc_prepend, filename_prepend, test_file_label, file_extension];
test_output_filename = [ ...
    filename_prepend, ...
    test_file_label, ...
    '_ICAdown', ...
    '_DS', num2str(target_sample_rate), ...
    '_RMS', num2str(RMS_window_size), '_FULL'];
test_output_file = [ ...
    '../../../../RNN/LSTM/data/input/exp_', ...
        test_output_filename, file_extension];              


num_of_train_file = length(train_filename_list);
num_of_cross_file = length(cross_filename_list);

%% ICA is processed on the concated semg
concat_semg = [];
for i = 1 : length(ica_filename_list)
    raw_data = csvread(ica_filename_list{i});
    semg = raw_data(:, semg_channel);

    % Remove front and end to avoid noise
    semg = semg(10:end - 10, :);
  
    concat_semg = [concat_semg semg'];    
end

concat_semg = concat_semg - ones(size(concat_semg)) .* mean(concat_semg, 2);

variance = (sqrt(var(concat_semg'))') * ones(1, length(concat_semg));
concat_semg = concat_semg ./ variance;

concat_semg = AVG_calc(concat_semg', RMS_window_size)';


figure;
subplot_helper(1:length(concat_semg), concat_semg(1, :)', ...
                [4 1 1], {'sample' 'amplitude' 'Before ICA'}, '-');                                                                  
subplot_helper(1:length(concat_semg), concat_semg(2, :)'', ...    
                [4 1 2], {'sample' 'amplitude' 'Before ICA'}, '-'); 
subplot_helper(1:length(concat_semg), concat_semg(3, :)', ...
                [4 1 3], {'sample' 'amplitude' 'Before ICA'}, '-');                                                                  
subplot_helper(1:length(concat_semg), concat_semg(4, :)'', ...    
                [4 1 4], {'sample' 'amplitude' 'Before ICA'}, '-'); 

[ica_semg, mixing_matrix, seperating_matrix] = fastica(concat_semg, ...
    'verbose', 'off', 'displayMode', 'off');   
ica_semg = AVG_calc(ica_semg', RMS_window_size)';

ica_semg = ica_semg - mean(ica_semg);

figure;
subplot_helper(1:length(ica_semg), ica_semg(1, :)', ...
                [4 1 1], {'sample' 'amplitude' 'After ICA'}, '-');                                                                  
subplot_helper(1:length(ica_semg), ica_semg(2, :)'', ...    
                [4 1 2], {'sample' 'amplitude' 'After ICA'}, '-'); 
subplot_helper(1:length(ica_semg), ica_semg(3, :)', ...
                [4 1 3], {'sample' 'amplitude' 'After ICA'}, '-');                                                                  
subplot_helper(1:length(ica_semg), ica_semg(4, :)'', ...    
                [4 1 4], {'sample' 'amplitude' 'After ICA'}, '-'); 

similarity_list = zeros(semg_channel_count);
for i = 1 : semg_channel_count
    for r = 1 : semg_channel_count
         coef = corrcoef(ica_semg(i, :), concat_semg(r, :));
         similarity_list(i, r) = coef(1, 2);
    end
end
return;
%%



downsample_ratio = floor(semg_sample_rate / target_sample_rate);
filter_order = 6;
[concat_semg, cb, ca] = butter_filter( ...
        concat_semg', filter_order, target_sample_rate, semg_sample_rate);   
concat_semg = downsample(concat_semg, downsample_ratio)';
[ica_semg, cb, ca] = butter_filter( ...
        ica_semg', filter_order, target_sample_rate, semg_sample_rate);   
ica_semg = downsample(ica_semg, downsample_ratio)';



semg_max_value = max(max(ica_semg)) * 1.5;
semg_min_value = 0;

