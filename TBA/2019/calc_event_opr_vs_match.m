% calc_event_opr_vs_match

close all;
clear all;



% directory = 'data/week0';   event_name = '2019vahay';
% directory = 'data/week0';   event_name = '2019vagle';
directory = 'data/week1';   event_name = '2019mdbet';
% directory = 'data/week2';   event_name = '2019vapor';
% directory = 'data/week2';   event_name = '2019mdowi';
% directory = 'data/week3';   event_name = '2019mdoxo';
% directory = 'data/week4';   event_name = '2019vabla';
% directory = 'data/week5';   event_name = '2019chcmp';

font_size = 16;

filename = sprintf('%s/%s.csv', directory, event_name);
[team_num, stat_cols, OPR, DPR] = get_event_team_stats_vs_match(filename);
all_events = get_event_names();
title_str = 'Unknown Event';
for k=1:length(all_events)
    if strcmp(all_events(k).key, event_name)
        title_str = all_events(k).name;
        k = strfind(title_str,' sponsored');
        if k>0
            title_str = title_str(1:k);
        end
    end
end
       

% sort
[team_num, idx] = sort(team_num);
OPR = OPR(:,idx,:);
DPR = DPR(:,idx,:);

team_686_idx = find(team_num == 686);

TOTAL = 1;
AUTO  = 2;
CARGO  = 3;
PANEL  = 4;
CLIMB = 5;
FOUL  = 6;
ADJUST  = 7;


matches = 1:size(OPR,1);

match_actual = zeros(12,1);
points_actual = zeros(12,ADJUST);

% Owings Mills
m = 1;
match_actual(m) = 1;
points_actual(m,:) = [0 3 0  9 12 0 0];
m = m+1;
match_actual(m) = 10;
points_actual(m,:) = [0 3 2  6  0 24/3 0];
m = m+1;
match_actual(m) = 13;
points_actual(m,:) = [0 3 2  0  0 3/3 0];
m = m+1;
match_actual(m) = 22;
points_actual(m,:) = [0 3 4 12  0 0 0];
m = m+1;
match_actual(m) = 26;
points_actual(m,:) = [0 3 0 12  0 0 0];
m = m+1;
match_actual(m) = 31;
points_actual(m,:) = [0 3 0  9  0 6/3 0];
m = m+1;
match_actual(m) = 39;
points_actual(m,:) = [0 3 4  6 12 6/3 0];
m = m+1;
match_actual(m) = 44;
points_actual(m,:) = [0 3 4  3 12 0 0];
m = m+1;
match_actual(m) = 53;
points_actual(m,:) = [0 3 0  9  6 0 0];
m = m+1;
match_actual(m) = 56;
points_actual(m,:) = [0 3 2 12  0 0 0];
m = m+1;
match_actual(m) = 61;
points_actual(m,:) = [0 3 2  9  0 0 0];
m = m+1;
match_actual(m) = 67;
points_actual(m,:) = [0 3 0  9 12 0 0];

points_actual(:,TOTAL) = sum(points_actual(:,AUTO:ADJUST),2);
points_average = zeros(numel(matches),ADJUST);
for m=1:matches(end)
    mi = find(m==match_actual,1,'first');
    if ~isempty(mi)
        points_average(m,:) = sum(points_actual(1:mi,:),1) / mi;
    else
        if m>1
            points_average(m,:) = points_average(m-1,:);
        end
    end
end


figure;
plot(matches,OPR(:,team_686_idx,1));
hold on;
stem(match_actual,points_actual(:,TOTAL),'r');
plot(matches,points_average(:,TOTAL),'--r')
hold off;
xlabel('Qualification Match #');
ylabel('Points Scored / OPR');
title(sprintf('Team 686 Points & OPR vs Match\nBethesda Event 2019'));
grid on;
legend('OPR','Actual Match Points','Average Match Points','Location','NorthEast');

figure;
plot(matches,OPR(:,:,1));
xlabel('Qualification Match #');
ylabel('OPR');
title(sprintf('OPR vs Match\nBethesda Event 2019'));
grid on;
% legend('OPR','Actual Match Points','Average Match Points','Location','NorthEast');




% directory = 'data/week0';   event_name = '2019vahay';
% directory = 'data/week0';   event_name = '2019vagle';
% directory = 'data/week1';   event_name = '2019mdbet';
% directory = 'data/week2';   event_name = '2019vapor';
directory = 'data/week2';   event_name = '2019mdowi';
% directory = 'data/week3';   event_name = '2019mdoxo';
% directory = 'data/week4';   event_name = '2019vabla';
% directory = 'data/week5';   event_name = '2019chcmp';

font_size = 16;

filename = sprintf('%s/%s.csv', directory, event_name);
[team_num, stat_cols, OPR, DPR] = get_event_team_stats_vs_match(filename);
all_events = get_event_names();
title_str = 'Unknown Event';
for k=1:length(all_events)
    if strcmp(all_events(k).key, event_name)
        title_str = all_events(k).name;
        k = strfind(title_str,' sponsored');
        if k>0
            title_str = title_str(1:k);
        end
    end
end
       

% sort
[team_num, idx] = sort(team_num);
OPR = OPR(:,idx,:);
DPR = DPR(:,idx,:);

team_686_idx = find(team_num == 686);

TOTAL = 1;
AUTO  = 2;
CARGO  = 3;
PANEL  = 4;
CLIMB = 5;
FOUL  = 6;
ADJUST  = 7;


matches = 1:size(OPR,1);

match_actual = zeros(12,1);
points_actual = zeros(12,ADJUST);

% Owings Mills
m = 1;
match_actual(m) = 3;
points_actual(m,:) = [0 3 2  9 12 3/3 0];
m = m+1;
match_actual(m) = 9;
points_actual(m,:) = [0 3 4 12 12 0 0];
m = m+1;
match_actual(m) = 16;
points_actual(m,:) = [0 3 2 12  3 0 0];
m = m+1;
match_actual(m) = 21;
points_actual(m,:) = [0 3 2 12 12 16/3 0];
m = m+1;
match_actual(m) = 30;
points_actual(m,:) = [0 3 0 15  6 0 0];
m = m+1;
match_actual(m) = 35;
points_actual(m,:) = [0 3 0  9  0 0 0];
m = m+1;
match_actual(m) = 40;
points_actual(m,:) = [0 3 0  6 12 10/3 0];
m = m+1;
match_actual(m) = 50;
points_actual(m,:) = [0 3 2 12 12 0 0];
m = m+1;
match_actual(m) = 56;
points_actual(m,:) = [0 3 2  6 12 10/3 0];
m = m+1;
match_actual(m) = 61;
points_actual(m,:) = [0 3 2 15 12 0 0];
m = m+1;
match_actual(m) = 67;
points_actual(m,:) = [0 3 2  3  0 0 0];
m = m+1;
match_actual(m) = 75;
points_actual(m,:) = [0 3 2 15  3 6/3 0];

points_actual(:,TOTAL) = sum(points_actual(:,AUTO:ADJUST),2);
points_average = zeros(numel(matches),ADJUST);
for m=1:matches(end)
    mi = find(m==match_actual,1,'first');
    if ~isempty(mi)
        points_average(m,:) = sum(points_actual(1:mi,:),1) / mi;
    else
        if m>1
            points_average(m,:) = points_average(m-1,:);
        end
    end
end


figure;
plot(matches,OPR(:,team_686_idx,1));
hold on;
stem(match_actual,points_actual(:,TOTAL),'r');
plot(matches,points_average(:,TOTAL),'--r')
hold off;
xlabel('Qualification Match #');
ylabel('Points Scored / OPR');
title(sprintf('Team 686 Points & OPR vs Match\nMcDonogh Event 2019'));
grid on;
legend('OPR','Actual Match Points','Average Match Points','Location','NorthEast');

figure;
plot(matches,OPR(:,:,1));
xlabel('Qualification Match #');
ylabel('OPR');
title(sprintf('OPR vs Match\nMcDonogh Event 2019'));
grid on;
% legend('OPR','Actual Match Points','Average Match Points','Location','NorthEast');
