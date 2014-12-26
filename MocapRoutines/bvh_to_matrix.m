% usage: A = bvh_to_matrix('xyz.bvh',verbose);
% where verbose is an optional parameter that can be 0 (default: 1) 
%
% Reads data from an BVH motion file into a Matlab matrix variable.
% xyz.bvh is the input bvh file on the disk

function M = bvh_to_matrix(fname,debug_mode)
% by default (no value specifed) i define debug_mode as 1 and output nframes and ndims
% if i pass a 0, then i dont output these 2 values

debug_mode1 = 1;
if (nargin==2),
    if (debug_mode==0),
        debug_mode1 = 0;
    end
end

fid=fopen(fname, 'rt');
if fid == -1,
 fprintf('Error, can not open file %s.\n', fname);
 return;
end;

% read-in header
line=fgetl(fid);
while ~strcmp(line,'MOTION')
  line=fgetl(fid);
end

line = fscanf(fid,'%s\n',1); % "Frame No:"
nframes = fscanf(fid,'%f\n',1);
if (debug_mode1==1),
    nframes
end
line=fgetl(fid);  % frame time

tmp = fscanf(fid,'%f');
[ndimsxnframes,temp] = size(tmp);
ndims = ndimsxnframes/nframes;
if (debug_mode1==1),
    ndims
end
if (round(ndims)~=ndims),
    fprintf('Error, motion parameters dont match hierarchy specifications.\n', fname);
    return;
end;

M = reshape(tmp,ndims,nframes);