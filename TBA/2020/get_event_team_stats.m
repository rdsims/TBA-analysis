function [team_num, stat_cols, OPR, DPR] = get_event_team_stats(filename)

QUAL_MATCHES_ONLY = 1;          % set to 1 to match TBA's OPR
RANKING_POINTS_TO_SCORE = 1;    % set to 0 to match TBA's OPR

if QUAL_MATCHES_ONLY
    filter = 'qm';
else
    filter = '';
end
data = read_data_file(filename, filter);

TOTAL = 1;
AUTO_DRIVE  = 2;
AUTO_CELL_BOTTOM = 3;
AUTO_CELL_OUTER = 4;
AUTO_CELL_INNER = 5;
TELEOP_CELL_BOTTOM  = 6;
TELEOP_CELL_OUTER  = 7;
TELEOP_CELL_INNER  = 8;
TELEOP_PANEL  = 5; 
ENDGAME_CLIMB = 6;
ENDGAME_LEVEL = 7;
FOUL  = 8;



stat_cols{TOTAL} = 'Total';
stat_cols{AUTO_DRIVE} = 'Auto Drive';
stat_cols{AUTO_CELL_BOTTOM} = 'Auto Cell (Bottom)';
stat_cols{AUTO_CELL_OUTER} = 'Auto Cell (Outer)';
stat_cols{AUTO_CELL_INNER} = 'Auto Cell (Inner)';
stat_cols{TELEOP_CELL_BOTTOM} = 'Teleop Cell (Bottom)';
stat_cols{TELEOP_CELL_OUTER} = 'Teleop Cell (Outer)';
stat_cols{TELEOP_CELL_INNER} = 'Teleop Cell (Inner)';
stat_cols{TELEOP_PANEL} = 'Control Panel';
stat_cols{ENDGAME_CLIMB} = 'Endgame Climb';
stat_cols{ENDGAME_LEVEL} = 'Endgame Level';
stat_cols{FOUL } = 'Foul';


if ~isempty(data)
    team_matrix = [data.team1 data.team2 data.team3];    
    team_num = unique(team_matrix);
    num_teams = length(team_num);
    
    score = zeros(size(data,1), FOUL);
    score(:,TOTAL) = data.score;
    score(:,AUTO_CELL_BOTTOM) = data.autoCellsBottom;
    score(:,AUTO_CELL_OUTER) = data.autoCellsOuter;
    score(:,AUTO_CELL_INNER) = data.autoCellsInner;
    score(:,TELEOP_CELL_BOTTOM) = data.teleopCellsBottom;
    score(:,TELEOP_CELL_OUTER) = data.teleopCellsOuter;
    score(:,TELEOP_CELL_INNER) = data.teleopCellsInner;
    score(:,TELEOP_PANEL)  = data.controlPanelPoints;
    score(:,FOUL)  = data.foulPoints;
    
    if RANKING_POINTS_TO_SCORE
    % convert ranking points to points
%         score(:,TOTAL) = score(:,TOTAL) +  20*cell2mat(data(:,cargo_rp_col));
%         score(:, FUEL) = score(:, FUEL) +  20*cell2mat(data(:,cargo_rp_col));
%         score(:,TOTAL) = score(:,TOTAL) + 100*cell2mat(data(:,panel_rp_col));
%         score(:, GEAR) = score(:, GEAR) + 100*cell2mat(data(:,panel_rp_col));
    end
    
    Team_Matrix = [];
    Score_For = [];
    Score_Against = [];

    num_matches = size(score,1)/2;
    
    if ~isempty(score)
        Team_Matrix   = zeros(2*num_matches,num_teams);
        Score_For     = zeros(2*num_matches,size(score,2));
        Score_Against = zeros(2*num_matches,size(score,2));

        for match = 1:num_matches
            for red_blue = 0:1
                row_for     = 2*match+( red_blue)-1;
                row_against = 2*match+(~red_blue)-1;
                for nteam = 1:3
                    team_idx = find(team_matrix(row_for,nteam) == team_num, 1, 'first');
                    Team_Matrix(row_for,team_idx) = 1;
                end
                Score_For(row_for,:)     = score(row_for,:);
                Score_Against(row_for,:) = score(row_against,:);
            end
        end
    end
    

end

%         Team_Matrix = Team_Matrix(2*30:end,:);
%         Score_For = Score_For(2*30:end,:);
%         Score_Against = Score_Against(2*30:end,:);

% solve Team_Matrix*OPR = Score_For for OPR
% solve Team_Matrix*DPR = Score_Against for DPR
inv_team_matrix = pinv(Team_Matrix);
OPR = zeros(num_teams, size(Score_For,2));
DPR = zeros(size(OPR));
for k=1:size(Score_For,2)
    OPR(:,k)  = inv_team_matrix*Score_For(:,k);
    DPR(:,k)  = inv_team_matrix*Score_Against(:,k);
end


team_matrix = [data.team1 data.team2 data.team3];    
team_num = unique(team_matrix);

% assign points that can be directly attributed
for t=1:numel(team_num)
    match_cnt = 0;
    idx = find(data.team1 == team_num(t));
    match_cnt = match_cnt + numel(idx);
    OPR(t,AUTO_DRIVE) = OPR(t,AUTO_DRIVE) + sum(data.initLineRobot1(idx));
    OPR(t,ENDGAME_CLIMB) = OPR(t,ENDGAME_CLIMB) + sum(data.endgameRobot1(idx));
    for k=idx
        if data.numberOfClimbers(k)
            OPR(t,ENDGAME_LEVEL) = OPR(t,ENDGAME_LEVEL) + sum(data.endgameRungIsLevel(k) ./ data.numberOfClimbers(k));
        end
    end
    
    idx = find(data.team2 == team_num(t));
    match_cnt = match_cnt + numel(idx);
    OPR(t,AUTO_DRIVE) = OPR(t,AUTO_DRIVE) + sum(data.initLineRobot2(idx));
    OPR(t,ENDGAME_LEVEL) = OPR(t,ENDGAME_CLIMB) + sum(data.endgameRobot2(idx));
    for k=idx
        if data.numberOfClimbers(k)
            OPR(t,ENDGAME_LEVEL) = OPR(t,ENDGAME_LEVEL) + sum(data.endgameRungIsLevel(k) ./ data.numberOfClimbers(k));
        end
    end
    
    idx = find(data.team3 == team_num(t));
    match_cnt = match_cnt + numel(idx);
    OPR(t,AUTO_DRIVE) = OPR(t,AUTO_DRIVE) + sum(data.initLineRobot3(idx));
    OPR(t,ENDGAME_CLIMB) = OPR(t,ENDGAME_CLIMB) + sum(data.endgameRobot3(idx));
    for k=idx
        if data.numberOfClimbers(k)
            OPR(t,ENDGAME_LEVEL) = OPR(t,ENDGAME_LEVEL) + sum(data.endgameRungIsLevel(k) ./ data.numberOfClimbers(k));
        end
    end
    
    OPR(t,AUTO_DRIVE) = OPR(t,AUTO_DRIVE) / match_cnt;
    OPR(t,ENDGAME_CLIMB) = OPR(t,ENDGAME_CLIMB) / match_cnt;
    OPR(t,ENDGAME_LEVEL) = OPR(t,ENDGAME_LEVEL) / match_cnt;   
end

stat_cols{AUTO_DRIVE} = 'Auto Drive';
stat_cols{AUTO_CELL_BOTTOM} = 'Auto Cell (Bottom)';
stat_cols{AUTO_CELL_OUTER} = 'Auto Cell (Outer)';
stat_cols{AUTO_CELL_INNER} = 'Auto Cell (Inner)';
stat_cols{TELEOP_CELL_BOTTOM} = 'Teleop Cell (Bottom)';
stat_cols{TELEOP_CELL_OUTER} = 'Teleop Cell (Outer)';
stat_cols{TELEOP_CELL_INNER} = 'Teleop Cell (Inner)';
stat_cols{TELEOP_PANEL} = 'Control Panel';
stat_cols{ENDGAME_CLIMB} = 'Endgame Climb';
stat_cols{ENDGAME_LEVEL} = 'Endgame Level';

