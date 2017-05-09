
file_path = '/Users/wangshunxing/Work/PortableSEMG/Signals/';

filename = '1.lvm';

% [num,txt,raw] = xlsread(strcat(file_path, filename));
datamat = lvmread(strcat(file_path, filename));

plot(datamat(:, 2))