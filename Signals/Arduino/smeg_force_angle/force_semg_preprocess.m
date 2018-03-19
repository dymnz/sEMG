clear; close all;

file_name = './data/raw_semg_force_angle_2.txt';
test_output_filename = './data/output/exp_SFM_DS200_FULL_2.txt';

semg_channel_count = 2;
mpu_channel_count = 1;

semg_channel = 1:2;
force_channel = 3;
mpu_channel = 4;

semg_max_value = 2048;
semg_min_value = -2048;
force_max_value = 5;
mpu_max_value = 90;
mpu_min_value = -90;

semg_sample_rate = 500; % Approximate
target_sample_rate = 200;

raw_data = csvread(file_name);
semg = raw_data(:, semg_channel);
force = raw_data(:, force_channel);
mpu = raw_data(:, mpu_channel);

% Remove mean
semg = semg - mean(semg);

%% Original

fprintf('original signal time: %.2f\n', length(semg)/semg_sample_rate);

% figure;
% subplot_helper(1:length(force), force, ...
%                 [3 1 1], {'sample' 'kg' 'Force'}, '-o');
% subplot_helper(1:length(semg), semg, ...
%                 [3 1 2], {'sample' 'au' 'sEMG'}, '-o');
% subplot_helper(1:length(mpu), mpu, ...
%                 [3 1 3], {'sample' 'au' 'Angle'}, '-o');
% ylim([-90 90]);


%% Force / Angle data interpolation

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

    
%mpu(abs(mpu)<1e-3) = 0;
start_point = 1;
i = 1;
while i + 1 < length(mpu)
   i = i + 1; 
   if abs(mpu(i)) > 0
    end_point = i;
    xq = start_point : 1 : end_point;
    mpu(start_point:end_point) = ...
        interp1([start_point end_point], ...
            [mpu(start_point) mpu(end_point)], xq);            
   start_point = i;
   end
end
end_point = length(mpu);
xq = start_point : 1 : end_point;
mpu(start_point:end_point) = ...
    interp1([start_point end_point], ...
        [mpu(start_point) mpu(end_point)], xq);        
figure;
subplot_helper(1:length(force), force, ...
                [3 1 1], {'sample' 'amplitude' 'Interpolated force (kg)'}, '-');         
subplot_helper(1:length(semg), semg, ...
                [3 1 2], {'sample' 'amplitude' 'sEMG'}, '-');
subplot_helper(1:length(mpu), mpu, ...
                [3 1 3], {'sample' 'amplitude' 'Interpolated angle'}, '-');         
ylim([-90 90]);            

%% Downsample
downsample_ratio = floor(semg_sample_rate / target_sample_rate);

filter_order = 6;
[force, cb, ca] = butter_filter( ...
        force, filter_order, target_sample_rate, semg_sample_rate);
[semg, cb, ca] = butter_filter( ...
        semg, filter_order, target_sample_rate, semg_sample_rate);
[mpu, cb, ca] = butter_filter( ...
        mpu, filter_order, target_sample_rate, semg_sample_rate);    

force = downsample(force, downsample_ratio);
semg = downsample(semg, downsample_ratio);
mpu = downsample(mpu, downsample_ratio);
% 
% figure;
% subplot_helper(1:length(force), force, ...
%                 [3 1 1], {'sample' 'amplitude' 'Downsampled force (kg)'}, '-');         
% subplot_helper(1:length(semg), semg, ...
%                 [3 1 2], {'sample' 'amplitude' 'Downsampled sEMG'}, '-');
% subplot_helper(1:length(mpu), mpu, ...
%                 [3 1 3], {'sample' 'amplitude' 'Downsampled angle'}, '-');         
% ylim([-90 90]);     

%% Restrain SEMG range
semg(semg > semg_max_value) = semg_max_value;
semg(semg < semg_min_value) = semg_min_value;


%% Remove faulty data
usable_data_range = 1 : min(length(semg), length(force));
force = force(usable_data_range);
semg = semg(usable_data_range, :);
mpu = mpu(usable_data_range, :);

figure;
subplot_helper(1:length(force), force, ...
                [3 1 1], {'sample' 'amplitude' 'Truncated force (kg)'}, '-');         
subplot_helper(1:length(semg), semg, ...
                [3 1 2], {'sample' 'amplitude' 'Truncated sEMG'}, '-');
subplot_helper(1:length(mpu), mpu, ...
                [3 1 3], {'sample' 'amplitude' 'Truncated angle'}, '-');         
ylim([-90 90]); 

%% Rectify and Normalization
force = force / force_max_value;

semg = semg - mean(semg);
% semg = abs(semg);
semg =  2.*(semg - semg_min_value)...
        ./ (semg_max_value - semg_min_value) - 1;

mpu =  2.*(mpu - mpu_min_value)...
        ./ (mpu_max_value - mpu_min_value) - 1;    
    
    
figure;
subplot_helper(1:length(force), force, ...
                [3 1 1], {'sample' 'amplitude' 'Normalized force (kg)'}, '-');         
subplot_helper(1:length(semg), semg, ...
                [3 1 2], {'sample' 'amplitude' 'Normalized sEMG'}, '-');
ylim([-1 1]);            
subplot_helper(1:length(mpu), mpu, ...
                [3 1 3], {'sample' 'amplitude' 'Normalized angle'}, '-');         
ylim([-1 1]);

%% Force segmentation
% Divide the data from the middle of each force action
% Force action: Froce >= force_threshold
output_fileID = fopen(test_output_filename, 'w');


fprintf(output_fileID, '%d\n', 1);
    
% Input
fprintf(output_fileID, '%d %d\n', length(semg), ...
        semg_channel_count + mpu_channel_count);
fprintf(output_fileID, '%f\t', semg');
fprintf(output_fileID, '%f\t', mpu');
fprintf(output_fileID, '\n');

% Output
fprintf(output_fileID, '%d %d\n', length(semg), 1);
fprintf(output_fileID, '%f\t', force');
fprintf(output_fileID, '\n');  

fclose(output_fileID);
