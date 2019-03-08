% get_event_team_stats

ccc;

% directory = 'data/week0';   event_name = '2017vahay';
% directory = 'data/week0';   event_name = '2017vabla';
% directory = 'data/week1';   event_name = '2017mdbet';
% directory = 'data/week2';   event_name = '2017mdowi';
% directory = 'data/week2';   event_name = '2017vapor';
% directory = 'data/week3';   event_name = '2017mdedg';
% directory = 'data/week3';   event_name = '2017vagle';
% directory = 'data/week5';   event_name = '2017chcmp';

font_size = 16;

filename = sprintf('%s/%s.csv', directory, event_name);
[team_num, stat_cols, OPR, DPR] = get_event_team_stats(filename);
all_events = get_event_names();
title_str = 'Unknown Event';
for k=1:length(all_events)
    if strcmp(all_events(k).key, event_name)
        title_str = all_events(k).name;
    end
end
       

% sort
[team_num, idx] = sort(team_num);
OPR = OPR(idx,:);
DPR = DPR(idx,:);

team_686_idx = find(team_num == 686);

TOTAL = 1;
AUTO  = 2;
FUEL  = 3;
GEAR  = 4;
CLIMB = 5;
FOUL  = 6;



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
title(title_str);


figure;
bar(1:length(team_num), sorted_OPR(:,[AUTO GEAR FOUL CLIMB FUEL]), 'stacked');
grid on;
ylabel('OPR');
title(title_str);
legend('Auto', 'Gear', 'Foul', 'Climb', 'Fuel', 'Location', 'NorthWest');
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
print('-dpng', sprintf('plots/%s_opr_bar.png',event_name), '-r100');


figure;
subplot(311);
[x,i] = sort(OPR(:,AUTO));
bar(1:length(team_num), x);
% grid on;
ylabel('Auto OPR');
title(title_str);
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

subplot(312);
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
ylim([-10 50]);

subplot(313);
[x,i] = sort(OPR(:,FUEL));
bar(1:length(team_num), x);
% grid on;
ylabel('Fuel OPR');
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
ylim([-5 30]);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print('-dpng', sprintf('plots/%s_opr_bkdn_1.png',event_name), '-r100');

figure;
subplot(211);
[x,i] = sort(OPR(:,GEAR));
bar(1:length(team_num), x);
% grid on;
ylabel('Gear OPR');
title(title_str);
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
ylim([-5 120]);

subplot(212);
[x,i] = sort(OPR(:,CLIMB));
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
ylim([-5 80]);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print('-dpng', sprintf('plots/%s_opr_bkdn_2.png',event_name), '-r100');





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
title(title_str);
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
print('-dpng', sprintf('plots/%s_opr_dpr.png',event_name), '-r100');



font_size = 12;


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
    if ~isempty(team_686_idx)
        line([1 1]*OPR(team_686_idx,col), [0 max(n)], 'Color','red', 'LineStyle','--', 'LineWidth',3);
        h = text(OPR(team_686_idx,col),0,'686',...
            'Rotation',90,'HorizontalAlignment','Right','VerticalAlignment',...
            'Middle','FontSize',font_size, 'Color', 'r');
    end
    xlim([edges(1) edges(end)]);
    ylabel(stat_cols(col));
    grid on;
    if col==1
        title(sprintf('%s\nOPR Distribution', title_str));
    end
end
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print('-dpng', sprintf('plots/%s_opr_dist.png',event_name), '-r100');

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
    if ~isempty(team_686_idx)
        line([1 1]*DPR(team_686_idx,col), [0 max(n)], 'Color','red', 'LineStyle','--', 'LineWidth',3);
        h = text(DPR(team_686_idx,col),0,'686',...
            'Rotation',90,'HorizontalAlignment','Right','VerticalAlignment',...
            'Middle','FontSize',font_size, 'Color', 'r');
    end
    xlim([edges(1) edges(end)]);
    ylabel(stat_cols(col));
    grid on;
    if col==1
        title(sprintf('%s\nDPR Distribution', title_str));
    end
end
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print('-dpng', sprintf('plots/%s_dpr_dist.png',event_name), '-r100');

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
    if ~isempty(team_686_idx)
        line([1 1]*CCWM(team_686_idx,col), [0 max(n)], 'Color','red', 'LineStyle','--', 'LineWidth',3);
        h = text(CCWM(team_686_idx,col),0,'686',...
            'Rotation',90,'HorizontalAlignment','Right','VerticalAlignment',...
            'Middle','FontSize',font_size, 'Color', 'r');
    end
    xlim([edges(1) edges(end)]);
    ylabel(stat_cols(col));
    grid on;
    if col==1
        title(sprintf('%s\nCCWM Distribution', title_str));
    end
end
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 9]);
print('-dpng', sprintf('plots/%s_ccwm_dist.png',event_name), '-r100');
