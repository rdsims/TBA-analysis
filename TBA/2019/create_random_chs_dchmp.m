team_nums = get_chs_dchmp_teams();

week = 5;
event_name = '2019chcmp.csv';
filename = sprintf('data/week%d/%s', week, event_name);

create_random_event(filename, team_nums)
