
function M = amc_to_3dmatrix(motionfile,skeletonfile)
global children Y1;
M = [];
% usage: amc_to_3dmatrix(motionfile,skeletonfile)
% strategy:
% step 1. reconstruct all 29 points as in asf/amc files 
% step 2. extract my 21 points from these

clear Xall Yall Zall

% children corresponding to the true 30 bones in the asf..
% i will overwrite this by the children information for my subset later

% in the amc, the 29 joints correspond to
% id 0: root
% all others except ids 1 and 6 (hipjoints)
% so i will use the convention of 29 joints including root and excluding
% hipjoints as in /home/gloucester/aagarwal/mocap1/.amc_format

% lowerback, hipjoint and rhipjoint cioncide with root
% while lowerback is a parameter, rhipjoint and lhipjoint are 
% thrown away by the amc files

%------------------- GETTING X0 FROM THE SKELETON FILE ---------------

[directions,lengths,axes] = asf_to_matrix(skeletonfile);
directions = [[0;0;0] directions];
lengths = [0 lengths];
axes = [[0;0;0] axes];
% i now have 31 points with the root in the beginning
% that means all the original ids from asf get shifted by 1

children{1} = [2:31];
for i=2:5,
    children{i} = [i+1:6];
end
children{6} = []; % ltoes
for i=7:10,
    children{i} = [i+1:11];
end
children{11} = []; % rtoes
for i=12:14,
    children{i} = [i+1:31];
end
for i=15:16,
    children{i} = [i+1:17];
end
children{17} = []; % head
for i=18:21,
    children{i} = [i+1:24];
end
children{22} = [23]; 
children{23} = []; % lfingers
children{24} = []; % lthumb
for i=25:28,
    children{i} = [i+1:31];
end
children{29} = 30; % toes
children{30} = []; % rfingers
children{31} = []; % rthumb

% my length and direction tells how far and in what direction i am in w.r.t
% my parent
% the names correspond to the joints at the end of the bone with that name

X = zeros(3,31);

for i=1:31,
    X(:,i) = X(:,i) + directions(:,i)*lengths(i);    
    if (~isempty(children{i})),
        X(:,children{i}) = X(:,children{i}) + directions(:,i)*lengths(i)*ones(1,size(children{i},2));
    end
end

X0 = X;

%------------------- TRANSFORMING X0 to X FROM THE MOTION FILE ---------------

Y1 = amc_to_matrix(motionfile);
Y1 = Y1';
nframes = size(Y1,2);
%nframes = 1800;
%for nf = 1:8:nframes
for nf = 1:nframes,
    
    X = X0;

    % --- applying motion to default skeleton
    
    rotations = zeros(3,31); % all rotations are rx,ry,rz
    rotations(:,1) = Y1(4:6,nf);
    rotations(:,12) = Y1(7:9,nf);
    rotations(:,13) = Y1(10:12,nf);
    rotations(:,14) = Y1(13:15,nf);
    rotations(:,15) = Y1(16:18,nf);
    rotations(:,16) = Y1(19:21,nf);
    rotations(:,17) = Y1(22:24,nf);
    
    rotations(2:3,25) = Y1(25:26,nf);
    rotations(:,26) = Y1(27:29,nf);
    rotations(1,27) = Y1(30,nf);   
    rotations(2,28) = Y1(31,nf);
    rotations([1 3],29) = Y1(32:33,nf);
    rotations(1,30) = Y1(34,nf);
    rotations([1 3],31) = Y1(35:36,nf);   
    
    rotations(2:3,18) = Y1(37:38,nf);
    rotations(:,19) = Y1(39:41,nf);
    rotations(1,20) = Y1(42,nf);
    rotations(2,21) = Y1(43,nf);
    rotations([1 3],22) = Y1(44:45,nf);
    rotations(1,23) = Y1(46,nf);
    rotations([1 3],24) = Y1(47:48,nf);
    
    rotations(:,8) = Y1(49:51,nf);    
    rotations(1,9) = Y1(52,nf);
    rotations([1 3],10) = Y1(53:54,nf);
    rotations(1,11) = Y1(55,nf);

    rotations(:,3) = Y1(56:58,nf);
    rotations(1,4) = Y1(59,nf);
    rotations([1 3],5) = Y1(60:61,nf);
    rotations(1,6) = Y1(62,nf);
       
    limb_order = [6:-1:2,11:-1:7,31:-1:25,24:-1:18,17:-1:12,1]; % leaves first?
    
    % in the bvh, rotation at a point meant about this point, rotate the
    % child by so much
    % here in amc rotation at a point means rotate me about my parent by so
    % much. so i have to say for each point, rotate me by so much and
    % rotate all my children by so much ABOUT MY PARENT. hence need to
    % store parent info
    parent = [0 1:5, 1,7:10 1,12:16 14,18:22,21 14,25:29,28];
        
    for index=1:31, % moving all limbs relative to the person
        
        i = limb_order(index);
        
        rx = (pi/180)*axes(1,i);
        ry = (pi/180)*axes(2,i);
        rz = (pi/180)*axes(3,i);
        
        Rx =  [1   0       0      0; 
               0 cos(rx) -sin(rx) 0;
               0 sin(rx)  cos(rx) 0;
               0   0       0      1];
  
        Ry = [cos(ry) 0 sin(ry) 0;
                  0   1     0   0;
             -sin(ry) 0 cos(ry) 0;
                  0   0     0   1];
    
        Rz = [cos(rz) -sin(rz) 0 0;
              sin(rz)  cos(rz) 0 0;
                  0        0   1 0;
                  0        0   0 1];
        R0 = Rz*Ry*Rx;  
        
        
        rx = (pi/180)*rotations(1,i);
        ry = (pi/180)*rotations(2,i);
        rz = (pi/180)*rotations(3,i);
  
        Rx =  [1   0       0      0; 
               0 cos(rx) -sin(rx) 0;
               0 sin(rx)  cos(rx) 0;
               0   0       0      1];
  
        Ry = [cos(ry) 0 sin(ry) 0;
                  0   1     0   0;
             -sin(ry) 0 cos(ry) 0;
                  0   0     0   1];
    
        Rz = [cos(rz) -sin(rz) 0 0;
              sin(rz)  cos(rz) 0 0;
                  0        0   1 0;
                  0        0   0 1];
        R1 = Rz*Ry*Rx;    
        R = (R0)*R1*inv(R0);    
        % have to rotate by R, but in a different coordinate frame 
        % that is defined by the rotation R0
        
        Xparent = zeros(3,1);
        if (parent(i)~=0),
            Xparent = X(:,parent(i));
        end
        X(:,i) = R(1:3,:)*[X(:,i)-Xparent; 1] + Xparent;
        l = size(children{i},2);
        if ~isempty(children{i})   
            X(:,children{i}) = R(1:3,:)*[X(:,children{i}) - Xparent*ones(1,l) ; ones(1,l)] + Xparent*ones(1,l);
        end
    end
    % --- extracting my subset representation
    Xsub = X(:,[1,1,13,16,17 15,25,26,28 15,18,19,21 7,8,9 2,3,4 10 5]);
    Xsub = 2*Xsub;
    Xsub(2,:) = -(Xsub(2,:)+35);
    Xsub(3,:) = -Xsub(3,:);
    M = [M reshape(Xsub,63,1)];

end

children = [];
children{1} = [2:21];
children{2} = [3:13];
children{3} = [4:13];
children{4} = [5];
children{5} = [];
children{6} = [7:9];
children{7} = [8:9];
children{8} = [9];
children{9} = [];
children{10} = [11:13];
children{11} = [12:13];
children{12} = [13];
children{13} = [];
children{14} = [15:16, 20];
children{15} = [16,20];
children{16} = [20];
children{17} = [18:19, 21];
children{18} = [19,21];
children{19} = [21];
children{20} = [];
children{21} = [];

