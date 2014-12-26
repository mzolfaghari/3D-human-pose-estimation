% extracts a 24d vector of 8 upper body coordinates in shak's representation from my 63d full body representation

function Y1 = spring2shak(Y);

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

Y1(1:3,:) = (Y(16:18,:)+Y(28:30,:))/2;
Y1(4:6,:) = (Y(40:42,:)+Y(49:51,:))/2;
Y1(7:9,:) = Y(31:33,:);
Y1(10:12,:) = Y(19:21,:);
Y1(13:15,:) = Y(34:36,:);
Y1(16:18,:) = Y(22:24,:);
Y1(19:21,:) = Y(37:39,:); 
Y1(22:24,:) = Y(25:27,:);

% y and z axes must be negated
Y1(2:3:24,:) = -Y1(2:3:24,:);
Y1(3:3:24,:) = -Y1(3:3:24,:);

% scale and translate:
% to calibrate i used the following info that i computed:
% spring man => cmu man

% spring man's avg. upper arm length (over right and left) = 10.6183 units
% spring man's avg. fore arm length (over right and left) = 9.6684 units
% spring man's avg. shoulder width = 13.2092 units

% poser man's avg upper arm length (over left and right) = 0.1141 units
% poser man's avg fore arm length (over left and right) = 0.1031 units
% posr man's avg. shoulder width = 0.1391 units
% 
% => scaling factor = 93.9334

% poser man's pelvis is always located at [0 .4088 -.006];

Y1 = Y1 - repmat(Y1(4:6,:),8,1);
Y1 = Y1/93.9334;
Y1 = Y1 + repmat([0;.4088;-.006]*ones(1,size(Y1,2)),8,1);

Y1(2,:) = .6367; % moving the neck up
%Y1(8,:) = Y1(11,:); % putting shoulders at same level
