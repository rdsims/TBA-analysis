function create_random_event(filename, team_nums)

% create an event with random teams, with each match containing only unique
% team numbers

N = numel(team_nums);
K = 6;  % select 6 teams at a time

num_matches = 2*N;

num_perms = num_matches*K/N;

team_idx_matrix = [];
for p = 1:num_perms
    team_idx_matrix = [team_idx_matrix randperm(N)]; %#ok<AGROW>
end
team_idx_matrix = reshape(team_idx_matrix,K,num_matches).';

match = zeros(2*num_matches,1);
comp = cell(2*num_matches,1);
alliance = cell(2*num_matches,1);
team1 = zeros(2*num_matches,1);
team2 = zeros(2*num_matches,1);
team3 = zeros(2*num_matches,1);


% red alliance
idx = (1:2:2*num_matches)';
match(idx) = 1:num_matches;
comp(idx) = {'qm'};
alliance(idx) = {'red'};
team1(idx) = team_nums(team_idx_matrix(:,1));
team2(idx) = team_nums(team_idx_matrix(:,2));
team3(idx) = team_nums(team_idx_matrix(:,3));

% blue alliance
idx = (2:2:2*num_matches)';
match(idx) = 1:num_matches;
comp(idx) = {'qm'};
alliance(idx) = {'blue'};
team1(idx) = team_nums(team_idx_matrix(:,4));
team2(idx) = team_nums(team_idx_matrix(:,5));
team3(idx) = team_nums(team_idx_matrix(:,6));

T = table(match, comp, alliance, team1, team2, team3);
writetable(T, filename);