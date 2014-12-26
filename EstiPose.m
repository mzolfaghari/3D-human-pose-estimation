
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 3D Human Pose Estimation using Couple Sparse Coding %
%%%% Written by Mohammadreza Zolfaghari and Amin Jourablo %%%%%%%%%%%%
%%% If you are using this code for your research, -------------------%
%%%%% please cite the following paper: ------------------------------%
%%%%% 3D human pose estimation from image using ---------------------%
%%%%%   couple sparse coding, MVA 2014-------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [EstiPose,SparseVec]=EstiPose(xTrainSet,xTestSet,yTrainSet,Upose,Lambda,alpha)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FeatureDic=xTrainSet;
PoseDic=yTrainSet;
Ry=yTrainSet;
k=size(FeatureDic,2);
lenM=length(xTestSet(1,:));
lenN=length(yTrainSet(:,1));
EstiPose=zeros(lenN,lenM);

 %====================================================================
SparseVec=zeros(lenM,k);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            alfa1=l1ls_featuresign_Couple(FeatureDic, xTestSet, PoseDic, Upose, Lambda, alpha);
    for i=1:lenM

            alfan=repmat(alfa1(:,i)',lenN,1);
            temp1=sum(alfa1(:,i));
            alfan=alfan/temp1;
            uk=sum((alfan.*PoseDic)');          


        EstiPose(:,i)=uk;
        
    end
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end