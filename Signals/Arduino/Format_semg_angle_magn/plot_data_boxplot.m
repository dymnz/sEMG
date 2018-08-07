close all;
figure;
boxplot(data, 'Labels',{'FLX', 'EXT', 'PRO','SUP'});
title('RMSDown');
set(findobj(gca, 'type', 'line'), 'linew', 3);
set(gca,'fontsize',20)

fprintf('0.25: \t');
fprintf('%.3f\t', quantile(data, 0.25));
fprintf('\n');

fprintf('median:\t');
fprintf('%.3f\t', median(data));
fprintf('\n');

fprintf('0.75: \t');
fprintf('%.3f\t', quantile(data, 0.75));
fprintf('\n');