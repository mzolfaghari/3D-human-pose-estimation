% usage: A = bvh_to_2dmatrix('xyz.bvh',verbose);
% where verbose is an optional parameter that can be 0 (default: 1) 
%
% Reads data from an BVH motion file into a Matlab matrix variable.
% xyz.bvh is the input bvh file on the disk

function M = bvh_to_2dmatrix(fname,debug_mode)
% by default (no value specifed) i define debug_mode as 1 and output nframes and ndims
% if i pass a 0, then i dont output these 2 values
global children;
if (nargin==1),
    debug_mode = 0;
end

clear Xall Yall Zall

offsets = [
0.00  0.00  0.00 ;
0 0 0; % new abdomen offset
0.000000 5.018152 -1.882228;
([0.000000 8.316447 0.784897] + [0.000000 2.280413 -0.39280]);
0.000000 3.496879 0.529469;
0.599237 8.316447 0.784897;
6.421198 0.010146 -0.332128;
10.552783 0.025574 0.125508;
11.035963 0.319619 0.041520;
-0.599237 8.316447 0.784897;
-6.421198 0.010146 -0.332128;
-10.552783 0.025574 0.125508;
-11.035963 0.319619 0.041520;
4.500466 -6.400484 -1.832696;
-1.359117 -18.918689 1.179887;
-0.652380 -17.215186 -0.312137;
-4.500466 -6.400484 -1.832696;
1.359117 -18.918689 1.179887;
0.652380 -17.215186 -0.312137;
0.000000 0.000000 10.353752-4;% these last two are extra points for the toes
0.000000 0.000000 10.353752-4]; 

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

Y1 = bvh_to_matrix(fname,debug_mode); 
% reading 3D Y from 
nframes = size(Y1,2);
% when making Y i throw away 12 parameters that are always 0: 
% 1,2,3    : Tx,Ty,Tz   
% 7,8,9    : ab(belly)
% 13,14,15 : neckdummy(sternum)
% 22,23,24 : hair(i inserted zeros here)   
Y1 = [Y1(4:6,:);Y1(10:12,:);Y1(16:21,:);Y1(25:66,:)];
Y1 = [Y1(1:3,:); [20.556639*ones(1,nframes); zeros(2,nframes)]; Y1(4:54,:)];
M = [];

for nf = 1:nframes,

    X = offsets(:,1)';
    Y = offsets(:,2)';
    Z = offsets(:,3)';
    for i=1:21,
        X(children{i}) = X(children{i}) + offsets(i,1);
        Y(children{i}) = Y(children{i}) + offsets(i,2);
        Z(children{i}) = Z(children{i}) + offsets(i,3);
    end

    X0 = X;
    Y0 = Y;
    Z0 = Z;         

    limb_order = [19:-1:1];
    % this is the order the limds would be processed if i do a DFS .. 
    % i should get rid of this dumb list at some point of time :) 

    triplet_orders = [1 1 1 1 1 3 4 3 4 3 4 3 4 1 1 2 1 1 2];  % 1:xzy 2:xyz 3: yzx 4: zyx 

    for index=1:19, % moving all limbs relative to the person
        i = limb_order(index);
        trip_order = triplet_orders(i);
        switch trip_order
            case 1
                rx = (pi/180)*Y1(3*i-2,nf);
                rz = (pi/180)*Y1(3*i-1,nf);
                ry = (pi/180)*Y1(3*i-0,nf);
            case 2
                rx = (pi/180)*Y1(3*i-2,nf);
                ry = (pi/180)*Y1(3*i-1,nf);
                rz = (pi/180)*Y1(3*i-0,nf);
            case 3
                ry = (pi/180)*Y1(3*i-2,nf);
                rz = (pi/180)*Y1(3*i-1,nf);
                rx = (pi/180)*Y1(3*i-0,nf);
            case 4
                rz = (pi/180)*Y1(3*i-2,nf);
                ry = (pi/180)*Y1(3*i-1,nf);
                rx = (pi/180)*Y1(3*i-0,nf);
            end
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
        switch trip_order
            case 1
                R = Rx*Rz*Ry;
            case 2
                R = Rx*Ry*Rz;
            case 3
                R = Ry*Rz*Rx;
            case 4
                R = Rz*Ry*Rx;
        end
        if ~isempty(children{i})   
            Xp = X; Yp = Y; Zp = Z;
            Xp(children{i}) = R(1,:)*[X(children{i})-X(i);Y(children{i})-Y(i);Z(children{i})-Z(i); ones(1,length(children{i}))] + X(i);
            Yp(children{i}) = R(2,:)*[X(children{i})-X(i);Y(children{i})-Y(i);Z(children{i})-Z(i); ones(1,length(children{i}))] + Y(i);
            Zp(children{i}) = R(3,:)*[X(children{i})-X(i);Y(children{i})-Y(i);Z(children{i})-Z(i); ones(1,length(children{i}))] + Z(i);
            X = Xp; Y = Yp; Z = Zp;    
        end
    end

    Y = Y+42.130260;

    Xo = X;
    Yo = Y;
    Zo = Z;

    Xall(:,nf) = X';
    Yall(:,nf) = Y';
    Zall(:,nf) = Z';

    % project and display functions

    sc = 1/103.536; % this ratio i get from body dimensions in del3.bvh as compared to ns10byposer.bvh

    % going from world frame to camera frame:
    X = Xo*sc;
    Y = -Yo*sc;
    Z = -Zo*sc;

    Tc = [0; -.36; -1.2];  % Tz must be -.2, but that doesnt work... added 1 because thats where the body center seems to be placed,
                       % rather than at z=0, its at z=-1.
    f = 38*4.8; % f=38mm as given by poser, 4.8 is the scaling to bring it to my image size
    px = 64;
    py = 60; % px = 128/2 = 64. obtained by observation (trial and error :)) ... these depend on my image resizing..

    K = [f 0 px;
         0 f py;
         0 0  1];
    T = [eye(3,3) -Tc];
    P = K*T;
    
    Xi = (P(1,:)*[X; Y; Z; ones(1,21)])./(P(3,:)*[X; Y; Z; ones(1,21)]);
    Yi = (P(2,:)*[X; Y; Z; ones(1,21)])./(P(3,:)*[X; Y; Z; ones(1,21)]);
    xyvec(1:2:41) = Xi;
    xyvec(2:2:42) = Yi;
    M = [M xyvec'];
end