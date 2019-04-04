function team_num = get_event_teams(filename)

[header, data] = read_data_file(filename, '');

team_cols   = [find(strcmp(header,'team1')) : find(strcmp(header,'team3'))];

team_matrix = cell2mat(data(:,team_cols));    
team_num = unique(team_matrix);
