function torque = torque_cost_func(phi, Z)
W = [ cos(phi) sin(phi);
     -sin(phi) cos(phi)];
 
Y = W * Z;
Y_pos = Y;
Y_pos(Y < 0) = 0;

torque = 1/2 * sum(sum((Z - W'*Y_pos).^2, 2));