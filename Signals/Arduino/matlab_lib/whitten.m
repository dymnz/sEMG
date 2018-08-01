function [whitened_sig, V] = whitten(sig) 

% sig: K-dim x N-sample
sig = sig';	% Workaround to fit the other program

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
whitened_sig = whitened_sig';	% Workaround to fit the other program
