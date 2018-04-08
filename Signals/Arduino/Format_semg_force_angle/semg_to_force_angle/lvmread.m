% lvmplot - Reads labview lvm files and returns the data
%
% Synopsis:
%   data = lvmplot(<filename>)
%
% lvmplot plots the data for a specified file. Data is returned as columns
% vectors with one column of values for each column found in the file.
%
% Data should be exported from Labview using the 'Write to Measurement File'.
% If the data was recorded with segmented headers you will see a warning
% that notes only the last segment will be used. lvmread will attempt to
% detect how your data is delimited by using a regex pattern search for
% the Labview header. 
%
% Example: for an lvm file with two columns
%    data = lvmplot('myLabviewData.lvm')
%    x = data(:,1)
%    y = data(:,2)
%
% Author: 
%   David Goodman <dagoodman@soe.ucsc.edu>
%
function [data] = lvmread(filename)
% Options and constants
DEBUG = 0;
DELIM_COMMA=',';
DELIM_TAB='\t';
% Regular expressions
% removes header with regex substitution
expression_header='(.*\*\*\*End_of_Header\*\*\*,*)';
expression_header_count='(\*\*\*End_of_Header\*\*\*,*)';
expression_delimiter='(?:\d*\.?)*(?<tab>\t)*(?<comma>,)\s*(?:\d*.?)*';
% Variables
fileID = -1;
delimiter=DELIM_COMMA;

% Missing required arguments?
if nargin < 1 || ~ischar(filename) || length(filename) < 1
    error('Missing argument ''filename''')
elseif ~exist(filename, 'file')
    error(strcat('Could not find ''',filename,'''.'))
end

%% Error handling main block
err = 0;
try
    % Open file and regex search for start of data
    filecontents = fullfile(filename); 
    filetext = fileread(filecontents);
    fclose 'all';
    
    % Give a warning for multiple headers
    [startIndex endIndex out] = regexp(filetext,expression_header_count);
    [temp1 header_count] = size(out);
    if (header_count > 2)
        warning('segmented headers detected, using last segment');
    end
    % Do search for last header
    [startIndex endIndex out] = regexp(filetext,expression_header);
    % Find starting line by counting header lines
    [temp1 temp2 results] = regexp(filetext(1:endIndex),'(\r?\n)*');
    startLine = length(results);
    if startLine > 0
        startLine = startLine + 2; % skip column header
    end

    % Determine delimiter
    [matches] = regexp(filetext(endIndex:length(filetext)),expression_delimiter,'names');
    if matches.comma
        delimiter = DELIM_COMMA;
    elseif matches.tab
        delimiter = DELIM_TAB;
    else
        error('Unknown delimiter in data file.');
    end
    if (DEBUG)
        fprintf('Reading ''%s'' starting at line %u.\n',filename,startLine);
    end
    data=dlmread(filename,delimiter,startLine,0);

catch err
    % Do nothing. handle it later after cleanup
end

%% Clean up
fclose 'all';

if (strcmp(class(err), 'MException'))
    rethrow(err);
end

% Done

end % functuon
