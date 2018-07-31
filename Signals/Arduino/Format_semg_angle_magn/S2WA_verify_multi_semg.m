clear; close all;

addpath('../matlab_lib');


semg_channel_count = 4;
mpu_channel_count = 1;

graph_count = semg_channel_count + mpu_channel_count;

semg_channel_index = 1:4;
mpu_channel_index = 1;

mpu_min_value = -90;
mpu_max_value = 90;


./rnn S2WA_21_FLX_1_FLX_2_DOWNRMS_DS100_RMS500_FULL S2WA_21_FLX_3_DOWNRMS_DS100_RMS500_FULL S2WA_21_FLX_1_FLX_2_DOWNRMS_DS100_RMS500_FULL 16 1000 100 10 100000 4



file_name = 

% test_file_location = '../../../../RNN/LSTM/data/output/';
% test_file_name = strcat('res_', file_name, '.txt');
% 
% train_file_location = '../../../../RNN/LSTM/data/input/';
% train_file_name = strcat('exp_', file_name, '.txt');

[num_matrix, test_input_matrix_list, test_output_matrix_list] = ...
    read_test_file(strcat(test_file_location, test_file_name));

[num_matrix, train_input_matrix_list, train_output_matrix_list] = ...
    read_test_file(strcat(train_file_location, train_file_name));

%%
RMS_list = zeros(num_matrix, length(mpu_channel_index));
guess_RMS_list = zeros(num_matrix, length(mpu_channel_index));
for i = 1 : num_matrix
    test_semg_data = test_input_matrix_list{i}(:, semg_channel_index);
    test_mpu_data = test_output_matrix_list{i}(:, mpu_channel_index);       

    DATA_LENGTH = length(test_output_matrix_list{i});
    
    train_semg_data = train_input_matrix_list{i}(:, semg_channel_index);
    train_mpu_data = train_output_matrix_list{i}(:, mpu_channel_index);
    
    figure;
    
    for ch = 1 : semg_channel_count
        subplot_helper(1:DATA_LENGTH, test_semg_data(:, ch), ...
                        [graph_count 1 ch], {'sample' 'amplitude' 'sEMG'}, ':x');
        ylim([-1 1]);
    end
    
    test_mpu_data = test_mpu_data .* mpu_max_value;
    train_mpu_data = train_mpu_data .* mpu_max_value;
                
    for ch = 1 : mpu_channel_count
	subplot_helper(1:length(train_mpu_data), train_mpu_data(:, ch), ...
                    [graph_count 1 ch+semg_channel_count], ...
                    {'sample' 'amplitude' 'angle'}, ...
                    '-');         
    ylim([mpu_min_value mpu_max_value]);
	subplot_helper(1:length(test_mpu_data), test_mpu_data(:, ch), ...
                    [graph_count 1 ch+semg_channel_count], ...
                    {'sample' 'amplitude' 'angle'}, ...
                    '-');
    ylim([mpu_min_value mpu_max_value]);
    legend('real', 'predict');
    end 
    
    
% 	print(strcat('./pics/', test_file_name, num2str(i), '.png'),'-dpng')
   RMS_list(i, :) = sqrt(mean((train_mpu_data - test_mpu_data).^2));
   guess_RMS_list(i, :) = sqrt(mean((train_mpu_data - 0*ones(size(train_mpu_data))).^2));
end
fprintf('RMSE: ');
fprintf("%f ", RMS_list);
fprintf('\n');
fprintf("guess mean RMS = %f\n", guess_RMS_list);