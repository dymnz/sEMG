function [ica_sig, whitened_sig] = nICA(sig, fsolve_max_step, fsolve_tolerance, global_tolerance_torque, global_max_step, step_per_log) 

% sig: N-dim x K-sample

N = size(sig, 1);
K = size(sig, 2);


%% nICA - pre-whitening
% http://ufldl.stanford.edu/wiki/index.php/Implementing_PCA/Whitening

X = sig; % N x K
avg = mean(X, 2);     % Compute the mean pixel intensity value separately for each patch. 
x_centered = X - repmat(avg, 1, size(X, 2));

Cx = x_centered * x_centered' / size(x_centered, 1);
[E, D, V] = svd(Cx);

V =  E * diag(1./sqrt(diag(D))) * E';
Z = V * X;

whitened_sig = Z;

%% nICA - 2D torque minimization
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
    fprintf('Torque target reached at step %5d w/ %.20lf\n', step, max_torque);
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
    fprintf('max torque at step %5d is %.20f\n', step, max_torque);
end

end

ica_sig = Z_t;