function events = get_event_names

fid = fopen('data\events.csv');
events = [];
k = 1;
while ~feof(fid)
    line = fgetl(fid);
    d = regexp(line, ',', 'split');
    events(k).key = d{1};
    events(k).name = d{2};
    k = k+1;
end
fclose(fid);
