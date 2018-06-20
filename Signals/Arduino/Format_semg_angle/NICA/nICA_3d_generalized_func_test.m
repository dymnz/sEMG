clear; close all; 

% Signal specification
N = 3;
K = 500;
p1_limit = [0 3];
p2_limit = [0 7];
p3_limit = [0 2];

% Generation 
p1 = unifrnd(p1_limit(1), p1_limit(2), 1, K);
p2 = unifrnd(p2_limit(1), p2_limit(2), 1, K);
p3 = unifrnd(p3_limit(1), p3_limit(2), 1, K);

% Mixing
source = [p1; p2; p3];  % N x K
A = [ 0.5 1.3 -1.0;
     -1.2 0.7  0.6;
      0.9 1.1 -0.3];
mixed = A * source;

% Plot mixed 
figure; 
equal_plot3(mixed, [-1 10], [-1 10], [-1 10]);
title('Mixed signal', 'FontSize', 20);

% nICA
ica_sig = nICA(mixed);
figure; 
equal_plot3(ica_sig, [-0.1 0.5], [-0.1 0.5], [-0.1 0.5]);
title('nICA signal', 'FontSize', 20);
