function subplot_helper(X, Y, D, Label, symbol)
subplot(D(1), D(2), D(3));
plot(X, Y, symbol, 'LineWidth', 2);
hold on;
xlabel(Label(1), 'FontSize', 20);
ylabel(Label(2), 'FontSize', 20);
title(Label(3), 'FontSize', 20);

h = findobj(gca,'Type','line');
ydata = get(h, 'Ydata');

if iscell(ydata)
    ymax = max(ydata{1, :});
    ymin = min(ydata{1, :});
    for i = 2: size(ydata, 1)
        ymax = max(ymax, max(ydata{i, :}));
        ymin = min(ymin, min(ydata{i, :}));
    end
else
    ymax = max(ydata);
    ymin = min(ydata);
end

ylim([ymin ymax]);