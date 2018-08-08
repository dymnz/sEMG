close all;
figure;
boxplot(data, 'Labels',{'FLX', 'EXT', 'PRO','SUP'});
set(findobj(gca, 'type', 'line'), 'linew', 3);

title('RMSDown');
set(gca,'fontsize', 30);
xlabel('Gesture'); ylabel('RMSE (degree)');

outlier_list = isoutlier(data, 'quartiles');
outlier_list = ~outlier_list;

mean_list = zeros(1, 4);
for i = 1 : 4
    clean_data = data(outlier_list(:, i), i);
    mean_list(i) = mean(clean_data);
end
mean_list
% fprintf('median:\t');
% fprintf('%.3f\t', median(ica_data));
% fprintf('\n');
