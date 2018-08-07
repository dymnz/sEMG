function result = RMS_calc(data, window_size)

% data: Row vectors of varaibles

if window_size > 0   
    col_count = size(data, 1);
    result = zeros(size(data));
    padded_data = [zeros(col_count, window_size - 1)  data];
    
    data_window = zeros(col_count, window_size);
    for i = window_size : length(padded_data)
        data_window(:, :) = padded_data(:, i-window_size + 1: i);
        RMS_val = sqrt(sum(data_window.^2, 2) ./ window_size);
        result(:, i - window_size + 1) = RMS_val;
    end
else
   result = data;
end