clear; close all;

%%
file_paths = {
    '..\..\Signals\2017_09_15\',
     '..\..\Signals\2017_09_15\'
    };
angles = {
    '90d', 
    '105d'
    };
file_names = {
    '1kg',
    '2kg',
    '3kg',
    '4kg'
    };
extension = '.lvm';
calibration_file = '0kg_90d';

path_len = length(file_paths);
name_len = length(file_names);

%%
norm_baseline = zeros(path_len, 1);
norm_MAV = zeros(path_len, name_len);

for i = 1 : path_len
    % Find the ratio of calibration 0kg_90d       
    path = file_paths{i};
    name = strcat(calibration_file, extension);
    
    disp(mean_amplitude(strcat(path, name)));
    norm_baseline(i) = mean_amplitude(strcat(path, name));
    for r = 1 : name_len
        
        name = strcat(file_names{r}, '_', angles{i}, extension);        
        norm_MAV(i, r) = ...
            mean_amplitude(strcat(path, name)) / norm_baseline(i);
    end  
end

figure; hold on;
for i = 1 : path_len
    plot([1:4], norm_MAV(i, :), '-o');
    
end
title('Weight - sEMG relationship @ angle')
legend(angles);
xlabel('weight (kg)');
ylabel('avg. amplitude (AU)');
% name = file_names{1}{1};
