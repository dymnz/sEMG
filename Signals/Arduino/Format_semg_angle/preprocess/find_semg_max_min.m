% filename_list

function max_min_list = find_semg_max_min(filename_list, file_loc_prepend, file_extension, filename_prepend)

for f = 1 : numel(filename_list)
filename = filename_list{f};
file = [file_loc_prepend, filename_prepend, ...
            filename, file_extension];
raw_data = csvread(file);
semg = raw_data(:, semg_channel);

semg = semg(10:end - 10, :);
semg = semg - mean(semg);


end