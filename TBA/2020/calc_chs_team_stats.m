% get_chs_team_stats

ccc;

font_size = 9;

chs_teams = get_chs_teams();

team_num = [];
OPR = [];
DPR = [];

for week = 0:1
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

% detailed OPR
DETAILED_TOTAL = 1;
DETAILED_AUTO_DRIVE  = 2;
DETAILED_AUTO_CELL_BOTTOM = 3;
DETAILED_AUTO_CELL_OUTER = 4;
DETAILED_AUTO_CELL_INNER = 5;
DETAILED_TELEOP_CELL_BOTTOM  = 6;
DETAILED_TELEOP_CELL_OUTER  = 7;
DETAILED_TELEOP_CELL_INNER  = 8;
DETAILED_TELEOP_PANEL  = 5; 
DETAILED_ENDGAME_CLIMB = 6;
DETAILED_ENDGAME_LEVEL = 7;
DETAILED_FOUL  = 8;

% summary OPR
TOTAL = 1;
AUTO  = 2;
TELEOP_CELL  = 4;
TELEOP_PANEL  = 5; 
ENDGAME_CLIMB = 6;
ENDGAME_LEVEL = 7;
FOUL  = 8;

detailedOPR = OPR;
detailedDPR = DPR;
OPR(:,AUTO) = sum(detailedOPR(:,DETAILED_AUTO_DRIVE:DETAILED_AUTO_CELL_INNER),2);
OPR(:,TELEOP_CELL) = sum(detailedOPR(:,DETAILED_TELEOP_CELL_BOTTOM:DETAILED_TELEOP_CELL_INNER),2);
OPR(:,TELEOP_PANEL:FOUL) = detailedOPR(:,DETAILED_TELEOP_PANEL:DETAILED_FOUL);

chs_team_idx = ismember(team_num, chs_teams);
team_num = team_num(chs_team_idx).';
team_686_idx = find(team_num == 686);

OPR = OPR(chs_team_idx,:);
DPR = DPR(chs_team_idx,:);

% OPR(OPR<0) = 0; % remove negative numbers that mess up stacked bar plots

[~, sort_idx] = sort(OPR(:,TOTAL),1,'ascend');
sorted_OPR = OPR(sort_idx,:);
sorted_team_num = team_num(sort_idx);
team_686_sorted_idx = find(sorted_team_num == 686);

figure;
plot(team_num, OPR(:,TOTAL), '.b');
hold on;
plot(team_num(team_686_idx), OPR(team_686_idx,:), 'or');
hold off;
grid on;
xlabel('Team Number');
ylabel('OPR');
title('Chesapeake District Teams');


figure;
bar(1:length(team_num), sorted_OPR(:,[ENDGAME_CLIMB TELEOP_CELL AUTO_CELL AUTO_DRIVE ENDGAME_LEVEL TELEOP_PANEL FOUL]), 'stacked');
grid on;
ylabel('OPR');
title('Chesapeake District Teams');
legend('Climb', 'TeleopCell', 'AutoCell', 'AutoDrive', 'LevelClimb', 'ControlPanel', 'Foul', 'Location', 'NorthWest');
for k=1:length(team_num)
    h = text(k,sorted_OPR(k)+1,num2str(sorted_team_num(k),'%d'),...
        'Rotation',90,'HorizontalAlignment','Left','VerticalAlignment','Middle','FontSize',font_size);
    if (sorted_team_num(k) == 686)
        h = text(k,0,num2str(sorted_team_num(k),'%d'),...
            'Rotation',90,'HorizontalAlignment','Right','VerticalAlignment','Middle','FontSize',font_size);
        set(h,'Color','r');
    end
end
xlim([0 length(team_num)+1]);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print -dpng plots/chs_opr_bar.png -r100;


figure;
subplot(211);
[x,i] = sort(OPR(:,AUTO));
bar(1:length(team_num), x);
% grid on;
ylabel('Auto OPR');
title('Chesapeake District Teams');
for k=1:length(team_num)
    h = text(k,x(k)+1,num2str(team_num(i(k)),'%d'),...
        'Rotation',90,'HorizontalAlignment','Left','VerticalAlignment','Middle','FontSize',font_size);
    if (team_num(i(k)) == 686)
        h = text(k,0,num2str(team_num(i(k)),'%d'),...
            'Rotation',90,'HorizontalAlignment','Right','VerticalAlignment','Middle','FontSize',font_size);
        set(h,'Color','r');
    end
end
xlim([0 length(team_num)+1]);
ylim([-5 15]);

subplot(212);
[x,i] = sort(OPR(:,ENDGAME));
bar(1:length(team_num), x);
% grid on;
ylabel('Endgame OPR');
for k=1:length(team_num)
    h = text(k,x(k)+1,num2str(team_num(i(k)),'%d'),...
        'Rotation',90,'HorizontalAlignment','Left','VerticalAlignment','Middle','FontSize',font_size);
    if (team_num(i(k)) == 686)
        h = text(k,0,num2str(team_num(i(k)),'%d'),...
            'Rotation',90,'HorizontalAlignment','Right','VerticalAlignment','Middle','FontSize',font_size);
        set(h,'Color','r');
    end
end
xlim([0 length(team_num)+1]);
ylim([-5 20]);

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print -dpng plots/chs_opr_bkdn_1.png -r100;



figure;
subplot(211);
[x,i] = sort(OPR(:,PANEL));
bar(1:length(team_num), x);
% grid on;
ylabel('Control Panel OPR');
for k=1:length(team_num)
    h = text(k,x(k)+1,num2str(team_num(i(k)),'%d'),...
        'Rotation',90,'HorizontalAlignment','Left','VerticalAlignment','Middle','FontSize',font_size);
    if (team_num(i(k)) == 686)
        h = text(k,0,num2str(team_num(i(k)),'%d'),...
            'Rotation',90,'HorizontalAlignment','Right','VerticalAlignment','Middle','FontSize',font_size);
        set(h,'Color','r');
    end
end
xlim([0 length(team_num)+1]);
ylim([-5 20]);

subplot(212);
[x,i] = sort(OPR(:,CELL));
bar(1:length(team_num), x);
% grid on;
ylabel('Teleop Cell OPR');
title('Chesapeake District Teams');
for k=1:length(team_num)
    h = text(k,x(k)+1,num2str(team_num(i(k)),'%d'),...
        'Rotation',90,'HorizontalAlignment','Left','VerticalAlignment','Middle','FontSize',font_size);
    if (team_num(i(k)) == 686)
        h = text(k,0,num2str(team_num(i(k)),'%d'),...
            'Rotation',90,'HorizontalAlignment','Right','VerticalAlignment','Middle','FontSize',font_size);
        set(h,'Color','r');
    end
end
xlim([0 length(team_num)+1]);
ylim([-5 20]);

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print -dpng plots/chs_opr_bkdn_2.png -r100;



figure;
subplot(211);
[x,i] = sort(OPR(:,FOUL));
bar(1:length(team_num), x);
% grid on;
ylabel('Foul OPR');
for k=1:length(team_num)
    h = text(k,x(k)+1,num2str(team_num(i(k)),'%d'),...
        'Rotation',90,'HorizontalAlignment','Left','VerticalAlignment','Middle','FontSize',font_size);
    if (team_num(i(k)) == 686)
        h = text(k,0,num2str(team_num(i(k)),'%d'),...
            'Rotation',90,'HorizontalAlignment','Right','VerticalAlignment','Middle','FontSize',font_size);
        set(h,'Color','r');
    end
end
xlim([0 length(team_num)+1]);
ylim([-5 10]);

subplot(212);
[x,i] = sort(OPR(:,ADJUST));
bar(1:length(team_num), x);
% grid on;
ylabel('Adjust OPR');
for k=1:length(team_num)
    h = text(k,x(k)+1,num2str(team_num(i(k)),'%d'),...
        'Rotation',90,'HorizontalAlignment','Left','VerticalAlignment','Middle','FontSize',font_size);
    if (team_num(i(k)) == 686)
        h = text(k,0,num2str(team_num(i(k)),'%d'),...
            'Rotation',90,'HorizontalAlignment','Right','VerticalAlignment','Middle','FontSize',font_size);
        set(h,'Color','r');
    end
end
xlim([0 length(team_num)+1]);
ylim([-5 10]);

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print -dpng plots/chs_opr_bkdn_3.png -r100;



figure;
plot(DPR(:,TOTAL), OPR(:,TOTAL), '.');
grid on;
xlabel('DPR');
ylabel('OPR');
axis square;
hold on;
line([-1000 1000], [-1000 1000], 'color', 'k', 'linestyle', '--');
plot(DPR(team_686_idx), OPR(team_686_idx), 'ro');
hold off;
title('Chesapeake District Teams');
for k=1:length(team_num)
    h = text(DPR(k,TOTAL)+0.5,OPR(k,TOTAL)+0.5,num2str(team_num(k),'%d'),...
        'Rotation',45,'HorizontalAlignment','Left','VerticalAlignment','Middle','FontSize',font_size);
end
h = text(DPR(team_686_idx,TOTAL)+0.5,OPR(team_686_idx,TOTAL)+0.5,num2str(team_num(team_686_idx),'%d'),...
    'Rotation',45,'HorizontalAlignment','Left','VerticalAlignment','Middle','FontSize',font_size,...
    'Color','r');
xlim([0 20*ceil(max(DPR(:,TOTAL))/20)]);
ylim([0 20*ceil(max(OPR(:,TOTAL))/20)]);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print -dpng plots/chs_opr_dpr.png -r100;





figure;
for col = TOTAL:FOUL
    if col == TOTAL
        edges = -10:50;
    else
        edges = -10:50;
    end
    subplot(FOUL,1,col);
    n = histc(OPR(:,col),edges);
    bar(edges,n);
    if ~isempty(team_686_idx)
        hold on;
        line([1 1]*OPR(team_686_idx,col), [0 max(n)], 'Color','red', 'LineStyle','--', 'LineWidth',3);
        h = text(OPR(team_686_idx,col),0,'686',...
            'Rotation',90,'HorizontalAlignment','Right','VerticalAlignment',...
            'Middle','FontSize',font_size, 'Color', 'r');
        hold off;
    end
    xlim([edges(1) edges(end)]);
    ylabel(stat_cols(col));
    grid on;
    if col==1
        title('OPR Distribution, CHS Teams, Latest Event');
    end
end
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print -dpng plots/chs_opr_dist.png -r100;

figure;
for col = TOTAL:FOUL
    if col == TOTAL
        edges = -10:50;
    else
        edges = -10:50;
    end
    subplot(FOUL,1,col);
    n = histc(DPR(:,col),edges);
    bar(edges,n);
    if ~isempty(team_686_idx)
        hold on;
        line([1 1]*DPR(team_686_idx,col), [0 max(n)], 'Color','red', 'LineStyle','--', 'LineWidth',3);
        h = text(DPR(team_686_idx,col),0,'686',...
            'Rotation',90,'HorizontalAlignment','Right','VerticalAlignment',...
            'Middle','FontSize',font_size, 'Color', 'r');
        hold off;
    end
    xlim([edges(1) edges(end)]);
    ylabel(stat_cols(col));
    grid on;
    if col==1
        title('DPR Distribution, CHS Teams, Latest Event');
    end
end
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print -dpng plots/chs_dpr_dist.png -r100;

CCWM = OPR - DPR;

figure;
for col = TOTAL:FOUL
    if col == TOTAL
        edges = -50:2:50;
    else
        edges = -50:2:50;
    end
    subplot(FOUL,1,col);
    n = histc(CCWM(:,col),edges);
    bar(edges,n);
    if ~isempty(team_686_idx)
        hold on;
        line([1 1]*CCWM(team_686_idx,col), [0 max(n)], 'Color','red', 'LineStyle','--', 'LineWidth',3);
        h = text(CCWM(team_686_idx,col),0,'686',...
            'Rotation',90,'HorizontalAlignment','Right','VerticalAlignment',...
            'Middle','FontSize',font_size, 'Color', 'r');
        hold off;
    end
    xlim([edges(1) edges(end)]);
    ylabel(stat_cols(col));
    grid on;
    if col==1
        title('CCWM Distribution, CHS Teams, Latest Event');
    end
end
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print -dpng plots/chs_ccwm_dist.png -r100;
