close all; clear;

angle = [150:-10:30];
voltage = [ ...
    1170, 1410, 1690, 1960, 2250, 2530, 2805, 3070, 3350, 3610, 3865, 3950, 3962];

figure;
plot(voltage, angle, '-o', 'LineWidth', 3);
xlabel('Voltage', 'FontSize', 20);
ylabel('Angle', 'FontSize', 20);

% Safety range = 150 ~ 50d, 1170 ~ 3865


% y = mx + b
m = (150 - 50) / (1170 - 3865);
b = 150 - m * 1170;

safe_voltage = 1170:3865;
cal_angle = safe_voltage .* m + b .* ones(size(safe_voltage));

hold on;
plot(safe_voltage, cal_angle, 'LineWidth', 3);
set(gca,'fontsize',20
legend({'Measured', 'Line'}, 'FontSize', 20);
