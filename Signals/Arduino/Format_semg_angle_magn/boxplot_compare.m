close all;
figure;
boxplot(rms_data, 'Labels',{'FLX', 'EXT', 'PRO','SUP'});
set(findobj(gca, 'type', 'line'), 'linew', 3);

title('RMSDown v.s. nICA');
set(gca,'fontsize', 30);
xlabel('Gesture'); ylabel('RMSE (degree)');
hold on;
boxplot(ica_data, 'Labels',{'FLX', 'EXT', 'PRO','SUP'});





% fprintf('0.25: \t');
% fprintf('%.3f\t', quantile(ica_data, 0.25));
% fprintf('\n');
% 
% fprintf('median:\t');
% fprintf('%.3f\t', median(ica_data));
% fprintf('\n');
% 
% fprintf('0.75: \t');
% fprintf('%.3f\t', quantile(ica_data, 0.75));
% fprintf('\n');