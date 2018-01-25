clear; close all;

force_filename = './data/loadcell_2.txt';
force_fileID = fopen(force_filename);
force = textscan(force_fileID, '%f');
fclose(force_fileID);
force = force{1};
force_sample_rate = 12;

semg_filename = './data/semg_2.lvm';
semg = lvmread(semg_filename);
semg_sample_rate = 1000;


train_output_filename = './data/output/exp_2_first_half_chunk500_overlap50.txt';
test_output_filename = './data/output/exp_2_first_half_stream_rect_DS500.txt';

% Remove mean
semg = semg(:, 2) - mean(semg(:, 2));

%% Original

% figure;
% subplot_helper(1:length(force_data), force_data, ...
%                 [2 1 1], {'sample' 'kg' 'Force'}, '-o');
% subplot_helper(1:length(semg_data), semg_data, ...
%                 [2 1 2], {'sample' 'au' 'sEMG'}, '-o');

%% Force data truncation
force_data_front_truncate_samples = 113;
force_data_back_truncate_samples = 1402;

trauncated_range = force_data_front_truncate_samples : ...
        force_data_back_truncate_samples;
force = force(trauncated_range);

semg_data_front_truncate_samples = 10724;
semg_data_back_truncate_samples = length(semg);
trauncated_range = semg_data_front_truncate_samples : ...
        semg_data_back_truncate_samples;
semg = semg(trauncated_range);

% figure;
% subplot_helper(1:length(force), force, ...
%                 [2 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');        
% subplot_helper(1:length(semg), semg, ...
%                 [2 1 2], {'sample' 'amplitude' 'twitch force proto'}, '-o');
%             
 
%% Force data interpolation
xq = 1 : length(force) / length(semg) : length(force);
force = interp1(1:length(force), force , xq);

% figure;
% subplot_helper(1:length(force), force, ...
%                 [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         
% subplot_helper(1:length(semg), semg, ...
%                 [1 1 1], {'sample' 'amplitude' 'Interpolated force and sEMG'}, '-');


%% Normalization
force = force / max(force);
semg = 2 * (semg - min(semg))...
        / (max(semg) - min(semg)) - 1;

% figure;
% subplot_helper(1:length(semg), semg, ...
%                 [1 1 1], {'sample' 'amplitude' 'Normalized force and sEMG'}, '-');
% subplot_helper(1:length(force), force, ...
%                 [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         


%% Remove faulty data
usable_data_range = 1 : 61400; %min(length(semg), length(force));
force = force(usable_data_range);
semg = semg(usable_data_range);

figure;
subplot_helper(1:length(force), force, ...
                [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         
subplot_helper(1:length(semg), semg, ...
                [1 1 1], {'sample' 'amplitude' 'Truncated force and sEMG'}, '-');


%% Downsample
target_sample_rate = 500;
downsample_ratio = floor(semg_sample_rate / target_sample_rate);

filter_order = 6;
[force, cb, ca] = butter_filter( ...
        force, filter_order, target_sample_rate, semg_sample_rate);

force = downsample(force, downsample_ratio);
semg = downsample(semg, downsample_ratio);


figure;
subplot_helper(1:length(force), force, ...
                [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         
subplot_helper(1:length(semg), semg, ...
                [1 1 1], {'sample' 'amplitude' 'Downsample force and sEMG'}, '-');
ylim([0 1]);

%% Rectify and Normalization
force = force / max(force);

semg = semg - mean(semg);
semg = abs(semg);
semg = semg / max(semg);

figure;
subplot_helper(1:length(force), force, ...
                [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         
subplot_helper(1:length(semg), semg, ...
                [1 1 1], {'sample' 'amplitude' 'Normalized force and sEMG'}, '-');
ylim([-1 1]);

%% Write train file
% DATA_LENGTH = 500;
% OVERLAP_LENGTH = 50;
% num_of_sample = floor(length(force) / (DATA_LENGTH - OVERLAP_LENGTH));
% 
% output_fileID = fopen(train_output_filename, 'w');
% fprintf(output_fileID, '%d\n', num_of_sample);
% 
% 
% for i = 1 : num_of_sample
% 
% cutoff_range = ...
%     (i-1)*(DATA_LENGTH - OVERLAP_LENGTH) + 1 : ...
%     (i-1)*(DATA_LENGTH - OVERLAP_LENGTH) + DATA_LENGTH;
% if (i-1)*(DATA_LENGTH - OVERLAP_LENGTH) + DATA_LENGTH > length(force)
% cutoff_range = ...
%     (i-1)*(DATA_LENGTH - OVERLAP_LENGTH) + 1 : ...
%     length(force);
% end
% 
% if length(cutoff_range) <= 1
%     break
% end
% 
% cutoff_force = force(cutoff_range);
% cutoff_semg = semg(cutoff_range);
% fprintf(output_fileID, '%d %d\n', length(cutoff_semg), 1);
% fprintf(output_fileID, '%f\t', cutoff_semg);
% fprintf(output_fileID, '\n');
% fprintf(output_fileID, '%d %d\n', length(cutoff_semg), 1);
% fprintf(output_fileID, '%f\t', cutoff_force);
% fprintf(output_fileID, '\n');
% 
% % figure;
% % subplot_helper(1:length(cutoff_force), cutoff_force, ...
% %                 [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');                    
% % subplot_helper(1:length(cutoff_semg), cutoff_semg, ...
% %                 [1 1 1], {'sample' 'amplitude' 'Interpolated force and sEMG'}, '-');                       
% % ylim([-1 1]);            
% end
% fclose(output_fileID);


%% Write test file
output_fileID = fopen(test_output_filename, 'w');

DATA_LENGTH = length(semg);

fprintf(output_fileID, '1\n');
fprintf(output_fileID, '%d %d\n', DATA_LENGTH, 1);
fprintf(output_fileID, '%f\t', semg);
fprintf(output_fileID, '\n');
fprintf(output_fileID, '%d %d\n', DATA_LENGTH, 1);
fprintf(output_fileID, '%f\t', force);
fprintf(output_fileID, '\n');
fclose(output_fileID);