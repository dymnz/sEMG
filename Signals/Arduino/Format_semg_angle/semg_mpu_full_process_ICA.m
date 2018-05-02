function [processed_signal] = semg_mpu_full_process_ICA(filename, target_sample_rate, RMS_window_size, semg_sample_rate, semg_max_value, semg_min_value, mpu_max_value, mpu_min_value, mpu_shift_value, semg_channel_count,mpu_channel_count,semg_channel,mpu_channel, seperating_matrix)

raw_data = csvread(filename);
semg = raw_data(:, semg_channel);
mpu = raw_data(:, mpu_channel);

% Remove mean
semg = semg - mean(semg);
mpu = mpu - mpu_shift_value;

%% Angle data interpolation
%mpu(abs(mpu)<1e-3) = 0;

for ch = 1 : mpu_channel_count
    start_point = 1;
    i = 1;
    while i + 1 < length(mpu)
       i = i + 1; 
       if abs(mpu(i, ch) + mpu_shift_value(ch)) > 0
        end_point = i;
        xq = start_point : 1 : end_point;
        mpu(start_point:end_point, ch) = ...
            interp1([start_point end_point], ...
                [mpu(start_point, ch) mpu(end_point, ch)], xq);            
       start_point = i;
       end
    end
    end_point = length(mpu);
    xq = start_point : 1 : end_point;
    mpu(start_point:end_point, ch) = ...
        interp1([start_point end_point], ...
            [mpu(start_point, ch) mpu(end_point, ch)], xq);        
end    

semg_min = min(min(semg));
semg_max = max(max(semg));

figure;
graph_count = 1 + semg_channel_count;
for ch = 1 : mpu_channel_count
    subplot_helper(1:length(semg), semg(:, ch), ...
                    [graph_count 1 ch], ...
                    {'sample' 'amplitude' 'sEMG'}, ...
                    '-');    
    ylim([semg_min semg_max]);
end     

subplot_helper(1:length(mpu), mpu, ...
                [graph_count 1 graph_count], {'sample' 'amplitude' 'Interpolated angle'}, '-');         
ylim([mpu_min_value mpu_max_value]);
legend('Angle-1', 'Angle-2');

% figure;
% subplot_helper(1:length(semg), semg, ...
%                 [2 1 1], {'sample' 'amplitude' 'sEMG'}, '-');
% subplot_helper(1:length(mpu), mpu, ...
%                 [2 1 2], {'sample' 'amplitude' 'Interpolated angle'}, '-');         
% ylim([-90 90]);


%% ICA demix
semg = (seperating_matrix * semg')';

%% sEMG RMS & Angle delay
semg = RMS_calc(semg, RMS_window_size);
mpu = [(mpu(1, :) .* ones(RMS_window_size, size(mpu, 2))) ; mpu];

% figure;
% subplot_helper(1:length(semg), semg, ...
%                 [2 1 1], {'sample' 'amplitude' 'sEMG'}, '-');
% subplot_helper(1:length(mpu), mpu, ...
%                 [2 1 2], {'sample' 'amplitude' 'Interpolated angle'}, '-');         
% ylim([-90 90]);


%% Downsample
downsample_ratio = floor(semg_sample_rate / target_sample_rate);

filter_order = 6;
[semg, cb, ca] = butter_filter( ...
        semg, filter_order, target_sample_rate, semg_sample_rate);
[mpu, cb, ca] = butter_filter( ...
        mpu, filter_order, target_sample_rate, semg_sample_rate);    

semg = downsample(semg, downsample_ratio);
mpu = downsample(mpu, downsample_ratio);


% figure;
% subplot_helper(1:length(semg), semg, ...
%                 [2 1 1], {'sample' 'amplitude' 'Downsampled sEMG'}, '-');
% subplot_helper(1:length(mpu), mpu, ...
%                 [2 1 2], {'sample' 'amplitude' 'Downsampled angle'}, '-');         
% ylim([-90 90]);    

%% Restrain SEMG range
semg(semg > semg_max_value) = semg_max_value;
semg(semg < semg_min_value) = semg_min_value;


%% Remove faulty data
usable_data_range = 1 : min(length(semg), length(mpu));
semg = semg(usable_data_range, :);
mpu = mpu(usable_data_range, :);

% figure;
% subplot_helper(1:length(semg), semg, ...
%                 [2 1 1], {'sample' 'amplitude' 'Truncated sEMG'}, '-');
% subplot_helper(1:length(mpu), mpu, ...
%                 [2 1 2], {'sample' 'amplitude' 'Truncated angle'}, '-');         
% ylim([-90 90]);  

%% Rectify and Normalization

if RMS_window_size <= 0
    semg = semg - mean(semg);
end

% semg = abs(semg);
semg =  2.*(semg - semg_min_value)...
        ./ (semg_max_value - semg_min_value) - 1;

mpu =  2.*(mpu - mpu_min_value)...
        ./ (mpu_max_value - mpu_min_value) - 1;    
        
figure;
subplot_helper(1:length(semg), semg, ...
                [2 1 1], {'sample' 'amplitude' 'Normalized sEMG'}, '-');           
ylim([-1 1]);            
legend('EMG-1', 'EMG-2');
subplot_helper(1:length(mpu), mpu, ...
                [2 1 2], {'sample' 'amplitude' 'Normalized angle'}, '-');         
ylim([-1 1]);
legend('Angle-1', 'Angle-2');


%%

processed_signal = {semg' mpu' length(semg)};
