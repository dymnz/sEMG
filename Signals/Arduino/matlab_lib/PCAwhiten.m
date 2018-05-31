function [xPCAwhite, U, S, V] = PCAwhiten(x)
% Source: http://ufldl.stanford.edu/wiki/index.php/Implementing_PCA/Whitening
% x: NxM, one training example per column

epsilon = 1e-5;

avg = mean(x, 1);     % Compute the mean pixel intensity value separately for each patch. 
x = x - repmat(avg, size(x, 1), 1);

sigma = x * x' / size(x, 2);

[U,S,V] = svd(sigma);

% xRot = U' * x;          % rotated version of the data. 
% xTilde = U(:,1:k)' * x; % reduced dimension representation of the data, 
                        % where k is the number of eigenvectors to keep
                        
xPCAwhite = diag(1./sqrt(diag(S) + epsilon)) * U' * x;
end