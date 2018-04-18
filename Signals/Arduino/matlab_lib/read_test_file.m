function [num_matrix, input_matrix_list, output_matrix_list] = ...
            read_test_file(file_name)

fileID = fopen(file_name,'r');
num_matrix = fscanf(fileID, '%d', 1);

%fprintf('reading %d samples\n', num_matrix);

input_matrix_list = {};
output_matrix_list = {};

for i = 1 : num_matrix
    
    m = fscanf(fileID, '%d', 1);
    n = fscanf(fileID, '%d', 1);    
    temp_matrix = zeros(m, n);
    for r = 1 : m
        for j = 1 : n
            temp_matrix(r, j) = fscanf(fileID, '%f32', 1);
        end
    end
    input_matrix_list{i} = temp_matrix;

    
    m = fscanf(fileID, '%d', 1);
    n = fscanf(fileID, '%d', 1);
    temp_matrix = zeros(m, n);
    for r = 1 : m
        for j = 1 : n
            temp_matrix(r, j) = fscanf(fileID, '%f32', 1);
        end
    end
    output_matrix_list{i} = temp_matrix;
end

fclose(fileID);