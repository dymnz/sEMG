function [result, cb, ca] = butter_filter(signal, order, fc, fs)
% Return a signal of sampling frequency 'fs',
% filtered by 'order'-order butterworth fitler
% with cutoff frequency 'fc'

[cb,ca] = butter(order, fc/(fs/2));
result = filter(cb, ca, signal);
