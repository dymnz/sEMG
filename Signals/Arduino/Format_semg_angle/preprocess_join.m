clear; close all;

addpath('../matlab_lib');

filename_list = { ...
    './data/raw_S2WA_TABLE_EXT_1.txt', ...
    './data/raw_S2WA_TABLE_EXT_2.txt', ...
    './data/raw_S2WA_TABLE_EXT_3.txt', ...
    './data/raw_S2WA_TABLE_EXT_4.txt', ...
    './data/raw_S2WA_TABLE_FLX_1.txt', ...
    './data/raw_S2WA_TABLE_FLX_2.txt', ...
    './data/raw_S2WA_TABLE_FLX_3.txt', ...
    './data/raw_S2WA_TABLE_FLX_4.txt' 
    };


angle_threshold_list = [ ...
    -15, -15, -15, -15, ...
    15, 15, 15, 15 ...    
    ];



output_filename = ...
    strcat('../../../../Ethereun/RNN/LSTM/data/input/', ...
    'exp_S2WA_TABLE_EXT_1234_FLX_1234_DS10_RMS100_SEG.txt');

target_sample_rate = 10;
RMS_window_size = 100;    % RMS window in pts

semg_sample_rate = 540; % Approximate
semg_max_value = 2048;
semg_min_value = -2048;
mpu_max_value = 90;
mpu_min_value = -90;


mpu_segment_index = 2; % 1: Roll / 2: Pitch

semg_channel_count = 2;
mpu_channel_count = 2;

semg_channel = 1:2;
mpu_channel = 3:4;  % 3: Roll(Pro/Sup) / 4: Pitch(Flx/Ext)


num_of_file = length(filename_list);


%% Process

join_segment_list = cell(num_of_file, 1);
join_num_of_segment_list = zeros(num_of_file, 1);
for i = 1 : num_of_file
    
    % Degree divided +- 90d normalization
    mpu_threshold = angle_threshold_list(i) / mpu_max_value; 
    
    % Input/Output/Length  % num_of_segments
    [join_segment_list{i}, num_of_segment] = ...
        semg_mpu_segment_process(filename_list{i}, target_sample_rate, RMS_window_size, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, mpu_threshold, mpu_segment_index, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel);
    
    join_num_of_segment_list(i) = num_of_segment;
    fprintf('File %d has %d segments\n', i, num_of_segment);
end

join_num_of_segment = sum(join_num_of_segment_list);

%% Output

output_fileID = fopen(output_filename, 'w');

fprintf('# of sample: %d\n', join_num_of_segment);
fprintf(output_fileID, '%d\n', join_num_of_segment);

for i = 1 : num_of_file
    for r = 1 : join_num_of_segment_list(i)
        
        input = join_segment_list{i}{r, 1};
        output = join_segment_list{i}{r, 2};
        
        % Input
        fprintf(output_fileID, '%d %d\n', ...
                join_segment_list{i}{r, 3}, ...
                semg_channel_count);
        fprintf(output_fileID, '%f\t', input);
        fprintf(output_fileID, '\n');
        
        % Output: Force + Angle
        fprintf(output_fileID, '%d %d\n', ...
                join_segment_list{i}{r, 3}, ...
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
end   

fclose(output_fileID);