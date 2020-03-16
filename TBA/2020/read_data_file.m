function data = read_data_file(filename, filter)

data = readtable(filename);

if ~isempty(filter)
    % apply filter
    filter_matches = strcmp(data.comp, filter);
    data = data(filter_matches,:);
end

data.initLineRobot1(strcmp(data.initLineRobot1,'None')) = {0};  % no points
data.initLineRobot2(strcmp(data.initLineRobot2,'None')) = {0};  % no points
data.initLineRobot3(strcmp(data.initLineRobot3,'None')) = {0};  % no points
data.initLineRobot1(strcmp(data.initLineRobot1,'Exited')) = {5}; 
data.initLineRobot2(strcmp(data.initLineRobot2,'Exited')) = {5};  
data.initLineRobot3(strcmp(data.initLineRobot3,'Exited')) = {5};  
data.endgameRobot1(strcmp(data.endgameRobot1,'None')) = {0}; 
data.endgameRobot2(strcmp(data.endgameRobot2,'None')) = {0};  
data.endgameRobot3(strcmp(data.endgameRobot3,'None')) = {0};  
data.endgameRobot1(strcmp(data.endgameRobot1,'Park')) = {5}; 
data.endgameRobot2(strcmp(data.endgameRobot2,'Park')) = {5};  
data.endgameRobot3(strcmp(data.endgameRobot3,'Park')) = {5};  
data.endgameRobot1(strcmp(data.endgameRobot1,'Hang')) = {25}; 
data.endgameRobot2(strcmp(data.endgameRobot2,'Hang')) = {25};  
data.endgameRobot3(strcmp(data.endgameRobot3,'Hang')) = {25};  
data.endgameRungIsLevel(strcmp(data.endgameRungIsLevel,'IsLevel')) = {15};  
data.endgameRungIsLevel(strcmp(data.endgameRungIsLevel,'NotLevel')) = {0};  

data.initLineRobot1 = cell2mat(data.initLineRobot1);
data.initLineRobot2 = cell2mat(data.initLineRobot2);
data.initLineRobot3 = cell2mat(data.initLineRobot3);
data.endgameRobot1 = cell2mat(data.endgameRobot1);
data.endgameRobot2 = cell2mat(data.endgameRobot2);
data.endgameRobot3 = cell2mat(data.endgameRobot3);
data.endgameRungIsLevel = cell2mat(data.endgameRungIsLevel);

numClimbers = [data.endgameRobot1 data.endgameRobot2 data.endgameRobot3] == 25;
numClimbers = sum(numClimbers,2);
T = array2table(numClimbers, 'VariableNames', {'numberOfClimbers'});
data = [data T];