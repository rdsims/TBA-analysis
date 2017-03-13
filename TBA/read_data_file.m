function [header, data] = read_data_file(filename, filter)

fid = fopen(filename);
header_line = fgetl(fid);
header = regexp(header_line, ',', 'split');

data = {};
while ~feof(fid)
    line = fgetl(fid);
    d = regexp(line, ',', 'split');
    data(end+1,:) = d;
end
fclose(fid);

if ~isempty(filter)
    % apply filter
    comp_level_col = find(~cellfun(@isempty, strfind(header,'comp')));
    filter_matches = strfind(data(:,comp_level_col), filter);
    data = data(~cellfun(@isempty, filter_matches), :);
end

% convert numeric columns to double
for k=1:length(data(:))
    n = str2double(data{k});
    if ~isnan(n)
        data{k} = n;
    end
end
