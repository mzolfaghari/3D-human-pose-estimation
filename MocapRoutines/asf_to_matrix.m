function [direction,length,axes] = asf_to_matrix(fname)

% assuming fixed hierarchy and structure as in the CMU database
% read only values of bone lengths and directions

fid=fopen(fname, 'rt');
if fid == -1,
    fprintf('Error, can not open file %s.\n', fname);
    return;
end;

% directions, lengths and axes of the 30 bones
line = 'x';start = 1; stop = 1;
for id=1:30,
    while ~strcmp(line(start:stop),'begin')
        line=fgetl(fid);
        start = min(find(line~=' '));
        stop = min(size(line,2),start+5);  
    end
    line=fgetl(fid); %id
    line=fgetl(fid); % name
    line=fgetl(fid); % direction
    direction(:,id) = sscanf(line(min(find(line=='n'))+1:end),'%f');
    line=fgetl(fid); % length
    length(id) = sscanf(line(min(find(line=='h'))+1:end),'%f');
    line=fgetl(fid); % axis
    axes(:,id) = sscanf(line(min(find(line=='s'))+1:end),'%f');
end

% note: if axes are not specified u use direction, but if they are
% specified, directions are ignored. this is how the asf/amc format works.
% its done so that given axes, u dont need to depend on the skeleton
% 'structure' (zero state). for details, see 
% http://www.cs.wisc.edu/graphics/Courses/cs-838-1999/Jeff/ASF-AMC.html