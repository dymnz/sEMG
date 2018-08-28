% Remove outlier of each segment in each gesture (N/10 * 60)
% Find the median of each segment


close all; clear all;
mean_list = zeros(10, 4);

gesture_list = {'FLX', 'EXT', 'PRO','SUP'};

nica_data = load('./result/S2WA_23_nICA_3_10rd_data.mat');
nica_data = nica_data.all_RMS_list;

rmsdown_data = load('./result/S2WA_23_RMSDown_4_10rd_data.mat');
rmsdown_data = rmsdown_data.all_RMS_list;

rmsdown_mean_list = [];
nica_mean_list = [];
for i = 1 : 4
    
figure; hold on;
title(gesture_list{i});

rmsdown_ges = rmsdown_data(:, i:4:40)';
nica_ges = nica_data(:, i:4:40)';

boxplot(rmsdown_ges);
set(findobj(gca, 'type', 'line'), 'linew', 3);
boxplot(nica_ges);
set(gca,'fontsize', 30);

plot(median(rmsdown_ges), '-o');
plot(median(nica_ges), '-o');

rmsdown_mean_list = [rmsdown_mean_list mean(median(rmsdown_ges))];
nica_mean_list = [nica_mean_list mean(median(nica_ges))];
% max_error = max(max(max(median(rmsdown_ges))), max(max(median(nica_ges))));
% ylim([0 max_error]);
% ylim([0 40]);
xlim([1 20]);
end
rmsdown_mean_list
nica_mean_list