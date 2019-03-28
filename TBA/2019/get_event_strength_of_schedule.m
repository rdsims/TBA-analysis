function SoS = get_event_strength_of_schedule(team_num, OPR, Team_Matrix)

% Calculate Strength of Schedule based on OPR (post-event calculation)

TOTAL = 1;
AUTO  = 2;
CARGO  = 3;
PANEL  = 4;
CLIMB = 5;
FOUL  = 6;
ADJUST  = 7;

% remove fouls from SoS calculation
sosOPR(:,TOTAL) = OPR(:,TOTAL) - OPR(:,FOUL);

num_teams = size(OPR,1);
SoS = zeros(num_teams,1);

for team_idx=1:num_teams
    SoS(team_idx) = 0;
    % find all matches this team played in
    [team_match_idx,~] = find(Team_Matrix == team_num(team_idx));
    % sum opponents OPR - alliance partner OPR
    % need to figure out red/blue alliances first
    for m = 1:numel(team_match_idx)
        match_idx = team_match_idx(m);
        [~,our_alliance_teams] = ismember(Team_Matrix(match_idx,:), team_num);
        if mod(match_idx,2) == 1
            [~,opp_alliance_teams] = ismember(Team_Matrix(match_idx+1,:), team_num);
        else
            [~,opp_alliance_teams] = ismember(Team_Matrix(match_idx-1,:), team_num);
        end    
        our_opr = sum(sosOPR(our_alliance_teams,TOTAL));
        opp_opr = sum(sosOPR(opp_alliance_teams,TOTAL));
        SoS(team_idx) = SoS(team_idx) + our_opr - sosOPR(team_idx,TOTAL) - opp_opr;
    end
    % calc average
    SoS(team_idx) = SoS(team_idx) / numel(team_match_idx);
end
SoS = SoS - mean(SoS);