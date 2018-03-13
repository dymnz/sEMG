clear; close all;


file_name = './data/ard_neutral_1kg.txt';
figure_name = '1kg sEMG-Force @neutral';
semg_channel = 1:2;
semg_channel_count = 2;
force_channel = 3;

semg_max_value = 2048/2;
semg_min_value = -2048/2;
force_max_value = 2.5;
semg_sample_rate = 5100; % Approximate
target_sample_rate = 100;

train_output_filename = './data/output/exp_ard_DS100_FORCE_SEG.txt';
test_output_filename = './data/output/exp_ard_full.txt';

raw_data = csvread(file_name);
force = raw_data(:, force_channel);
semg = raw_data(:, semg_channel);

% Remove mean
semg = semg - mean(semg);

%% Original

fprintf('original signal time: %.2f\n', length(semg)/semg_sample_rate);

figure;
subplot_helper(1:length(force), force, ...
                [2 1 1], {'sample' 'kg' 'Force'}, '-o');
subplot_helper(1:length(semg), semg, ...
                [2 1 2], {'sample' 'au' 'sEMG'}, '-o');            
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


figure('Name', figure_name);
subplot_helper(1:length(force), force, ...
                [3 1 1], {'sample' 'amplitude' figure_name}, '-o');         
ylim([0, force_max_value]);
subplot_helper(1:length(semg), semg(:, 1), ...
                [3 1 2], {'sample' 'amplitude' 'sEMG - 1'}, '-');
ylim([semg_min_value, semg_max_value]);
subplot_helper(1:length(semg), semg(:, 2), ...
                [3 1 3], {'sample' 'amplitude' 'sEMG - 2'}, '-');
ylim([semg_min_value, semg_max_value]);

print(strcat('./pics/', figure_name, '.png'),'-dpng')