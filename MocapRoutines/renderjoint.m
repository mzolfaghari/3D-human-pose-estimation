
function renderjoint(X,p)

% renders a sphere at the 3d point X
% p gives the radius of the shpere

p1 = 20; %precision
t = 0:1/(p1-1):1;
[th,ph] = meshgrid( t*pi,t*2*pi );
x = X(1) + p*cos(th);
y = X(2) + p*sin(th).*cos(ph); 
z = X(3) + p*sin(th).*sin(ph); 
a = surf(x,y,z, z.*0);
set(a,'EdgeColor',[0 .8 .8],'FaceColor',[0 .8 .8]);
