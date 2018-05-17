function result = AVG_calc(data, window_size)

if window_size > 0   
    col_count = size(data, 2);
    result = zeros(size(data));
    padded_data = [zeros(window_size - 1, col_count) ; data];

    data_window = zeros(window_size, col_count);
    for i = window_size : length(padded_data)
        data_window(:, :) = padded_data(i-window_size + 1: i, :);
        AVG_val = sum(data_window) ./ window_size;
        result(i - window_size + 1, :) = AVG_val;
    end
else
   result = data;
end