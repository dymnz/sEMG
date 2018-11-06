function RMS_list = verify_multi_semg(file_name)

addpath('../matlab_lib');

semg_channel_count = 4;
mpu_channel_count = 1;

graph_count = 1 + mpu_channel_count;

semg_channel_index = 1:4;
mpu_channel_index = 1;

mpu_max_value = 140;
mpu_min_value = -mpu_max_value;


test_file_location = '../../../../RNN/LSTM/data/output/';
test_file_name = strcat('res_', file_name, '.txt');

train_file_location = '../../../../RNN/LSTM/data/input/';
train_file_name = strcat('exp_', file_name, '.txt');


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
    
   % train_semg_data = train_input_matrix_list{i}(:, semg_channel_index);
    train_mpu_data = train_output_matrix_list{i}(:, mpu_channel_index);
  
    test_mpu_data = test_mpu_data .* mpu_max_value;
    train_mpu_data = train_mpu_data .* mpu_max_value;
    
    numer = sum((test_mpu_data - train_mpu_data).^2);
    denom = sum((train_mpu_data - mean(train_mpu_data)).^2);
    temp_RMSE = 1 - (numer / denom);
%     figure('Name', file_name);
%     subplot_helper(1:DATA_LENGTH, test_semg_data, ...
%                     [graph_count 1 1], {'sample' 'amplitude' sprintf('segment: %3d RMSE: %.2f', i, temp_RMSE)}, ':x');
%     ylim([0 1]);
%     set(gca,'fontsize', 30);            
%     for ch = 1 : mpu_channel_count
% 	subplot_helper(1:length(train_mpu_data), train_mpu_data(:, ch), ...
%                     [graph_count 1 ch+1], ...
%                     {'sample' 'amplitude (au)' 'angle'}, ...
%                     '-');                                                         
%     ylim([mpu_min_value mpu_max_value]);
% 	subplot_helper(1:length(test_mpu_data), test_mpu_data(:, ch), ...
%                     [graph_count 1 ch+1], ...
%                     {'sample' 'angle (degree)' 'angle'}, ...
%                     '-');
%     ylim([mpu_min_value mpu_max_value]);
%     legend('real', 'predict');
%     set(gca,'fontsize', 30); 
%     end 
    
    
% 	print(strcat('./pics/', test_file_name, num2str(i), '.png'),'-dpng')
   RMS_list(i, :) = temp_RMSE;
end
% fprintf('RMSE:\n');
% fprintf("%f \n", RMS_list);
% fprintf('\n');
% fprintf("guess mean RMS = %f\n", guess_RMS_list);