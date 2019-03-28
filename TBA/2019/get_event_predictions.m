function [team_matrix, match_scores, team_record, team_ranking_points, SoS] = get_event_predictions(filename, opr_team_num, OPR)

filter = 'qm';
[header, data] = read_data_file(filename, filter);
if isempty(data)
    error('Unable to read %s', filename);
end

team_cols = [find(strcmp(header,'team1')) : find(strcmp(header,'team3'))];

TOTAL = 1;
AUTO  = 2;
CARGO  = 3;
PANEL  = 4;
CLIMB = 5;
FOUL  = 6;
ADJUST  = 7;


team_matrix = cell2mat(data(:,team_cols));    
team_num = unique(team_matrix);
num_teams = length(team_num);

num_matches = size(team_matrix,1)/2;

% Assign points to each team for every match
[~,match_team_idx] = ismember(team_matrix, opr_team_num);
match_team_total_opr = zeros(num_matches,3);
match_team_climb_opr = zeros(num_matches,3);
for alliance = 1:2*num_matches
    for k=1:3
        match_team_total_opr(alliance,k) = OPR(match_team_idx(alliance,k),TOTAL);
        match_team_climb_opr(alliance,k) = OPR(match_team_idx(alliance,k),CLIMB);
    end
end
match_total_opr = round(sum(match_team_total_opr,2));
match_climb_opr = round(sum(match_team_climb_opr,2));

% Assign W/L/T/bonus
win  = zeros(num_teams,1);
loss = zeros(num_teams,1);
tie  = zeros(num_teams,1);
climb_bonus = zeros(num_teams,1);

for match = 1:num_matches
    red_row  = 2*match-1;
    blu_row = 2*match-0;
    red_score = match_total_opr(red_row);
    blu_score = match_total_opr(blu_row);
    red_climb = match_climb_opr(red_row);
    blu_climb = match_climb_opr(blu_row);
    
    for k=1:3
        if red_score > blu_score
             win(match_team_idx(red_row,k)) =  win(match_team_idx(red_row,k)) + 1;
            loss(match_team_idx(blu_row,k)) = loss(match_team_idx(blu_row,k)) + 1;
        elseif red_score < blu_score
             win(match_team_idx(blu_row,k)) =  win(match_team_idx(blu_row,k)) + 1;
            loss(match_team_idx(red_row,k)) = loss(match_team_idx(red_row,k)) + 1;
        else
            tie(match_team_idx(red_row,k)) = tie(match_team_idx(red_row,k)) + 1;
            tie(match_team_idx(blu_row,k)) = tie(match_team_idx(blu_row,k)) + 1;
        end        
        if red_climb > 15
            climb_bonus(match_team_idx(red_row,k)) = climb_bonus(match_team_idx(red_row,k)) + 1;
        end
        if blu_climb > 15
            climb_bonus(match_team_idx(blu_row,k)) = climb_bonus(match_team_idx(blu_row,k)) + 1;
        end
    end
end

match_scores = [match_team_total_opr(1:2:end,:) match_team_total_opr(2:2:end,:)];
team_record = [win loss tie climb_bonus];
team_ranking_points = 2*win + 1*tie + 1*climb_bonus;

% Calculate Strength of Schedule based on OPR (post-event calculation)
SoS = get_event_strength_of_schedule(team_num, OPR, team_matrix);




