clear; close all;

file_name = './data/test_2semg_12345.txt';
semg_channel = 1:2;
semg_channel_count = 2;
force_channel = 3;

semg_max_value = 2048;
semg_min_value = -2048;
force_max_value = 5;
semg_sample_rate = 5100; % Approximate
target_sample_rate = 100;

test_output_filename = './data/output/exp_ard_DS100_FORCE_SEG_full_noREC.txt';

raw_data = csvread(file_name);
range = 1:length(raw_data);
force = raw_data(range, force_channel);
semg = raw_data(range, semg_channel);

% Remove mean
semg = semg - mean(semg);

%% Original

fprintf('original signal time: %.2f\n', length(semg)/semg_sample_rate);

figure;
subplot_helper(1:length(force), force, ...
                [2 1 1], {'sample' 'kg' 'Raw Force'}, '-o');
subplot_helper(1:length(semg), semg, ...
                [2 1 2], {'sample' 'au' 'Raw sEMG'}, '-o');            
%% Force data interpolation
force(force<1e-3) = 0;

start_point = 1;

i = 1;
while i + 1 < length(force)
   i = i + 1; 
   if force(i) > 0
    end_point = i;
    xq = start_point : 1 : end_point;
    force(start_point:end_point) = ...
        interp1([start_point end_point], ...
            [force(start_point) force(end_point)], xq);            
   start_point = i;
   end
end

end_point = length(force);
xq = start_point : 1 : end_point;
force(start_point:end_point) = ...
    interp1([start_point end_point], ...
        [force(start_point) force(end_point)], xq);            


figure;
subplot_helper(1:length(force), force, ...
                [2 1 1], {'sample' 'amplitude' 'Interpolated force'}, '-o');         
subplot_helper(1:length(semg), semg, ...
                [2 1 2], {'sample' 'amplitude' 'Raw sEMG'}, '-');

%% Downsample
downsample_ratio = floor(semg_sample_rate / target_sample_rate);

filter_order = 6;
[force, cb, ca] = butter_filter( ...
        force, filter_order, target_sample_rate, semg_sample_rate);
[semg, cb, ca] = butter_filter( ...
        semg, filter_order, target_sample_rate, semg_sample_rate);

force = downsample(force, downsample_ratio);
semg = downsample(semg, downsample_ratio);

figure;
subplot_helper(1:length(force), force, ...
                [2 1 1], {'sample' 'amplitude' 'Downsample force'}, '-o');         
subplot_helper(1:length(semg), semg, ...
                [2 1 2], {'sample' 'amplitude' 'Downsample sEMG'}, '-x');
            
%% Restrain SEMG range
semg(semg > semg_max_value) = semg_max_value;
semg(semg < semg_min_value) = semg_min_value;


%% Remove faulty data
usable_data_range = 1 : min(length(semg), length(force));
force = force(usable_data_range);
semg = semg(usable_data_range, :);

figure;
subplot_helper(1:length(force), force, ...
                [1 1 1], {'sample' 'amplitude' 'Truncated force'}, '-o');         
subplot_helper(1:length(semg), semg, ...
                [1 1 1], {'sample' 'amplitude' 'Truncated sEMG'}, '-');

%% Rectify and Normalization
force = force / force_max_value;

semg = semg - mean(semg);
% semg = abs(semg);
% semg = semg ./ max(semg);
semg =  2.*(semg - semg_min_value)...
        ./ (semg_max_value - semg_min_value) - 1;

figure;
subplot_helper(1:length(force), force, ...
                [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         
subplot_helper(1:length(semg), semg, ...
                [1 1 1], {'sample' 'amplitude' 'Normalized force and sEMG'}, '-');
ylim([-1 1]);


%% Write test file
output_fileID = fopen(test_output_filename, 'w');

fprintf(output_fileID, '%d\n', 1);
fprintf(output_fileID, '%d %d\n', length(semg), semg_channel_count);
fprintf(output_fileID, '%f\t', semg');
fprintf(output_fileID, '\n');
fprintf(output_fileID, '%d %d\n', length(force), 1);
fprintf(output_fileID, '%f\t', force');
fprintf(output_fileID, '\n'); 
fclose(output_fileID);