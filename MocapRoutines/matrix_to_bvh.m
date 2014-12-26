function matrix_to_bvh(Y,filename)
% usage: matrix_to_bvh(Y,filename)
%
% takes data from a 54xN matrix Y and writes to a poser-readable bvh file,
% filename (filename is a string)

[tmp,nframes] = size(Y);

fid0 = fopen('hierarchy1.bvh','r');  
% this is a file that i created in poser hierarchy format with offsets from usc files    
fid1 = fopen(filename,'w');
for i=1:126,  % copying the hierarchy
    line = fgetl(fid0);
    fprintf(fid1,'%s',line);
    fprintf(fid1,'\n');    
end
fprintf(fid1,'MOTION\n');   
fprintf(fid1,'Frames: %d\n',nframes);
fprintf(fid1,'Frame Time: 0.033333\n');

XforP = [];   
T = [0;15;0];
XforP = [T*ones(1,nframes);Y(1:3,:);zeros(3,nframes);Y(4:6,:);zeros(3,nframes);Y(7:12,:);zeros(3,nframes);Y(13:54,:)];
for i=1:nframes, % writing new matrix into new bvh file
    for j=1:66,
        fprintf(fid1,'%f ',XforP(j,i));    
    end
    fprintf(fid1,'\n');    
end
    
