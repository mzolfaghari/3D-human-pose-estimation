
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Code to run 3D Human Pose Estimation using Couple Sparse Coding %
%%%% Written by Mohammadreza Zolfaghari and Amin Jourablo %%%%%%%%%%%%
%%% If you are using this code for your research, -------------------%
%%%%% please cite the following paper: ------------------------------%
%%%%% 3D human pose estimation from image using ---------------------%
%%%%%   couple sparse coding, MVA 2014-------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%=======================================================================
%======================================================================
%-----Optimization Function---------
%======================================================================
%   minimize_x  beta*||y - A*x||^2 + lambda*||x||_1 + alpha*||z - B*x||^2

% A = Features Dictionary
% x = Sparse represenation 
% B = Pose Dictionary
% z = Pose obtained with k-NN
% pose = B*x
%-----------------------------------
%(@)(@)(@)(@)(@)(@)(@)(@)(@)(@)(@)(@)(@)(@)(@)(@)(@)(@)(@)(@)(@)(@)(@)(@)


clear all
close all
clc
me = mfilename;                           % what is my filename
mydirm = which(me); 
mydir = mydirm(1:end-2-numel(me));        % where am I located

dir1=strcat(mydir,'Database');
addpath(dir1);

%======================================================================
%-------------Loading DataSets------------------------------------------
%======================================================================
x1417=load('x1417'); % Laugh
x09=load('x09'); % Run
x131=load('x131'); % Michael Jackson Styled Motions
x63=load('x63'); % Golf
x4921=load('x4921'); % Acrobatics - spin/twirl, hang on ropes

DataSet=x4921; % Please change this for different activities. For example
% if you want test the algorithm on 'Laugh' you should set DataSet=x1417;
Xdata=DataSet.X;
Ydata=DataSet.Y;
% load('XYdata');
%-----------------------------------------------------------------------


%======================================================================
%--------Parameters-----------------------------------------------------
%======================================================================
NumData=600;
TrainCount=100;   %Number of Train Samples

%88888888888888888*** Couple ***88888888888888888
alpha=20;    %When we consider output space 
Lambda=0.001;  %sparsity
%8888888888888888888888888888888888888888888888888
% ------ Policy for selecting train samples------
PolicyFlag=1; % 0= Constant interval selection, 1= Random selection 
%--------
%-------#############################-------------


%-----------------------------------------------------------------------


if PolicyFlag==1
    %=========================================================================
    %---------Create Random TrainSet-----------------------
    idx1=randperm(NumData);
    RandTrainIndex=idx1(1:TrainCount);
    RandTestIndex=idx1(TrainCount+1:end);
    TrainIndex=RandTrainIndex;
    TestIndex=RandTestIndex;
    %---------------------------------------------------
    %***************************************************
else
    %=========================================================================
    %---------Create Spanning TrainSet----------------------
    ds=NumData/TrainCount;
    cc=ones([NumData 1]);
    cc(1:ds:end)=0;
    TestIndex=find(cc==1);
    TrainIndex=(1:ds:NumData);
    %---------------------------------------------------
    %+++++++++++++++++++++++++++++++++++++++++++++++++++
end

%======================================================================
%-----------PreProcessing-------------------------------------------
%======================================================================
Ydata = Ydata(:,4:end);% First 3 columns are not related to the pose
Xdata=Xdata(1:NumData,:)';
%Peform 'dewrap' transformation as a preprocessing step
Ydata=dewrap(Ydata(1:NumData,:)');

%=========================================================================

 xTrainSet=Xdata(:,TrainIndex);
 xTestSet=Xdata(:,TestIndex);
 yTrainSet=Ydata(:,TrainIndex);
 yTestSet=Ydata(:,TestIndex);

 %======================================================================
%----------Creating Pose Dictionary with k-NN -----------------------
%======================================================================
[n,d]=knnsearch(Xdata(:,TrainIndex)',Xdata(:,TestIndex)','Distance','euclidean','k',1);
lenM=length(TestIndex);
 Upose3=zeros(58,lenM);
 Upose=zeros(58,lenM);
 
 for ik=1:lenM
      Upose3(:,ik)= (Ydata(:,TrainIndex(n(ik,1))));
 end

%======================================================================
% %--------------Test Step----------------------------------------------
%======================================================================

estimatedPose2=EstiPose(xTrainSet,xTestSet,yTrainSet,Upose3,Lambda,alpha);


%======================================================================
%----------Calculating Error of Algorithm------------------------------
%======================================================================
% See the error between reconstruction estimatedPose2 and ground truth yTestSet:
%Before measuring the errors between estimated pose and ground truth, 
% they must be converted back to the orginal format using 'wrap'
display('Error of proposed method:')
angle_error(wrap(estimatedPose2),wrap(yTestSet))%Main Error

display('Error of k-NN method:')
angle_error(wrap(Upose3),wrap(yTestSet))%k-NN error








