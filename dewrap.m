% usage: Ynew = dewrap(Y)
%
% breaks Y(3,:) into 2 parameters to get rid of wrap around.
% Ynew(3,:) = 20*cos(Y(3,:)) and Ynew has an extra dimension in the end = 20sin(Y(3,:))

function Ynew = dewrap(Y)
%global Sc;
SL = 20; % was using 20 upto icml. changed to 90 on 09/03/2004 
         % so that angle diff corr to two poses with azimuthal angle 180
         % degrees apart gives an error of 180. i think this would be
         % critical while clustering on Y
                          
         % should not really matter as theoretically i do a rescaling to 
         % measure mahalonobis distances, but while clustering in Y, maybe 
         % its more sensible to keep euclidien distances - ideally it
         % should be angle_distance, but this should be good enough
         
         % FINAL COMMENT ON THIS - 23/03/04
         % i am using mahalanobis measures everywhere .. it seems to
         % approximate angle_distance reasonably well. so this scaling is
         % irrelevant. however, the dynamical model in icml case 1 doesnt
         % have a scaling, so leave SL=20 because thats what the dynamics
         % there assume. note that variance of cos and sin theta = 0.5, so
         % this term is not estimated from training data, else i would
         % depend on which heading angles are seen more in training data
         % for estimating these parameters
         
Ynew = Y;
r = (pi/180);
Ynew(3,:) = SL*sin(r*Y(3,:)); 
Ynew(size(Y,1)+1,:) = SL*cos(r*Y(3,:));

%Ynew = Sc*Ynew;0