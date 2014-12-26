
function renderpart(part,X,p,option,shade,filetype)
% 1. part: 'limb', 'head', 'root' or 'ches(t)'
%
% 2. X: location point(s)
% for limb: 2 points giving start and end point
% for head: 2 point giving head and neck points
%                 (use only one as the center, but other for direction)
% for root: 6 points giving chest, mean(hip1,hip2), shoulder1, shoulder2, hip1, hip2
% for chest: 6 points giving chest, neck and hip1, hip2, shoulder1, shoulder2
%
% 3. p: volume shape parameters
% for limb: 1 parameter giving 'obesity'
% for head: 1 parameter giving 'size'
% for neck: 1 parameter giving 'size'
% for chest: 2 parameters giving 'width' and 'thickness' 
%                                (thickness is a fraction of width)
% for root: 2 paramters giving 'width' and 'thickness (tummy)'
%                                (thickness is a fraction of width)
%
% 4. option: 1=>cylinders, 2=>smooth surfaces
switch part
    case 'limb'
        if (size(X,2)~=2 | size(p)~=1),
            fprintf('Error in parameter specification');
        end
        X1 = X(:,1);
        X2 = X(:,2);
        x = [X1(1) X2(1)];
        y = [X1(2) X2(2)];
        z = [X1(3) X2(3)];
        
        dv = X2 - X1;
        dv = dv/norm(dv);
        % to find a unit ring perpendicular to dv centered at (0,0,0);
        % if dv was (0;0;1), let the disc be refdisc
        % but [dv;1] = R*[0;0;1;1], so disc = R*refdisc + center
        % R = Ry.Rx.Rz (see ~/NewData/matlab/reorder1.m)
        % i.e. dv = [sy.cx; -sx; cx.cy]
        rx = asin(-dv(2));
        ry = atan2(dv(1)/cos(rx),dv(3)/cos(rx));
        rz = 0;

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
        R = Ry*Rx*Rz;

        p1 = 36; % precision along cicumference for theta=2*pi
        p2 = 20; % precision along limb for t=0:1

        theta = [0:2*pi/(p1-1):2*pi];
        t = [0 0:1/(p2-1):1 1];
        r = bezier(t,option,p);

        xs = [];
        ys = [];
        zs = [];
        for i=1:length(t),
            overlap = 0.4;
            center = (1-t(i))*(X1-overlap*p*dv) + t(i)*(X2+overlap*p*dv);
            refdisc = r(i)*[cos(theta);sin(theta);zeros(1,length(theta))];
            disc = R*[refdisc;ones(1,size(refdisc,2))]; % disc is centered at (0,0,0);
            disc = disc(1:3,:) + center*ones(1,size(disc,2)); % translation
            xs = [xs;disc(1,:)];
            ys = [ys;disc(2,:)];
            zs = [zs;disc(3,:)];
        end
                
    case 'head'
        if (size(X,2)~=2 | size(p)~=1),
            fprintf('Error in parameter specification');
        end
        X1 = X(:,1);
        X2 = X(:,2);
        x = [X1(1) X2(1)];
        y = [X1(2) X2(2)];
        z = [X1(3) X2(3)];
        
        dv = X2 - X1;
        dv = dv/norm(dv);
        % to find a unit ring perpendicular to dv centered at (0,0,0);
        % if dv was (0;0;1), let the disc be refdisc
        % but [dv;1] = R*[0;0;1;1], so disc = R*refdisc + center
        % R = Ry.Rx.Rz (see ~/NewData/matlab/reorder1.m)
        % i.e. dv = [sy.cx; -sx; cx.cy]
        rx = asin(-dv(2));
        ry = atan2(dv(1)/cos(rx),dv(3)/cos(rx));
        rz = 0;

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
        R = Ry*Rx*Rz;

        p1 = 36; % precision along cicumference for theta=2*pi
        p2 = 20; % precision along limb for t=0:1

        theta = [0:2*pi/(p1-1):2*pi];
        t = [0 0:1/(p2-1):1 1];
        r = bezier(t,option,p);
        xs = [];
        ys = [];
        zs = [];
        for i=1:length(t),
            center = (1-t(i))*(X1-1.1*p*dv) + t(i)*(X1+1.1*p*dv);
            refdisc = r(i)*[cos(theta);sin(theta);zeros(1,length(theta))];
            disc = R*[refdisc;ones(1,size(refdisc,2))]; % disc is centered at (0,0,0);
            disc = disc(1:3,:) + center*ones(1,size(disc,2)); % translation
            xs = [xs;disc(1,:)];
            ys = [ys;disc(2,:)];
            zs = [zs;disc(3,:)];
        end
                   
    case {'root'}
        if (size(X,2)~=6 | size(p)~=1),
            fprintf('Error in parameter specification');
        end
        X1 = X(:,1);
        X2 = X(:,2);
        X3 = X(:,3);
        X4 = X(:,4); 
        X5 = X(:,5);
        X6 = X(:,6);
        x = [X1(1) X2(1)];
        y = [X1(2) X2(2)];
        z = [X1(3) X2(3)];
        
        dv = X2 - X1;
        dv = dv/norm(dv);
        dv2 = X6 - X5;
        dv2 = dv2/norm(dv2);

        % to find a unit ring perpendicular to dv centered at (0,0,0);
        % if dv was (0;0;1), let the disc be refdisc
        % but [dv;1] = R*[0;0;1;1], so disc = R*refdisc + center
        % R = Ry.Rx.Rz (see ~/NewData/matlab/reorder1.m)
        % i.e. dv = [sy.cx; -sx; cx.cy]
        rx = asin(-dv(2));
        ry = atan2(dv(1)/cos(rx),dv(3)/cos(rx));
        rz = 0;
        % now rz must be such that it rotates 
        % (1,0,0) to dv2 and (0,1,0) to (dv2 x dv)
        cp = cross(dv2,dv);
        rz = atan2(dv2(2)/cos(rx),cp(2)/cos(ry));
        
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
        R = Ry*Rx*Rz;

        p1 = 36; % precision along cicumference for theta=2*pi
        p2 = 20; % precision along limb for t=0:1

        theta = [0:2*pi/(p1-1):2*pi];
        t = [0 0:1/(p2-1):1 1];
        r = bezier(t,option,1,0.1);
        shoulderwidth = norm(X3-X4);
        hipwidth = norm(X5-X6);
        chestwidth = .6*shoulderwidth + .4*hipwidth;
        coneline = (1-t)*chestwidth/2 + t*1.5*hipwidth/2;
        r = 1.1*r.*coneline;
        xs = [];
        ys = [];
        zs = [];
        for i=1:length(t),
            overlap = 0.5;
            center = (1-t(i))*(X1+overlap*chestwidth*dv) + t(i)*(X2+overlap*hipwidth*dv);
            refdisc = r(i)*[cos(theta);p*sin(theta);zeros(1,length(theta))];
            disc = R*[refdisc;ones(1,size(refdisc,2))]; % disc is centered at (0,0,0);
            disc = disc(1:3,:) + center*ones(1,size(disc,2)); % translation
            xs = [xs;disc(1,:)];
            ys = [ys;disc(2,:)];
            zs = [zs;disc(3,:)];
        end
                
    case 'ches'
        if (size(X,2)~=6 | size(p)~=1),
            fprintf('Error in parameter specification');
        end
        X1 = X(:,1);
        X2 = X(:,2);
        X3 = X(:,3);
        X4 = X(:,4); 
        X5 = X(:,5);
        X6 = X(:,6); 
        
        x = [X1(1) X2(1)];
        y = [X1(2) X2(2)];
        z = [X1(3) X2(3)];
                
        dv = X2 - X1;
        dv = dv/norm(dv);
        dv2 = X6 - X5;
        dv2 = dv2/norm(dv2);
        
        % to find a unit ring perpendicular to dv centered at (0,0,0);
        % if dv was (0;0;1), let the disc be refdisc
        % but [dv;1] = R*[0;0;1;1], so disc = R*refdisc + center
        % R = Ry.Rx.Rz (see ~/NewData/matlab/reorder1.m)
        % i.e. dv = [sy.cx; -sx; cx.cy]
        rx = asin(-dv(2));
        ry = atan2(dv(1)/cos(rx),dv(3)/cos(rx));
        rz = 0;
        % now rz must be such that it rotates 
        % (1,0,0) to dv2 and (0,1,0) to (dv x dv2)
        cp = cross(dv,dv2);
        rz = atan2(dv2(2)/cos(rx),cp(2)/cos(ry));
        
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
        R = Ry*Rx*Rz;

        p1 = 36; % precision along cicumference for theta=2*pi
        p2 = 20; % precision along limb for t=0:1

        theta = [0:2*pi/(p1-1):2*pi];
        t = [0 0:1/(p2-1):1 1];
        r = bezier(t,option,1,.1);        
        hipwidth = norm(X3-X4);
        shoulderwidth = norm(X5-X6);        
        chestwidth = .6*shoulderwidth + .4*hipwidth;

        coneline = (1-t)*chestwidth/2 + t*shoulderwidth/2;
        r = 1.1*r.*coneline;
        
        xs = [];
        ys = [];
        zs = [];
        for i=1:length(t),            
            overlap = .15 ;
            if (filetype=='amc'),
                center = (1-t(i))*(X1+overlap*chestwidth*dv) + t(i)*(X2+overlap*shoulderwidth*dv);
            else
                center = (1-t(i))*(X1-overlap*chestwidth*dv) + t(i)*(X2+overlap*shoulderwidth*dv);
            end
            refdisc = r(i)*[cos(theta);p*sin(theta);zeros(1,length(theta))];
            disc = R*[refdisc;ones(1,size(refdisc,2))]; % disc is centered at (0,0,0);
            disc = disc(1:3,:) + center*ones(1,size(disc,2)); % translation
            xs = [xs;disc(1,:)];
            ys = [ys;disc(2,:)];
            zs = [zs;disc(3,:)];
        end
end

if (option=='cyl' | option=='exp'),    
    a = surf(xs,ys,zs,zs.*0); % this zs.*0 is what controls the color
    if (~isempty(shade.FaceAlpha)),
        set(a,'FaceAlpha',shade.FaceAlpha);
    end
    if (~isempty(shade.FaceColor)),
       set(a,'FaceColor',shade.FaceColor);
    end
    if (~isempty(shade.EdgeColor)),
        set(a,'EdgeColor',shade.EdgeColor);
    end   
end

if (option=='spr'),
    for i=1:p2+2,
        plot3(xs(i,:),ys(i,:),zs(i,:),'k','LineWidth',1);
    end
end

