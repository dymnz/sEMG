% Remove outlier of each gesture in each round (N/60 * 10)
% Find the median w/ the mean of the outlier removed round

close all; clear all;
mean_list = zeros(10, 4);


nica_data = load('./result/S2WA_23_nICA_1_10rd_data.mat');
nica_data = nica_data.all_RMS_list;

rmsdown_data = load('./result/S2WA_23_RMSDown_1_10rd_data.mat');
rmsdown_data = rmsdown_data.all_RMS_list;

title_string = 'RMSDown v.s. nICA_1 - 10x average';

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
fprintf('RMSDown: \t75th: \t\t');
fprintf('%f\t', rmsdown_qt(3, :));
fprintf('\nRMSDown: \t25th: \t\t');
fprintf('%f\t', rmsdown_qt(1, :));

nICA_qt = quantile(nica_mean_list, [0.25 0.5 0.75]);
fprintf('\nnICA: \t\t75th: \t\t');
fprintf('%f\t', nICA_qt(3, :));
fprintf('\nnICA: \t\t25th: \t\t');
fprintf('%f\t', nICA_qt(1, :));
fprintf('\n');

fprintf('\nMean:');
fprintf('\nRMSDown: \t');
fprintf('%.2f\t', mean(rmsdown_mean_list));

fprintf('\nnICA: \t\t');
fprintf('%.2f\t', mean(nica_mean_list));
fprintf('\n');

fprintf('\nMedian:');
fprintf('\nRMSDown: \t');
fprintf('%.2f\t', rmsdown_qt(2, :));
fprintf('\nnICA: \t\t');
fprintf('%.2f\t', nICA_qt(2, :));
fprintf('\n');

fprintf('\nMean w/ round mean outlier removed:');
fprintf('\nRMSDown: \t');
fprintf('%.2f\t', rmsdown_mean_mean_list);

fprintf('\nnICA: \t\t');
fprintf('%.2f\t', nica_mean_mean_list);
fprintf('\n');