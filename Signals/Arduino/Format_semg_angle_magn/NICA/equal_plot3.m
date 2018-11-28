function equal_plot3(source, p_xlim, p_ylim, p_zlim)
rotate3d on;
scatter3(source(1,:), source(2,:), source(3,:));
xlim(p_xlim); ylim(p_ylim); zlim(p_zlim);
daspect([1 1 1])
% https://www.mathworks.com/matlabcentral/answers/97996-is-it-possible-to-add-x-and-y-axis-lines-to-a-plot-in-matlab
axh = gca; % use current axes
color = 'k'; % black, or [0 0 0]
linestyle = ':'; % dotted

line(get(axh,'XLim'), [0 0], 'Color', color, 'LineStyle', linestyle);
line([0 0], get(axh,'YLim'), 'Color', color, 'LineStyle', linestyle);
h = xlabel('Dimension 1'); set(h, 'FontSize', 15)
h = ylabel('Dimension 2'); set(h, 'FontSize', 15)
h = zlabel('Dimension 3'); set(h, 'FontSize', 15)