clear; close all;

file_name = './data/test_2semg_long_hodl.txt';
semg_channel = 1:2;
force_channel = 3;


%len = 5000:6000;
raw_data = csvread(file_name);
force = raw_data(:, force_channel);
semg = raw_data(:, semg_channel);

% Remove mean
semg = semg - mean(semg);

%% Original
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


figure;
subplot_helper(1:length(force), force, ...
                [2 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         
subplot_helper(1:length(semg), semg, ...
                [2 1 2], {'sample' 'amplitude' 'Interpolated force and sEMG'}, '-');
return;
%% Remove faulty data
usable_data_range = 1 : 30000;
force = interpolated_force(usable_data_range);
semg = semg(usable_data_range, :);

figure;
subplot_helper(1:length(force), force, ...
                [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         
subplot_helper(1:length(semg(:, 2)), semg(:, 2), ...
                [1 1 1], {'sample' 'amplitude' 'Interpolated force and sEMG'}, '-');

%% Normalization
force = force / max(force);
semg(:, 2) = semg(:, 2) / max(semg(:, 2));

            
%% sEMG moving average
movmean_semg = semg;
movmean_semg(:, 2) = movmean(semg(:, 2), 50);
movmean_semg(:, 2) = movmean_semg(:, 2) / max(movmean_semg(:, 2));

figure;
subplot_helper(1:length(force), force, ...
                [1 1 1], {'sample' 'amplitude' 'Force (kg)'}, '-o');         
subplot_helper(1:length(movmean_semg(:, 2)), movmean_semg(:, 2), ...
                [1 1 1], {'sample' 'amplitude' 'Interpolated force and sEMG'}, '-');

