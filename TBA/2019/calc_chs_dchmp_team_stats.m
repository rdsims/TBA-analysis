% get_chs_dchmp_team_stats

close all;
clear all;

font_size = 9;

dchmp_teams = get_chs_dchmp_teams();
[team_num, stat_cols, OPR, DPR] = get_previous_event_team_stats(dchmp_teams);


TOTAL = 1;
AUTO  = 2;
CARGO  = 3;
PANEL  = 4;
CLIMB = 5;
FOUL  = 6;
ADJUST  = 7;


chs_dchmp_team_idx = ismember(team_num, dchmp_teams);
team_num = team_num(chs_dchmp_team_idx).';
team_686_idx = find(team_num == 686);

OPR = OPR(chs_dchmp_team_idx,:);
DPR = DPR(chs_dchmp_team_idx,:);

% OPR(OPR<0) = 0; % remove negative numbers that mess up stacked bar plots

% [~, sort_idx] = sort(OPR(:,TOTAL),1,'descend');
[~, sort_idx] = sort(sum(OPR(:,AUTO:CLIMB),2),1,'descend');
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
title('CHS District Championship Teams');


figure;
bar(1:length(team_num), sorted_OPR(:,[CLIMB CARGO PANEL AUTO FOUL ADJUST]), 'stacked');
grid on;
ylabel('OPR');
title('CHS District Championship Teams');
legend('Climb', 'Cargo', 'Panel', 'Auto', 'Foul', 'Adjust', 'Location', 'NorthEast');
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
print -dpng plots/chs_dchmp_opr_bar.png -r100;


figure;
subplot(211);
[x,i] = sort(OPR(:,AUTO),1,'descend');
bar(1:length(team_num), x);
% grid on;
ylabel('Auto OPR');
title('CHS District Championship Teams');
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
[x,i] = sort(OPR(:,CLIMB),1,'descend');
bar(1:length(team_num), x);
% grid on;
ylabel('Climb OPR');
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
print -dpng plots/chs_dchmp_opr_bkdn_1.png -r100;



figure;
subplot(211);
[x,i] = sort(OPR(:,PANEL),1,'descend');
bar(1:length(team_num), x);
% grid on;
ylabel('Panel OPR');
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
[x,i] = sort(OPR(:,CARGO),1,'descend');
bar(1:length(team_num), x);
% grid on;
ylabel('Cargo OPR');
title('CHS District Championship Teams');
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
print -dpng plots/chs_dchmp_opr_bkdn_2.png -r100;



figure;
subplot(211);
[x,i] = sort(OPR(:,FOUL),1,'descend');
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
[x,i] = sort(OPR(:,ADJUST),1,'descend');
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
print -dpng plots/chs_dchmp_opr_bkdn_3.png -r100;



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
title('CHS District Championship Teams');
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
print -dpng plots/chs_dchmp_opr_dpr.png -r100;





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
        title('OPR Distribution, CHS DCHMP Teams, Latest Event');
    end
end
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print -dpng plots/chs_dchmp_opr_dist.png -r100;

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
        title('DPR Distribution, CHS DCHMP Teams, Latest Event');
    end
end
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print -dpng plots/chs_dchmp_dpr_dist.png -r100;

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
        title('CCWM Distribution, CHS DCHMP Teams, Latest Event');
    end
end
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print -dpng plots/chs_dchmp_ccwm_dist.png -r100;
