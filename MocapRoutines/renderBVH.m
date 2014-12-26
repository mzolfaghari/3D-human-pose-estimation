%
% usage: renderBVH('filename.bvh');
%

% function renderBVH(motionfile)
motionfile='Y33_200_Naive.bvh';
fprintf('\n Press any key to move to the next frame\n');
fprintf('\n Ctrl C to stop without viewing all frames\n');

skeletonfile = [];

option.shape = 'exp'; 
option.render = 'surf';
option.style = 'flesh'; 

shade.FaceAlpha = 1; 
shade.FaceColor = [1;1;1];
shade.FaceColor = [0;0;0];
shade.EdgeColor = [0;0;0]; 

renderbody(motionfile,skeletonfile,option,shade,[],1,[]);

