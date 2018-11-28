clear; close all
%% Data gen

% Signal specification
N = 2;
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
equal_plot(source, [-1 4], [-1 10]);
title('Source signal', 'FontSize', 20);

% Plot mixed 
figure; 
equal_plot(mixed, [-1 10], [-1 10]);
title('Mixed signal', 'FontSize', 20);

%% nICA - pre-whitening
% http://ufldl.stanford.edu/wiki/index.php/Implementing_PCA/Whitening
X = mixed; % N x K
avg = mean(X, 2);     % Compute the mean pixel intensity value separately for each patch. 
x_centered = X - repmat(avg, 1, size(X, 2));

Cx = x_centered * x_centered' / size(x_centered, 1);
[E, D, V] = svd(Cx);

V =  E * diag(1./sqrt(diag(D))) * E';
Z = V * X;

% Plot pre-whitened 
figure; 
equal_plot(Z, [-0.1 0.5], [-0.1 0.5]);
title('pre-whitened', 'FontSize', 20);

%% nICA - 2D torque minimization
max_step = 400;
step_per_log = 50;
phi = 0;
eta = 1e-2;

for step = 0 : max_step
W = [ cos(phi) sin(phi);
     -sin(phi) cos(phi)];
 
Y = W * Z;

Y_pos = Y;
Y_pos(Y < 0) = 0;
Y_neg = Y - Y_pos;

if mod(step, step_per_log) == 0
    J = 1/2 * sum((Z - W'*Y_pos).^2, 2);
    fprintf('torque at step %5d is %.5f %.5f\n', step, J(1), J(2));
    figure; 
    equal_plot(Y, [-0.1 0.3], [-0.1 0.3]);
    title(sprintf('Y = WZ @ step %d', step), 'FontSize', 20);
end

delta_phi = - (Y_pos(1, :)*Y_neg(2, :)' - Y_neg(1, :)*Y_pos(2, :)');

phi = phi - eta * delta_phi;

end
