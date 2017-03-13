% get_team_stats_all_weeks

ccc;

team_num = [];
OPR = [];
DPR = [];

for week = 0:7
    directory = sprintf('data/week%d', week);
    
    events = dir(sprintf('%s/*.csv', directory));
    
    for event = events'
        filename = sprintf('%s/%s', directory, event.name);
        [event_team_num, stat_cols, event_OPR, event_DPR] = get_event_team_stats(filename);
        
        for k = 1:length(event_team_num)
            idx = find(event_team_num(k) == team_num, 1, 'first');
            if isempty(idx)
                % first event, add to table
                team_num(end+1) = event_team_num(k);
                OPR(end+1,:) = event_OPR(k,:);
                DPR(end+1,:) = event_DPR(k,:);
            else
                % >= 2nd event, update stats with latest event
                OPR(idx,:) = event_OPR(k,:);
                DPR(idx,:) = event_DPR(k,:);
            end
        end
        
        % sort
        [team_num, idx] = sort(team_num);
        OPR = OPR(idx,:);
        DPR = DPR(idx,:);
    end
end

TOTAL = 1;
AUTO  = 2;
FUEL  = 3;
GEAR  = 4;
CLIMB = 5;
FOUL  = 6;

[~, sort_idx] = sort(OPR(:,TOTAL),1,'ascend');
sorted_OPR = OPR(sort_idx,:);
sorted_team_num = team_num(sort_idx);

team_686_idx = find(team_num == 686);
team_686_sorted_idx = find(sorted_team_num == 686);




% plots
figure;
plot(team_num, OPR, '.b');
hold on;
plot(team_num(team_686_idx), OPR(team_686_idx,:), 'or');
hold off;
grid on;
xlabel('Team Number');
ylabel('OPR');

percentile = (1:length(team_num)).' / length(team_num) * 100;

figure;
plot(percentile, sorted_OPR, '.b');
hold on;
plot(percentile(team_686_sorted_idx), sorted_OPR(team_686_sorted_idx,:), 'or');
hold off;
grid on;
xlabel('Percentile');
ylabel('OPR');

figure;
for col = TOTAL:FOUL
    if col == TOTAL
        edges = -50:2:200;
    else
        edges = -25:100;
    end
    subplot(FOUL,1,col);
    n = histc(OPR(:,col),edges) / size(OPR,1);
    bar(edges,n);
    hold on;
    [~,bin] = min(edges - OPR(team_686_idx,col));
    line([1 1]*OPR(team_686_idx,col), [0 max(n)], 'Color','red', 'LineStyle','--', 'LineWidth',3);
    hold off;
    xlim([edges(1) edges(end)]);
    ylabel(stat_cols(col));
    grid on;
    if col==1
        title('OPR Distribution, All Teams, Latest Match');
    end
end

figure;
for col = TOTAL:FOUL
    if col == TOTAL
        edges = -50:2:200;
    else
        edges = -25:100;
    end
    subplot(FOUL,1,col);
    n = histc(DPR(:,col),edges) / size(DPR,1);
    bar(edges,n);
    hold on;
    [~,bin] = min(edges - DPR(team_686_idx,col));
    line([1 1]*DPR(team_686_idx,col), [0 max(n)], 'Color','red', 'LineStyle','--', 'LineWidth',3);
    hold off;
    xlim([edges(1) edges(end)]);
    ylabel(stat_cols(col));
    grid on;
    if col==1
        title('DPR Distribution, All Teams, Latest Match');
    end
end

CCWM = OPR - DPR;

figure;
for col = TOTAL:FOUL
    if col == TOTAL
        edges = -125:2:125;
    else
        edges = -100:2:100;
    end
    subplot(FOUL,1,col);
    n = histc(CCWM(:,col),edges)  / size(CCWM,1);
    bar(edges,n);
    hold on;
    [~,bin] = min(edges - CCWM(team_686_idx,col));
    line([1 1]*CCWM(team_686_idx,col), [0 max(n)], 'Color','red', 'LineStyle','--', 'LineWidth',3);
    hold off;
    xlim([edges(1) edges(end)]);
    ylabel(stat_cols(col));
    grid on;
    if col==1
        title('CCWM Distribution, All Teams, Latest Match');
    end
end