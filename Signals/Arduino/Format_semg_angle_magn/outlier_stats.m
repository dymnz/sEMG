mean_list = zeros(10, 4);
for i = 1 : 10
s_idx = (i - 1) * 4 + 1;
data = all_RMS_list(:, s_idx:s_idx+3);

outlier_list = isoutlier(data, 'quartiles');
outlier_list = ~outlier_list;


for r = 1 : 4
    clean_data = data(outlier_list(:, r), r);
    mean_list(i, r) = mean(clean_data);
end
mean_list
% fprintf('median:\t');
% fprintf('%.3f\t', median(ica_data));
% fprintf('\n');

end


%%
hold on;
boxplot(mean_list, 'Labels',{'FLX', 'EXT', 'PRO','SUP'});
title('RMSDown v.s. nICA - 10x average');