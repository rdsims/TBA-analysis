function [team_num, stat_cols, OPR, DPR] = get_event_team_stats(filename)

QUAL_MATCHES_ONLY = 1;          % set to 1 to match TBA's OPR
RANKING_POINTS_TO_SCORE = 1;    % set to 0 to match TBA's OPR

if QUAL_MATCHES_ONLY
    filter = 'qm';
else
    filter = '';
end
[header, data] = read_data_file(filename, filter);

team_cols   = [find(strcmp(header,'team1')) : find(strcmp(header,'team3'))];
score_col   = [find(strcmp(header,'score'))];
auto_cols   = [find(strcmp(header,'autoPoints'))];
cargo_cols  = [find(strcmp(header,'cargoPoints'))];
panel_cols  = [find(strcmp(header,'hatchPanelPoints'))];
climb_col   = [find(strcmp(header,'habClimbPoints'))];
foul_col    = [find(strcmp(header,'foulPoints'))];
adjust_col  = [find(strcmp(header,'adjustPoints'))];

TOTAL = 1;
AUTO  = 2;
CARGO  = 3;
PANEL  = 4;
CLIMB = 5;
FOUL  = 6;
ADJUST  = 7;

stat_cols{TOTAL} = 'Total';
stat_cols{AUTO } = 'Auto';
stat_cols{CARGO } = 'Cargo';
stat_cols{PANEL } = 'Panel';
stat_cols{CLIMB} = 'Climb';
stat_cols{FOUL } = 'Foul';
stat_cols{ADJUST} = 'Adjust';


if ~isempty(data)
    team_matrix = cell2mat(data(:,team_cols));    
    team_num = unique(team_matrix);
    num_teams = length(team_num);
    
    score = zeros(size(data,1), FOUL);
    score(:,TOTAL) = cell2mat(data(:,score_col));
    score(:,AUTO)  = sum(cell2mat(data(:,auto_cols)),2);
    score(:,CARGO)  = sum(cell2mat(data(:,cargo_cols)),2);
    score(:,PANEL)  = sum(cell2mat(data(:,panel_cols)),2);
    score(:,CLIMB) = cell2mat(data(:,climb_col));
    score(:,FOUL)  = cell2mat(data(:,foul_col));
    score(:,ADJUST)  = cell2mat(data(:,adjust_col));
    
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
%         Team_Matrix = Team_Matrix(1:2*55,:);
%         Score_For = Score_For(1:2*55,:);
%         Score_Against = Score_Against(1:2*55,:);

% solve Team_Matrix*OPR = Score_For for OPR
% solve Team_Matrix*DPR = Score_Against for DPR
inv_team_matrix = pinv(Team_Matrix);
OPR = zeros(num_teams, size(Score_For,2));
DPR = zeros(size(OPR));
for k=1:size(Score_For,2)
    OPR(:,k)  = inv_team_matrix*Score_For(:,k);
    DPR(:,k)  = inv_team_matrix*Score_Against(:,k);
end





