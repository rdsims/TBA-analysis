% calc_chs_dchmp_predictions

% District Champ match predictions based solely on previous event OPR

close all;
clear all;

font_size = 9;

TOTAL = 1;
AUTO  = 2;
CARGO  = 3;
PANEL  = 4;
CLIMB = 5;
FOUL  = 6;
ADJUST  = 7;

title_str = 'CHS District Champs Predictions';

if exist('test.mat', 'file')
    load('test.mat');
else

    dchmp_teams = get_chs_dchmp_teams();
    [team_num, stat_cols, OPR, DPR] = get_previous_event_team_stats(dchmp_teams);

    % remove foul OPR and adjust TOTAL OPR
    OPR(:,FOUL) = 0;
    OPR(:,ADJUST) = 0;
    OPR(:,TOTAL) = sum(OPR(:,AUTO:CLIMB),2);

    save('test.mat','team_num', 'OPR');
end


week = 5;
event_name = '2019chcmp.csv';
filename = sprintf('data/week%d/%s', week, event_name);

[team_matrix, match_scores, team_record, team_RPs, SoS] = get_event_predictions(filename, team_num, OPR);





WIN = 1;
LOSS = 2;
TIE = 3;
BONUS = 4;

team_RPs = [2*team_record(:,WIN) 1*team_record(:,TIE) 1*team_record(:,BONUS)];
[~, sort_idx] = sort(sum(team_RPs,2),'descend');
sorted_team_RPs = team_RPs(sort_idx,:);
sorted_team_num = team_num(sort_idx);
team_686_sorted_idx = find(sorted_team_num == 686);

figure;
bar(1:length(team_num), sorted_team_RPs, 'stacked');
grid on;
ylabel('Ranking Point Estimate (Qualifications)');
title(title_str);
legend('Wins', 'Ties', 'Climbs', 'Location', 'NorthEast');
for k=1:length(team_num)
    h = text(k,sum(sorted_team_RPs(k,:))+1,num2str(sorted_team_num(k),'%d'),...
        'Rotation',90,'HorizontalAlignment','Left','VerticalAlignment','Middle','FontSize',font_size);
    if (sorted_team_num(k) == 686)
        h = text(k,0,num2str(sorted_team_num(k),'%d'),...
            'Rotation',90,'HorizontalAlignment','Right','VerticalAlignment','Middle','FontSize',font_size);
        set(h,'Color','r');
    end
end
xlim([0 length(team_num)+1]);




% Strength of Schedule Plots

[~, sort_idx] = sort(SoS(:,TOTAL),1,'descend');
sorted_SoS = SoS(sort_idx,:);
sorted_team_num = team_num(sort_idx);
team_686_sorted_idx = find(sorted_team_num == 686);

figure;
bar(1:length(team_num), sorted_SoS);
grid on;
ylabel('Average Extra OPR due to Schedule');
title(title_str);
for k=1:length(team_num)
    if  (sorted_SoS(k) > 0)
        h = text(k,sorted_SoS(k)+0.25,num2str(sorted_team_num(k),'%d'),...
            'Rotation',90,'HorizontalAlignment','Left','VerticalAlignment','Middle','FontSize',font_size);
    else
        h = text(k,sorted_SoS(k)-0.25,num2str(sorted_team_num(k),'%d'),...
            'Rotation',90,'HorizontalAlignment','Right','VerticalAlignment','Middle','FontSize',font_size);
    end
    if (sorted_team_num(k) == 686)
        set(h,'Color','r');
    end
end
xlim([0 length(team_num)+1]);
ylim([floor(min(SoS)-1) ceil(max(SoS)+1)]);





% 686 Match Predictions
team_filter = 686;
matches_per_sheet = 6;
plot_match_predictions(team_matrix, team_num, OPR, team_filter, matches_per_sheet);

% All Match Predictions
team_filter = [];
matches_per_sheet = 6;
plot_match_predictions(team_matrix, team_num, OPR, team_filter, matches_per_sheet);

