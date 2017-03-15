% get_team_stats_all_weeks

ccc;

font_size = 10;

chs_teams = get_chs_teams();

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
plot(team_num, OPR(:,TOTAL), '.b');
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
    n = histc(OPR(:,col),edges);
    bar(edges,n);
    hold on;
    line([1 1]*OPR(team_686_idx,col), [0 max(n)], 'Color','red', 'LineStyle','--', 'LineWidth',3);
    hold off;
    xlim([edges(1) edges(end)]);
    ylabel(stat_cols(col));
    grid on;
    if col==1
        title('OPR Distribution, All Teams, Latest Match');
    end
end
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print -dpng plots/all_teams_opr.png -r100;

figure;
for col = TOTAL:FOUL
    if col == TOTAL
        edges = -50:2:200;
    else
        edges = -25:100;
    end
    subplot(FOUL,1,col);
    n = histc(DPR(:,col),edges);
    bar(edges,n);
    hold on;
    line([1 1]*DPR(team_686_idx,col), [0 max(n)], 'Color','red', 'LineStyle','--', 'LineWidth',3);
    hold off;
    xlim([edges(1) edges(end)]);
    ylabel(stat_cols(col));
    grid on;
    if col==1
        title('DPR Distribution, All Teams, Latest Match');
    end
end
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print -dpng plots/all_teams_dpr.png -r100;

CCWM = OPR - DPR;

figure;
for col = TOTAL:FOUL
    if col == TOTAL
        edges = -125:2:125;
    else
        edges = -100:2:100;
    end
    subplot(FOUL,1,col);
    n = histc(CCWM(:,col),edges);
    bar(edges,n);
    hold on;
    line([1 1]*CCWM(team_686_idx,col), [0 max(n)], 'Color','red', 'LineStyle','--', 'LineWidth',3);
    hold off;
    xlim([edges(1) edges(end)]);
    ylabel(stat_cols(col));
    grid on;
    if col==1
        title('CCWM Distribution, All Teams, Latest Match');
    end
end
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print -dpng plots/all_teams_ccwm.png -r100;






chs_team_idx = ismember(team_num, chs_teams);
chs_team_num = team_num(chs_team_idx).';
team_686_chs_idx = find(chs_team_num == 686);

chs_OPR = OPR(chs_team_idx,:);
chs_DPR = DPR(chs_team_idx,:);

% chs_OPR(chs_OPR<0) = 0; % remove negative numbers that mess up stacked bar plots

[~, sort_idx] = sort(chs_OPR(:,TOTAL),1,'ascend');
sorted_chs_OPR = chs_OPR(sort_idx,:);
sorted_chs_team_num = chs_team_num(sort_idx);
team_686_sorted_chs_idx = find(sorted_chs_team_num == 686);

figure;
plot(chs_team_num, OPR(chs_team_idx,TOTAL), '.b');
hold on;
plot(chs_team_num(team_686_chs_idx), chs_OPR(team_686_chs_idx,:), 'or');
hold off;
grid on;
xlabel('Team Number');
ylabel('OPR');
title('Chesapeake District Teams');


figure;
bar(1:length(chs_team_num), sorted_chs_OPR(:,[AUTO GEAR FOUL CLIMB FUEL]), 'stacked');
grid on;
ylabel('OPR');
title('Chesapeake District Teams');
legend('Auto', 'Gear', 'Foul', 'Climb', 'Fuel', 'Location', 'NorthWest');
for k=1:length(chs_team_num)
    h = text(k,sorted_chs_OPR(k)+1,num2str(sorted_chs_team_num(k),'%d'),...
        'Rotation',90,'HorizontalAlignment','Left','VerticalAlignment','Middle','FontSize',font_size);
    if (sorted_chs_team_num(k) == 686)
        set(h,'Color','r');
    end
end
xlim([0 length(chs_team_num)+1]);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print -dpng plots/chs_opr_bar.png -r100;


figure;
subplot(311);
[x,i] = sort(chs_OPR(:,AUTO));
bar(1:length(chs_team_num), x);
% grid on;
ylabel('Auto OPR');
title('Chesapeake District Teams');
for k=1:length(chs_team_num)
    h = text(k,x(k)+1,num2str(chs_team_num(i(k)),'%d'),...
        'Rotation',90,'HorizontalAlignment','Left','VerticalAlignment','Middle','FontSize',font_size);
    if (chs_team_num(i(k)) == 686)
        set(h,'Color','r');
    end
end
xlim([0 length(chs_team_num)+1]);
ylim([-5 20]);

subplot(312);
[x,i] = sort(chs_OPR(:,FOUL));
bar(1:length(chs_team_num), x);
% grid on;
ylabel('Foul OPR');
for k=1:length(chs_team_num)
    h = text(k,x(k)+1,num2str(chs_team_num(i(k)),'%d'),...
        'Rotation',90,'HorizontalAlignment','Left','VerticalAlignment','Middle','FontSize',font_size);
    if (chs_team_num(i(k)) == 686)
        set(h,'Color','r');
    end
end
xlim([0 length(chs_team_num)+1]);
ylim([-10 50]);

subplot(313);
[x,i] = sort(chs_OPR(:,FUEL));
bar(1:length(chs_team_num), x);
% grid on;
ylabel('Fuel OPR');
for k=1:length(chs_team_num)
    h = text(k,x(k)+1,num2str(chs_team_num(i(k)),'%d'),...
        'Rotation',90,'HorizontalAlignment','Left','VerticalAlignment','Middle','FontSize',font_size);
    if (chs_team_num(i(k)) == 686)
        set(h,'Color','r');
    end
end
xlim([0 length(chs_team_num)+1]);
ylim([-5 30]);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print -dpng plots/chs_opr_bar2.png -r100;

figure;
subplot(211);
[x,i] = sort(chs_OPR(:,GEAR));
bar(1:length(chs_team_num), x);
% grid on;
ylabel('Gear OPR');
title('Chesapeake District Teams');
for k=1:length(chs_team_num)
    h = text(k,x(k)+1,num2str(chs_team_num(i(k)),'%d'),...
        'Rotation',90,'HorizontalAlignment','Left','VerticalAlignment','Middle','FontSize',font_size);
    if (chs_team_num(i(k)) == 686)
        set(h,'Color','r');
    end
end
xlim([0 length(chs_team_num)+1]);
ylim([-5 70]);

subplot(212);
[x,i] = sort(chs_OPR(:,CLIMB));
bar(1:length(chs_team_num), x);
% grid on;
ylabel('Climb OPR');
for k=1:length(chs_team_num)
    h = text(k,x(k)+1,num2str(chs_team_num(i(k)),'%d'),...
        'Rotation',90,'HorizontalAlignment','Left','VerticalAlignment','Middle','FontSize',font_size);
    if (chs_team_num(i(k)) == 686)
        set(h,'Color','r');
    end
end
xlim([0 length(chs_team_num)+1]);
ylim([-5 70]);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print -dpng plots/chs_opr_bar3.png -r100;





figure;
plot(chs_DPR(:,TOTAL), chs_OPR(:,TOTAL), '.');
grid on;
xlabel('DPR');
ylabel('OPR');
axis square;
hold on;
line([-1000 1000], [-1000 1000], 'color', 'k', 'linestyle', '--');
plot(chs_DPR(team_686_chs_idx), chs_OPR(team_686_chs_idx), 'ro');
hold off;
title('Chesapeake District Teams');
for k=1:length(chs_team_num)
    h = text(chs_DPR(k,TOTAL)+0.5,chs_OPR(k,TOTAL)+0.5,num2str(chs_team_num(k),'%d'),...
        'Rotation',45,'HorizontalAlignment','Left','VerticalAlignment','Middle','FontSize',font_size);
    if (chs_team_num(k) == 686)
        set(h,'Color','r');
    end
end
xlim([0 20*ceil(max(chs_DPR(:,TOTAL))/20)]);
ylim([0 20*ceil(max(chs_OPR(:,TOTAL))/20)]);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print -dpng plots/chs_opr_dpr.png -r100;





figure;
for col = TOTAL:FOUL
    if col == TOTAL
        edges = -50:2:200;
    else
        edges = -25:100;
    end
    subplot(FOUL,1,col);
    n = histc(chs_OPR(:,col),edges);
    bar(edges,n);
    hold on;
    line([1 1]*chs_OPR(team_686_chs_idx,col), [0 max(n)], 'Color','red', 'LineStyle','--', 'LineWidth',3);
    hold off;
    xlim([edges(1) edges(end)]);
    ylabel(stat_cols(col));
    grid on;
    if col==1
        title('OPR Distribution, CHS Teams, Latest Match');
    end
end
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print -dpng plots/chs_opr_dist.png -r100;

figure;
for col = TOTAL:FOUL
    if col == TOTAL
        edges = -50:2:200;
    else
        edges = -25:100;
    end
    subplot(FOUL,1,col);
    n = histc(chs_DPR(:,col),edges);
    bar(edges,n);
    hold on;
    line([1 1]*chs_DPR(team_686_chs_idx,col), [0 max(n)], 'Color','red', 'LineStyle','--', 'LineWidth',3);
    hold off;
    xlim([edges(1) edges(end)]);
    ylabel(stat_cols(col));
    grid on;
    if col==1
        title('DPR Distribution, CHS Teams, Latest Match');
    end
end
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print -dpng plots/chs_dpr_dist.png -r100;

chs_CCWM = chs_OPR - chs_DPR;

figure;
for col = TOTAL:FOUL
    if col == TOTAL
        edges = -125:2:125;
    else
        edges = -100:2:100;
    end
    subplot(FOUL,1,col);
    n = histc(chs_CCWM(:,col),edges);
    bar(edges,n);
    hold on;
    line([1 1]*chs_CCWM(team_686_chs_idx,col), [0 max(n)], 'Color','red', 'LineStyle','--', 'LineWidth',3);
    hold off;
    xlim([edges(1) edges(end)]);
    ylabel(stat_cols(col));
    grid on;
    if col==1
        title('CCWM Distribution, CHS Teams, Latest Match');
    end
end
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print -dpng plots/chs_ccwm_dist.png -r100;
