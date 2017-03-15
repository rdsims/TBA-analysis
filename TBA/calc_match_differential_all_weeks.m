% get_match_differential_all_weeks

ccc;

filter = 'f';   % playoffs only

for week = 0:7
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
        pct_difference_maker = 100 * sum(match_differential(:,2:end)>0,1) / num_matches;

        figure;
        barh(1:length(pct_difference_maker), pct_difference_maker);
        set(gca,'yticklabel',cols(2:end));
        grid;
        xlabel('Percentage of Matches');
        title(sprintf('Week %d Playoff Match Differentiators', week));
    end
end