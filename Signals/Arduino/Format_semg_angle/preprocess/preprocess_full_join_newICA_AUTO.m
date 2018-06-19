clear; close all;

set(0,'DefaultFigureVisible','off');

addpath('../../matlab_lib');
addpath('../../matlab_lib/FastICA_21');


file_to_test = {
%     {{'SUP_1'}, 'SUP_1'}; 
%     {{'SUP_2'}, 'SUP_2'}; 
%     {{'SUP_3'}, 'SUP_3'}; 
%     {{'SUP_4'}, 'SUP_4'}; 
%     {{'SUP_5'}, 'SUP_5'}; 
%     {{'PRO_1'}, 'PRO_1'}; 
%     {{'PRO_2'}, 'PRO_2'}; 
%     {{'PRO_3'}, 'PRO_3'}; 
%     {{'PRO_4'}, 'PRO_4'}; 
%     {{'PRO_5'}, 'PRO_5'};
%     {{'SUP_1', 'SUP_2'}, 'SUP_3'} ; 
%     {{'SUP_1', 'SUP_2', 'SUP_3'}, 'SUP_4'} ;    
%     {{'SUP_1', 'SUP_2', 'SUP_3'}, 'SUP_5'} ;
%     {{'SUP_1', 'SUP_2', 'SUP_3', 'SUP_4'}, 'SUP_5'} ;
%     {{'PRO_1', 'PRO_2'}, 'PRO_3'} ;
%     {{'PRO_1', 'PRO_2', 'PRO_3'}, 'PRO_4'} ;
%     {{'PRO_1', 'PRO_2', 'PRO_3'}, 'PRO_5'} ;
%     {{'PRO_1', 'PRO_2', 'PRO_3', 'PRO_4'}, 'PRO_5'} ;    
%     {{'SUP_1', 'SUP_2', 'SUP_3', 'SUP_4', 'PRO_1', ...
%         'PRO_2', 'PRO_3', 'PRO_4'}, 'SUP_5'} ;    
%     {{'SUP_1', 'SUP_2', 'SUP_3', 'SUP_4', 'PRO_1', ...
%         'PRO_2', 'PRO_3', 'PRO_4'}, 'PRO_5'} ;
%     {{'SUP_1', 'SUP_2', 'SUP_3', 'SUP_4', 'PRO_1', ...
%         'PRO_2', 'PRO_3', 'PRO_4'}, 'PROSUP_1'} ;        
%     {{'SUP_1', 'SUP_2', 'SUP_3', 'SUP_4', 'SUP_5', 'PRO_1', ...
%         'PRO_2', 'PRO_3', 'PRO_4', 'PRO_5'}, 'PROSUP_1'} ;
%     {{'SUP_1', 'SUP_2', 'SUP_3', 'SUP_4', 'PRO_1', ...
%         'PRO_2', 'PRO_3', 'PRO_4'}, 'PROSUP_2'} ;
%     {{'SUP_1', 'SUP_2', 'SUP_3', 'SUP_4', 'SUP_5', 'PRO_1', ...
%         'PRO_2', 'PRO_3', 'PRO_4', 'PRO_5'}, 'PROSUP_2'} ;
%     {{'SUP_1', 'SUP_2', 'SUP_3', 'SUP_4', 'PRO_1', ...
%         'PRO_2', 'PRO_3', 'PRO_4', 'PROSUP_2'}, 'PROSUP_1'} ;
    {{'SUP_1', 'SUP_2', 'SUP_3', 'SUP_4', 'SUP_5', 'PRO_1', ...
        'PRO_2', 'PRO_3', 'PRO_4', 'PRO_5', 'PROSUP_1'}, 'PROSUP_2'} ;        
    };


rnn_result_plaintext = [];
for f = 1 : numel(file_to_test) % For different files...

%% Filename Prepend
file_loc_prepend = '../data/raw_';
filename_prepend = 'S2WA_7_';
file_extension = '.txt';

ica_file_label_list = file_to_test{f}{1};
train_file_label_list = file_to_test{f}{1};
test_file_label = file_to_test{f}{2};


%% Signal Setting
target_sample_rate = 10;
RMS_window_size = 100;    % RMS window in pts

%% RNN
hidden_node_count = '16';
epoch_list = {'1000' '2000' '4000' '8000'};
rand_seed = '4';

%% For different epoch...

for e = 1 : length(epoch_list)
    
epoch = epoch_list{e};

%% File

% Gather training filename
train_filename_list = cell(1, length(train_file_label_list));
for i = 1 : length(train_file_label_list)
    train_filename_list{i} = ...
        [file_loc_prepend, filename_prepend, ...
            train_file_label_list{i}, file_extension];
    
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
    '_newICA', ...
    '_DS', num2str(target_sample_rate), ...
    '_RMS', num2str(RMS_window_size), '_FULL'];
train_output_file = ...
   [ '../../../../../RNN/LSTM/data/input/exp_', ...
            train_output_filename, file_extension];

mpu_shift_val = [50 0]; % Roll/Pitch The bias of mpu in degree

test_filename = [ ...
    file_loc_prepend, filename_prepend, test_file_label, file_extension];
test_output_filename = [ ...
    filename_prepend, ...
    test_file_label, ...
    '_newICA', ...
    '_DS', num2str(target_sample_rate), ...
    '_RMS', num2str(RMS_window_size), '_FULL'];
test_output_file = [ ...
    '../../../../../RNN/LSTM/data/input/exp_', ...
        test_output_filename, file_extension];              

semg_sample_rate = 540; % Approximate
semg_max_value = 2048;
semg_min_value = -2048;
mpu_max_value = 90;
mpu_min_value = -90;

semg_channel_count = 2;
mpu_channel_count = 2;

semg_channel = 1:2;
mpu_channel = 3:4;  % 3: Roll(SUP/SUP) / 4: Pitch(Flx/Ext)


num_of_file = length(train_filename_list);


%% ICA is processed on the concated semg
concat_semg = [];
for i = 1 : length(ica_filename_list)
    raw_data = csvread(ica_filename_list{i});
    semg = raw_data(:, semg_channel);
     
    % Remove unstable value
    semg = semg(10:end - 10, :);
  
    concat_semg = [concat_semg semg'];    
end

concat_semg = concat_semg - mean(concat_semg, 2) * ones(1, length(concat_semg));
concat_semg = concat_semg ./ semg_max_value;

concat_semg = RMS_calc(concat_semg', RMS_window_size)';

downsample_ratio = floor(semg_sample_rate / target_sample_rate);
filter_order = 6;
[concat_semg, cb, ca] = butter_filter( ...
        concat_semg', filter_order, target_sample_rate, semg_sample_rate);   
concat_semg = downsample(concat_semg, downsample_ratio)';

variance = (sqrt(var(concat_semg'))') .* ones(semg_channel_count, length(concat_semg));
concat_semg = concat_semg ./ variance;

figure;
subplot_helper(1:length(concat_semg), concat_semg(1, :), ...
                [3 1 1], {'sample' 'amplitude' 'Before ICA'}, '-');                       
subplot_helper(1:length(concat_semg), concat_semg(2, :), ...
                [3 1 2], {'sample' 'amplitude' 'Before ICA'}, '-');
   
[icasig, mixing_matrix, seperating_matrix] = fastica(concat_semg, ...
    'verbose', 'off', 'displayMode', 'off');
 

figure;
subplot_helper(1:length(concat_semg), concat_semg(1, :), ...
                [2 1 1], {'sample' 'amplitude' 'Before ICA'}, '-');                                                          
subplot_helper(1:length(concat_semg), abs(icasig(1, :)), ...
                [2 1 1], {'sample' 'amplitude' 'Before ICA'}, '-');              
subplot_helper(1:length(icasig), concat_semg(2, :), ...    
                [2 1 2], {'sample' 'amplitude' 'After ICA'}, '-');  
subplot_helper(1:length(icasig), abs(icasig(2, :)), ...    
                [2 1 2], {'sample' 'amplitude' 'After ICA'}, '-');             
% Find the max_min range of sEMG channel using mixing matrix
max_min_matrix = ...
    [ 1  -1 ;
      1  -1 ];
var_matrix = ...
    [ variance(1) variance(1);
      variance(2) variance(2)]; 

max_min_matrix = (seperating_matrix  * max_min_matrix) ./ var_matrix;

% max(max(icasig)) - min(min(icasig))
% max(max(max_min_matrix)) - min(min(max_min_matrix))

semg_max_value = max(max(max_min_matrix)) - min(min(max_min_matrix));
semg_min_value = -semg_max_value;

%% process

join_segment_list = cell(num_of_file, 1);
for i = 1 : num_of_file
    
    % Input/Output/Length  % num_of_segments
    join_segment_list{i} = ...
        semg_mpu_full_process_newICA(train_filename_list{i}, target_sample_rate, RMS_window_size, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, mpu_shift_val, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel, seperating_matrix);        
    %fprintf('Processed File %d\n', i);
end


%% Output segment

output_fileID = fopen(train_output_file, 'w');

%fprintf('# of sample: %d\n', num_of_file);
fprintf(output_fileID, '%d\n', num_of_file);

for i = 1 : num_of_file
    input = join_segment_list{i}{1};
    output = join_segment_list{i}{2};

    % Input
    fprintf(output_fileID, '%d %d\n', ...
            join_segment_list{i}{3}, ...
            semg_channel_count);
    fprintf(output_fileID, '%f\t', input);
    fprintf(output_fileID, '\n');

    % Output: Force + Angle
    fprintf(output_fileID, '%d %d\n', ...
            join_segment_list{i}{3}, ...
            mpu_channel_count);
    fprintf(output_fileID, '%f\t', output);
    fprintf(output_fileID, '\n'); 

%         figure;
%         subplot_helper(1:length(input), input, ...
%                         [2 1 1], {'sample' 'amplitude' 'Interpolated sEMG'}, '-');                       
%         ylim([-1 1]);     
%         subplot_helper(1:length(output), output, ...
%                         [2 1 2], {'sample' 'amplitude' 'Interpolated Angle'}, '-');                                       
%         ylim([-1 1]); 
end   

fclose(output_fileID);

%% Output full

% Input/Output/Length  % num_of_segments
full_sig = ...    
    semg_mpu_full_process_newICA(test_filename, target_sample_rate, RMS_window_size, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, mpu_shift_val, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel, seperating_matrix);


output_fileID = fopen(test_output_file, 'w');

input = full_sig{1};
output = full_sig{2};
        
fprintf(output_fileID, '%d\n', 1);
% Input: sEMG
fprintf(output_fileID, '%d %d\n', ...
        full_sig{3}, ...
        semg_channel_count);
fprintf(output_fileID, '%f\t', input);
fprintf(output_fileID, '\n');

% Output: Force + Angle
fprintf(output_fileID, '%d %d\n', ...
        full_sig{3}, ...
        mpu_channel_count);
fprintf(output_fileID, '%f\t', output);
fprintf(output_fileID, '\n'); 

fclose(output_fileID);


%% Run

fprintf(['./rnn ', train_output_filename, ' ', ...
    test_output_filename, ...
    ' ', hidden_node_count, ' ', epoch, ' 10 100000 ', rand_seed, '\n']);

origin_dir = pwd;
cd('../../../../RNN/LSTM/');
[status,cmdout] = system(['./rnn ', train_output_filename, ' ', ...
    test_output_filename, ...
    ' ', hidden_node_count, ' ', epoch, ' 10 100000 ', rand_seed, '\n']);
cd(origin_dir);



close all;
% Show test file result
verify_multi_semg(test_output_filename);

rnn_result = regexp(cmdout, '[\f\n\r]', 'split');
rnn_result = rnn_result(end-3:end-1);

rnn_result_plaintext = [rnn_result_plaintext rnn_result{1} newline rnn_result{2} newline rnn_result{3} newline];
end
rnn_result_plaintext = [rnn_result_plaintext newline];
end


clipboard('copy', rnn_result_plaintext);
fprintf(rnn_result_plaintext);

set(0,'DefaultFigureVisible','on');
msgbox('Ding!');
beep2()
