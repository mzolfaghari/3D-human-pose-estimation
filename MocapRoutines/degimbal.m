function T1 = degimbal(T) 
% will take and set of 3 angles and try to give back the true 3 angles
% just imposes range constraints on individual angles: 
% DOES NOT DISTURB ORDERING
% T is 3xnt

nt = size(T,2);
na = size(T,1);
% if na = 2, i assume its the x and z axes in that order
% if na = 3, i assume its the x y z axes in that order


rtd = 180/pi;
dtr = pi/180;

for i=1:nt,
    switch na        
        case 3        
            rx = T(1,i)*dtr;
            ry = T(2,i)*dtr;
            rz = T(3,i)*dtr;   
        case 2
            rx = T(1,i)*dtr;
            ry = 0;
            rz = T(2,i)*dtr;        
    end
    Rx = [1   0       0      0; 
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
              
    R = Rx*Ry*Rz;
    switch na
        case 3
            % use atan to recover rx and rz so that they belong to {-90,90}
            % use atan2 to recover ry so that it belongs to {-180,180}
            rx1 = atan(-R(2,3)/R(3,3)); 
            rz1 = atan(-R(1,2)/R(1,1));
            ry1 = atan2(R(1,3),R(1,1)/cos(rz1));
            T1(1:3,i) = [rx1;ry1;rz1]*rtd;
        case 2
            % use a sin to recover both rx and rz so that belong to{-90,+90}
            rx1 = asin(-R(2,3));
            ry1 = 0;
            rz1 = asin(-R(1,2));
            T1(1:2,i) = [rx1;rz1]*rtd;
    end
    diagnose = 1;
    if (diagnose==1),
        r11(i) = R(1,1);
        r12(i) = R(1,2);
        r13(i) = R(1,3);
        r21(i) = R(2,1);
        r22(i) = R(2,2);
        r23(i) = R(2,3);
        r31(i) = R(3,1);
        r32(i) = R(3,2);
        r33(i) = R(3,3);                            
    end
end

% i use this form of R to recover the angles from it:
% R = [cy.cz                -cy.sz              sy      0;
%      cx.sz + sx.sy.cz     cx.cz - sx.sy.sz    -sx.cy  0;
%      sx.sz - cx.sy.cz     sx.cz + cx.sy.sz    cx.cy   0;
%      0                    0                   0       1];

% sometimes its seems that even after degimbal, there are correlated spikes
% in rx and rz. but i confirmed that these spikes exist also in the
% individual elements of the rotation matrix in such cases, which means that its
% not a gimbal lock ambiguity situation but some other 'noise' in the mocap data.
