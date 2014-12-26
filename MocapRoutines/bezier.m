function r = bezier(d,option,ol,p)

% functional forms of r will be replaced with bezier curves

% d is a discretized vector of 0:1
% r is a (bezier) curve
% ol defines the 'obesity level' (max. value of r)
if (nargin==3),
    p = 0.2;
end

switch option
    case 'exp' 
        r(find(d<=0.5)) = (d(find(d<=0.5))).^p*(ol/0.5^p);
        r(find(d>0.5)) = (1-d(find(d>0.5))).^p*(ol/0.5^p);        
    case {'cyl','spr'} 
        r(1) = 0;
        r(length(d)) = 0;
        r(2:length(d)-1) = ol;
end
