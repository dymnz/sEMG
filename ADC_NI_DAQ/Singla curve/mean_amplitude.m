function mean_amp = mean_amplitude(file): 

% Read data from .lvm
datamat = lvmread(file);

% Remove mean
datamat(:, 2) = datamat(:, 2) - mean(datamat(:, 2));
mean_amp = mean(abs(datamat(:, 2)));

end