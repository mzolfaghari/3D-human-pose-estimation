
% a file that takes the 24 xyz coordinates from shaknorovich's coordrinate
% system and gives me 63 parameters that i need to render the spring man.

% my representation:
% 1     01 - 03        root
% 2     04 - 06        root (dummy)
% 3     07 - 09        sternum
% 4     10 - 12        neck
% 5     13 - 15        head
% 6     16 - 18        right clavicle
% 7     19 - 21        right shoulder
% 8     22 - 24        right elbow
% 9     25 - 27        right wrist
% 10    28 - 30        left clavicle
% 11    31 - 33        left shoulder
% 12    34 - 36        left elbow
% 13    37 - 39        left wrist
% 14    40 - 42        right hip
% 15    43 - 45        right knee
% 16    46 - 48        right ankle
% 17    49 - 51        left hip
% 18    52 - 54        left knee
% 19    55 - 57        left ankle
% 20    58 - 60        right toes
% 21    61 - 63        left toes

% gregory's representaion:
% (what he has written in the readme is not in the correct order!!)
% ( 8 X xyz):
% - base of the neck
% - hip (center of the pelvis)
% - left shoulder
% - right shoulder
% - left elbow
% - right elbow
% - left wrist
% - right wrist

function Y = shak2spring(simlog2)

% input is 24xn
% output is 63xn

%load /local_scratch/aagarwal/NewData/post_cvpr05/Poser/posedata2/simlog2.txt;
%simlog2 = simlog2(:,2:25)';
%simlog2 = Y3r;% + m*ones(1,size(Y3r,2));
%simlog2 = Y1;
% note that x axis is the same while y,z point in the opposite directions
% x=x, y=-y,z=-z

Y = zeros(63,size(simlog2,2));

Y(31:33,:) = simlog2(7:9,:);
Y(19:21,:) = simlog2(10:12,:);
Y(34:36,:) = simlog2(13:15,:);
Y(22:24,:) = simlog2(16:18,:);
Y(37:39,:) = simlog2(19:21,:);
Y(25:27,:) = simlog2(22:24,:);

% root from center of hip and base of neck:
Y(1:3,:) = .8*simlog2(4:6,:) + .2*simlog2(1:3,:);
Y(4:6,:) = Y(1:3,:);

% upper neck and head :
Y(10:12,:) = simlog2(1:3,:) + (1/10)*(simlog2(1:3,:)-simlog2(4:6,:));
Y(13:15,:) = simlog2(1:3,:) + (1/4)*(simlog2(1:3,:)-simlog2(4:6,:));

% clavicles 
Y(16:18,:) = simlog2(1:3,:) - (1/20)*(simlog2(1:3,:)-simlog2(4:6,:));
Y(28:30,:) = simlog2(1:3,:) - (1/20)*(simlog2(1:3,:)-simlog2(4:6,:));

% sternum from root and clavicles
Y(7:9,:) = (.45*Y(1:3,:) + .55*Y(16:18,:));  

% hips
hipwidth = mean(abs(simlog2(7,:)-simlog2(10,:)));
shvector = Y(19:21,:)-Y(31:33,:); % unit vector from right to left shoulder
shvector = shvector./(ones(3,1)*sqrt(sum(shvector.^2)));
Y(40:42,:) = simlog2(4:6,:) + (hipwidth/2)*shvector;
Y(49:51,:) = simlog2(4:6,:) - (hipwidth/2)*shvector;

% straight small length legs:
Y(43:45,:) = Y(40:42,:);
Y(44,:) = Y(44,:) - hipwidth*2;
Y(46:48,:) = Y(40:42,:);
Y(47,:) = Y(47,:) - hipwidth*4;
Y(58:60,:) = Y(40:42,:);
Y(59,:) = Y(59,:) - hipwidth*5;

Y(52:54,:) = Y(49:51,:);
Y(53,:) = Y(53,:) - hipwidth*2;
Y(55:57,:) = Y(49:51,:);
Y(56,:) = Y(56,:) - hipwidth*4;
Y(61:63,:) = Y(49:51,:);
Y(62,:) = Y(62,:) - hipwidth*5;

Y = Y - repmat(Y(1:3,:),21,1);
Y = Y*93.9334;
Y(2:3:63,:) = -Y(2:3:63,:) - 35; 
Y(3:3:63,:) = -Y(3:3:63,:);