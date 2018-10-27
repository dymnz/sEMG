function equal_plot(source, p_xlim, p_ylim)
scatter(source(2,:), source(3,:));
xlim(p_xlim); ylim(p_ylim);
daspect([1 1 1])
% https://www.mathworks.com/matlabcentral/answers/97996-is-it-possible-to-add-x-and-y-axis-lines-to-a-plot-in-matlab
axh = gca; % use current axes
color = 'k'; % black, or [0 0 0]
linestyle = ':'; % dotted

line(get(axh,'XLim'), [0 0], 'Color', color, 'LineStyle', linestyle);
line([0 0], get(axh,'YLim'), 'Color', color, 'LineStyle', linestyle);
