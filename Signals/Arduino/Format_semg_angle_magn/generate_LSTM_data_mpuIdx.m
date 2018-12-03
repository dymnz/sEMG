function generate_LSTM_data_mpuIdx(filename, data, mpu_idx)

% data: 3xN

num_of_segments = size(data, 2);

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
            1);
    fprintf(fileID, '%f\t', output(mpu_idx, :));
    fprintf(fileID, '\n');    

%     figure;
%     subplot_helper(1:length(input), input, ...
%                     [2 1 1], {'sample' 'amplitude' 'Interpolated sEMG'}, '-');   
%     ylim([-1 1]);
%     subplot_helper(1:length(output), output(mpu_idx, :), ...
%                     [2 1 2], {'sample' 'amplitude' 'Interpolated Angle'}, '-'); 
%     ylim([-1 1]);
end

fclose(fileID);