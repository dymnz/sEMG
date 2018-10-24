clear; close all
%% Data gen

% Signal specification
N = 3;
K = 500;
p1_limit = [0 3];
p2_limit = [0 7];

% Generation
p1 = unifrnd(p1_limit(1), p1_limit(2), 1, K);
p2 = unifrnd(p2_limit(1), p2_limit(2), 1, K);

% Mixing
source = [p1; p2];  % N x K
A = [0.5 1.3;
     1.2 0.7];
mixed = A * source;

% Plot source 
figure; 
equal_plot(source, [-1 10], [-1 10]);
title('Source signal', 'FontSize', 20);

% Plot mixed 
figure; 
equal_plot(mixed, [-1 10], [-1 10]);
title('Mixed signal', 'FontSize', 20);

%% nICA - pre-whitening
% http://ufldl.stanford.edu/wiki/index.php/Implementing_PCA/Whitening

C = tdsep2(mixed, [0:2]);
Y = C \ mixed;

% Plot pre-whitened 
figure; 
equal_plot(Y, [-10 10], [-10 10]);
title('pre-whitened', 'FontSize', 20);

figure; 
equal_plot(Y, [-10 10], [-10 10]);
title('Y = WZ', 'FontSize', 20);


