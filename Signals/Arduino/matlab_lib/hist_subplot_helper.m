function hist_subplot_helper(X, Y, D, Label, symbol)
subplot(D(1), D(2), D(3));
%plot(X, Y, symbol, 'LineWidth', 2);
histogram(Y);
hold on;
title(Label(3), 'FontSize', 20);
