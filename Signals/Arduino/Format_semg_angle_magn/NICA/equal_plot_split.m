function equal_plot_split(source, p_xlim, p_ylim, title_str)


figure;
scatter(source(2,:), source(3,:));
xlim(p_xlim); ylim(p_ylim);
daspect([1 1 1])
% https://www.mathworks.com/matlabcentral/answers/97996-is-it-possible-to-add-x-and-y-axis-lines-to-a-plot-in-matlab
axh = gca; % use current axes
color = 'k'; % black, or [0 0 0]
linestyle = ':'; % dotted

line(get(axh,'XLim'), [0 0], 'Color', color, 'LineStyle', linestyle);
line([0 0], get(axh,'YLim'), 'Color', color, 'LineStyle', linestyle);
h = xlabel('Dimension 2'); set(h, 'FontSize', 15)
h = ylabel('Dimension 3'); set(h, 'FontSize', 15)
title([title_str ' (2-3)'], 'FontSize', 20);

figure;
scatter(source(1,:), source(3,:));
xlim(p_xlim); ylim(p_ylim);
daspect([1 1 1])
% https://www.mathworks.com/matlabcentral/answers/97996-is-it-possible-to-add-x-and-y-axis-lines-to-a-plot-in-matlab
axh = gca; % use current axes
color = 'k'; % black, or [0 0 0]
linestyle = ':'; % dotted

line(get(axh,'XLim'), [0 0], 'Color', color, 'LineStyle', linestyle);
line([0 0], get(axh,'YLim'), 'Color', color, 'LineStyle', linestyle);
h = xlabel('Dimension 1'); set(h, 'FontSize', 15)
h = ylabel('Dimension 3'); set(h, 'FontSize', 15)
title([title_str ' (1-3)'], 'FontSize', 20);

figure;
scatter(source(1,:), source(2,:));
xlim(p_xlim); ylim(p_ylim);
daspect([1 1 1])
% https://www.mathworks.com/matlabcentral/answers/97996-is-it-possible-to-add-x-and-y-axis-lines-to-a-plot-in-matlab
axh = gca; % use current axes
color = 'k'; % black, or [0 0 0]
linestyle = ':'; % dotted

line(get(axh,'XLim'), [0 0], 'Color', color, 'LineStyle', linestyle);
line([0 0], get(axh,'YLim'), 'Color', color, 'LineStyle', linestyle);
h = xlabel('Dimension 1'); set(h, 'FontSize', 15)
h = ylabel('Dimension 2'); set(h, 'FontSize', 15)
title([title_str ' (1-2)'], 'FontSize', 20);