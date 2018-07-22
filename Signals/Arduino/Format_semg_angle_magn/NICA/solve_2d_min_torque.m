function phi = solve_2d_min_torque(Z, max_step, tolerance)
% Z: N-dim x K-sample

options = optimset('MaxIter', max_step ,'TolFun', tolerance, 'Display', 'off');
torque_fun = @(phi, Z) torque_cost_func(phi, Z); % function
fun = @(phi) torque_fun(phi, Z);    % function of x alone
phi = fsolve(fun, 0, options);