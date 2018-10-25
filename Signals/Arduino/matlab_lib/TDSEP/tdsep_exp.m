clear; close all
%% Data gen

% Signal specification
f = 50;	% Hz
res = 4000;
K = 2000;
p1_limit = [0 3];
p2_limit = [0 7];

noise_amp = 1;

% Generation
load sensorData
p1 = normalize(s1(1:K)');
p2 = normalize(s2(1:K)');


% Mixing
source = [p1; p2];  % N x K
A = [0.5 1.3;
     1.2 0.7];
mixed = A * source;

m1 = mixed(1, :);
m2 = mixed(2, :);

% Plot source 
figure; hold on;
plot(p1, '-'); 
plot(p2, '-'); 
legend('Source 1', 'Source 2');
% ylim([-5 5]);
title('Source signal', 'FontSize', 20);
ylabel('Magnitude (AU)');
xlabel('sample');

figure; 
equal_plot(source, [-10 10], [-10 10]);
title('Source distribution', 'FontSize', 20);
ylabel('Source 1');
xlabel('Source 2');

% Plot source x-corr
figure;
[res, lag] = xcorr(p1, p2, 3);
plot(lag, res); 
title('Source x-corr', 'FontSize', 20);
ylabel('Magnitude (AU)');
xlabel('Lags (sample)');

% Plot mixed 
figure; hold on;
plot(m1, '-'); 
plot(m2, '-'); 
% ylim([-5 5]);
legend('Mixed 1', 'Mixed 2');
title('Mixed signal', 'FontSize', 20);
ylabel('Magnitude (AU)');
xlabel('sample');

figure; 
equal_plot(mixed, [-10 10], [-10 10]);
title('Mixed signal distribution', 'FontSize', 20);
ylabel('Mixed 1');
xlabel('Mixed 2');

% Plot mixed x-corr
figure;
[res, lag] = xcorr(m1, m2, 3);
plot(lag, res); 
title('Mixed x-corr', 'FontSize', 20);
ylabel('Magnitude (AU)');
xlabel('Lags (sample)');

%% nICA - pre-whitening
% http://ufldl.stanford.edu/wiki/index.php/Implementing_PCA/Whitening

C = tdsep2(mixed);
Y = C \ mixed;

y1 = Y(1, :);
y2 = Y(2, :);

figure; hold on;
plot(y1, '-'); 
plot(y2, '-'); 
ylim([-5 5]);
legend('Demixed 1', 'Demixed 2');
title('Demixed signal', 'FontSize', 20);
ylabel('Magnitude (AU)');
xlabel('sample');

figure; 
equal_plot(Y, [-10 10], [-10 10]);
title('Demixed signal distribution', 'FontSize', 20);
ylabel('Demixed 1');
xlabel('Demixed 2');

% Plot y x-corr
figure;
[res, lag] = xcorr(y1, y2, 3);
plot(lag, res); %ylim([-1000 1000]);
title('Demixed x-corr', 'FontSize', 20);
ylabel('Magnitude (AU)');
xlabel('Lags (sample)');

