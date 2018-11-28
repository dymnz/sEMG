clear; close all; 
%% Data gen
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
source = [p1; p2; p3], [-0.1 0.5];  % N x K
A = [ 0.5 1.3 -1.0;
     -1.2 0.7  0.6;
      0.9 1.1 -0.3];
mixed = A * source;

% Plot source 
equal_plot_split(source, [-1 10], [-1 10], 'Source data');


% Plot mixed 
figure; 
equal_plot_split(mixed, [-1 10], [-1 10], 'Mixed data');

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
equal_plot_split(Z, [-0.3 0.5], [-0.3 0.5], 'Whitened data');

%% nICA - 2D torque minimization
fsolve_max_step = 2000;
fsolve_tolerance = 1e-16;
global_tolerance_torque = 1e-8;
global_max_step = 2000;
step_per_log = 400;
eta = 1e-2;

W = eye(N);
Z_t = Z;

for step = 0 : global_max_step
Y = Z_t; 

Y_pos = Y;
Y_pos(Y < 0) = 0;
Y_neg = Y;
Y_neg(Y > 0) = 0;

% Pair-wise torque
J = zeros(N);
max_torque = -1;
max_torque_pair_index = [0 0];
for i = 1 : N-1
    for j = i : N
        J(i, j) = Y_pos(i, :)*Y_neg(j, :)' - Y_neg(i, :)*Y_pos(j, :)';
        J(j, i) = -J(i, j);
        
        if max_torque < abs(J(i, j))
            max_torque = abs(J(i, j));
            max_torque_pair_index = [i j];
        end
    end
end

% Terminate if tolerance reached
if max_torque < global_tolerance_torque
    fprintf('Torque target reached at step %5d w/ %.5f\n', step, max_torque);
    break;
end

% Construct reduced data Z_star from pair of axis w/ max torque
mt_i = max_torque_pair_index(1);
mt_j = max_torque_pair_index(2);

Z_star = [Z_t(mt_i, :); 
          Z_t(mt_j, :)];

% 2D torque minimization for Z_star
phi = solve_2d_min_torque(Z_star, fsolve_max_step, fsolve_tolerance);

% Construct rotation matrix R
R = eye(N);
R(mt_i, mt_i) = cos(phi);
R(mt_j, mt_j) = cos(phi);
R(mt_i, mt_j) = sin(phi);
R(mt_j, mt_i) = -sin(phi);

% Update W w/ R
W = R * W;
Z_t = R * Z_t;
      
if mod(step, step_per_log) == 0
    torque = 1/2 * sum((Z - W'*Y_pos).^2, 2);
    fprintf('max torque at step %5d is %.5f\n', step, max_torque);
    figure; 
    equal_plot_split(Z_t, [-0.1 0.5], [-0.1 0.5], sprintf('Y = WZ @ step %d', step));
    saveas(gcf,'Barchart.png')
end

end
