% Remove outlier of each gesture in each round (N/60 * 10)
% Find the median w/ the mean of the outlier removed round

close all; clear all;


exp_num = 32;
target_sample_rate = 35;


nica_file_num = 1;
mean_list = zeros(10, 4);
formatted_Median_list = zeros(1 + nica_file_num, 4);
formatted_Mean_list = zeros(1 + nica_file_num, 4);

for nica_file_idx = 1 : nica_file_num
    
nica_record_filename = ['./result/S2WA_' num2str(exp_num) '_nICA_' ...
    num2str(nica_file_idx) '_SPS' ...
    num2str(target_sample_rate) '_h8' '_10rd_data'];

rmsdown_record_filename = ['./result/S2WA_' num2str(exp_num) '_RMSDown_' ...
    'SPS' num2str(target_sample_rate) '_h8' '_10rd_data'];

nica_data = load(nica_record_filename);
nica_data = nica_data.all_RMS_list;

rmsdown_data = load(rmsdown_record_filename);
rmsdown_data = rmsdown_data.all_RMS_list;

title_string = ['RMSDown v.s. nICA_' num2str(nica_file_idx) '- 10x average'];

%%%
for i = 1 : 10
s_idx = (i - 1) * 4 + 1;
data = rmsdown_data(:, s_idx:s_idx+3);

outlier_list = isoutlier(data, 'quartiles');
outlier_list = ~outlier_list;

for r = 1 : 4
    clean_data = data(outlier_list(:, r), r);
    mean_list(i, r) = mean(clean_data);
end
end

rmsdown_mean_list = mean_list;
rmsdown_mean_outlier_list = isoutlier(rmsdown_mean_list, 'quartiles');
rmsdown_mean_outlier_list = ~rmsdown_mean_outlier_list;

rmsdown_mean_mean_list = zeros(1, 4);
for r = 1 : 4
    clean_data = rmsdown_mean_list(rmsdown_mean_outlier_list(:, r), r);
    
    rmsdown_mean_mean_list(r) = mean(clean_data);
end

%%%
for i = 1 : 10
s_idx = (i - 1) * 4 + 1;
data = nica_data(:, s_idx:s_idx+3);

outlier_list = isoutlier(data, 'quartiles');
outlier_list = ~outlier_list;

for r = 1 : 4
    clean_data = data(outlier_list(:, r), r);
    mean_list(i, r) = mean(clean_data);
end
end

nica_mean_list = mean_list;
nica_mean_outlier_list = isoutlier(nica_mean_list, 'quartiles');
nica_mean_outlier_list = ~nica_mean_outlier_list;

nica_mean_mean_list = zeros(1, 4);
for r = 1 : 4
    clean_data = nica_mean_list(nica_mean_outlier_list(:, r), r);
    
    nica_mean_mean_list(r) = mean(clean_data);
end


%%
max_error = max(max(max(rmsdown_mean_list)), max(max(nica_mean_list)));

figure; hold on;
title(title_string);
boxplot(rmsdown_mean_list, 'Labels',{'FLX', 'EXT', 'PRO','SUP'});
set(findobj(gca, 'type', 'line'), 'linew', 3);

boxplot(nica_mean_list, 'Labels',{'FLX', 'EXT', 'PRO','SUP'});
set(gca,'fontsize', 30);
xlabel('Gesture'); ylabel('RMSE (degree)');
ylim([0 max_error]);


rmsdown_qt = quantile(rmsdown_mean_list, [0.25 0.5 0.75]);
nICA_qt = quantile(nica_mean_list, [0.25 0.5 0.75]);

% fprintf('RMSDown: \t75th: \t\t');
% fprintf('%f\t', rmsdown_qt(3, :));
% fprintf('\nRMSDown: \t25th: \t\t');
% fprintf('%f\t', rmsdown_qt(1, :));
% 

% fprintf('\nnICA: \t\t75th: \t\t');
% fprintf('%f\t', nICA_qt(3, :));
% fprintf('\nnICA: \t\t25th: \t\t');
% fprintf('%f\t', nICA_qt(1, :));
% fprintf('\n');
% 
% fprintf('\nMean:');
% fprintf('\nRMSDown: \t');
% fprintf('%.2f\t', mean(rmsdown_mean_list));
% 
% fprintf('\nnICA: \t\t');
% fprintf('%.2f\t', mean(nica_mean_list));
% fprintf('\n');
% 

fprintf('========== nICA_%d', nica_file_idx);

fprintf('\nMedian:');
fprintf('\nRMSDown: \t');
fprintf('%.2f\t', rmsdown_qt(2, :));
fprintf('\nnICA: \t\t');formatted_Median_list(1, :) = rmsdown_qt(2, :);
fprintf('%.2f\t', nICA_qt(2, :));
fprintf('\n\n');

formatted_Median_list(1, :) = rmsdown_qt(2, :);
formatted_Median_list(1 + nica_file_idx, :) = nICA_qt(2, :);

fprintf('Mean w/ round mean outlier removed:', nica_file_idx);
fprintf('\nRMSDown: \t');
fprintf('%.2f\t', rmsdown_mean_mean_list);

fprintf('\nnICA: \t\t');
fprintf('%.2f\t', nica_mean_mean_list);
fprintf('\n');

formatted_Mean_list(1, :) = rmsdown_mean_mean_list;
formatted_Mean_list(1 + nica_file_idx, :) = nica_mean_mean_list;

end