function generate_LSTM_data(filename, data)

% data: 3xN

num_of_segments = length(data);

fileID = fopen(filename, 'w');
fprintf(fileID, '%d\n', num_of_segments);

for i = 1 : num_of_segments
    input = data{1, i};
    output = data{2, i};
    segment_length = data{3, i};
    
    % Input
    fprintf(fileID, '%d %d\n', ...
            segment_length, ...
            size(input, 1));
    fprintf(fileID, '%f\t', input);
    fprintf(fileID, '\n');

    % Output: Angle
    fprintf(fileID, '%d %d\n', ...
            segment_length, ...
            size(output, 1));
    fprintf(fileID, '%f\t', output);
    fprintf(fileID, '\n');    

    figure;
    subplot_helper(1:length(input), input, ...
                    [2 1 1], {'sample' 'amplitude' 'Interpolated sEMG'}, '-');                            
    subplot_helper(1:length(output), output, ...
                    [2 1 2], {'sample' 'amplitude' 'Interpolated Angle'}, '-');                                           
end

fclose(fileID);