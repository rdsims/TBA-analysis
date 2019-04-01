% get_match_differential_all_weeks

close all;
clear all;

filter = 'f';   % playoffs only

cols_to_use = 5:10;

for week = 0:4
    directory = sprintf('data/week%d', week);
    
    events = dir(sprintf('%s/*.csv', directory));
    
    match_differential = [];
    for event = events'
        file = sprintf('%s/%s', directory, event.name);
        [cols, d] = get_match_differential(file, filter);
        match_differential = [match_differential; d];
    end
    
    if ~isempty(match_differential)
        num_matches = size(match_differential,1);
        pct_difference_maker(week+1,:) = 100 * sum(match_differential(:,cols_to_use)>0,1) / num_matches;
    end
end



figure;
bar(1:size(pct_difference_maker,2), pct_difference_maker.', 'hist');
set(gca,'xticklabel',cols(cols_to_use));
grid;
ylabel('Percentage of Matches');
title('Playoff Match Differentiators');
legend('Week 0', 'Week 1', 'Week 2', 'Week 3', 'Week 4', 'Week 5', 'Week 6', 'Houston', 'St. Louis', 'Location', 'NorthWest');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print -dpng plots/playoff_differentiators.png -r100;
