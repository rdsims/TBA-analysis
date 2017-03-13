function [score_cols, match_differential] = get_match_differential(filename, filter)

[header, data] = read_data_file(filename, filter);

score_col = find(strcmp(header,'score'));
score_cols = header(score_col:end);
match_differential = [];

if ~isempty(data)
    score_matrix = cell2mat(data(:,score_col:end));

    red_rows  = 1:2:size(data,1);
    blue_rows = 2:2:size(data,1);
    match_differential = score_matrix(red_rows,:) - score_matrix(blue_rows,:);

    blue_wins = (match_differential(:,1)<0);
    match_differential(blue_wins,:) = -match_differential(blue_wins,:);
end