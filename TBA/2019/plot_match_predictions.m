function plot_match_predictions(team_matrix, team_num, OPR, team_filter, matches_per_sheet)

% apply team filter
if isempty(team_filter)
    rows = 1:2:size(team_matrix,1);
else
    rows = find(ismember(team_matrix(:,1),team_filter) | ismember(team_matrix(:,2),team_filter) | ismember(team_matrix(:,3),team_filter));
end
matches = ceil(rows/2);
matches = sort(matches);

if isempty(matches)
    return
end

o = 0.3;
red_cmap(1,:) = 0.6 * [1 o o];
red_cmap(2,:) = 0.8 * [1 o o];
red_cmap(3,:) = 1.0 * [1 o o];

blue_cmap(1,:) = 0.6 * [o o 1];
blue_cmap(2,:) = 0.8 * [o o 1];
blue_cmap(3,:) = 1.0 * [o o 1];

for k = 1:length(matches)
    match = matches(k);

    red_team(k,:)  = team_matrix(2*match-1,:);
    blue_team(k,:) = team_matrix(2*match-0,:);

    for t=1:3
        red_opr(k,t)  = OPR(find(team_num == red_team(k,t)));
        blue_opr(k,t) = OPR(find(team_num == blue_team(k,t)));
    end

    [red_opr(k,:),idx] = sort(red_opr(k,:),'descend');
    red_team(k,:) = red_team(k,idx);
    [blue_opr(k,:),idx] = sort(blue_opr(k,:),'descend');
    blue_team(k,:)  = blue_team(k,idx);
end



for first_match_on_sheet = 1:matches_per_sheet:length(matches)
    sheet_matches = first_match_on_sheet + (0:+matches_per_sheet-1);
    sheet_matches = sheet_matches(sheet_matches <= matches(end));


    y = mod(sheet_matches-1, matches_per_sheet)+1;
    red_y = y+0.2;
    blue_y = y-0.2;

    figure;
    red_bar = barh(red_y,red_opr(sheet_matches,:),'stacked');
    set(red_bar,'BarWidth',0.4);
    set(red_bar(1),'FaceColor',red_cmap(1,:));
    set(red_bar(2),'FaceColor',red_cmap(2,:));
    set(red_bar(3),'FaceColor',red_cmap(3,:));

    hold on;
    blue_bar = barh(blue_y,blue_opr(sheet_matches,:),'stacked');
    set(blue_bar,'BarWidth',0.4);
    set(blue_bar(1),'FaceColor',blue_cmap(1,:));
    set(blue_bar(2),'FaceColor',blue_cmap(2,:));
    set(blue_bar(3),'FaceColor',blue_cmap(3,:));

    set(gca,'ydir','reverse');  % plot increasing matches towards bottom

    ylim([0 length(red_y)+1]);
    set(gca,'ytick',1:length(sheet_matches));
    yticklabel = {};
    for k=1:numel(sheet_matches)
        yticklabel{k} = sprintf('Q%d',matches(sheet_matches(k)));
    end
    set(gca,'yticklabel',yticklabel);

    xlabel('Score (by OPR)');
    ylabel('Qualification Match');
    title('Qualification Match Predictions (by OPR)');

    x_lim = get(gca,'xlim');
    x_lim = x_lim(2);
    y_lim = get(gca,'ylim');
    y_lim = y_lim(2);

    for kk = 1:numel(sheet_matches)
        sheet_match = sheet_matches(kk);
    
        for team=1:3
            x = sum(red_opr(sheet_match,1:team-1)) + red_opr(sheet_match,team)/2;
            text(x,red_y(kk),sprintf('T%d (%.1f)',red_team(sheet_match,team),red_opr(sheet_match,team)),'Color','y','FontWeight','bold','HorizontalAlignment','center','VerticalAlignment','middle')
            if red_team(sheet_match,team) == 686
                xRadius = 10;
                yRadius = 0.15;
                theta = 0 : 0.01 : 2*pi;
                x = xRadius * cos(theta) + x;
                y = yRadius * sin(theta) + red_y(kk);
                plot(x, y, 'Color', 'y', 'LineWidth', 3);
            end

            x = sum(blue_opr(sheet_match,1:team-1)) + blue_opr(sheet_match,team)/2;
            text(x,blue_y(kk),sprintf('T%d (%.1f)',blue_team(sheet_match,team),blue_opr(sheet_match,team)),'Color','y','FontWeight','bold','HorizontalAlignment','center','VerticalAlignment','middle')
            if blue_team(sheet_match,team) == 686
                xRadius = 10;
                yRadius = 0.15;
                theta = 0 : 0.01 : 2*pi;
                x = xRadius * cos(theta) + x;
                y = yRadius * sin(theta) + blue_y(kk);
                plot(x, y, 'Color', 'y', 'LineWidth', 3);
            end
        end
        x = sum(red_opr(sheet_match,:))+2;
        val = sum(red_opr(sheet_match,:));
        text(x,red_y(kk),num2str(val,'%.1f'),'Color','r','FontWeight','bold','HorizontalAlignment','left','VerticalAlignment','middle')

        x = sum(blue_opr(sheet_match,:))+2;
        val = sum(blue_opr(sheet_match,:));
        text(x,blue_y(kk),num2str(val,'%.1f'),'Color','b','FontWeight','bold','HorizontalAlignment','left','VerticalAlignment','middle')
    end
end
