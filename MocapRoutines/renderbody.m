function renderbody(motionfile,skeletonfile,option,shade,maxframes,newfigure,moviefile) 
% ----------------------------------------------------------
% usage: 
% renderbody(motionfile,skeletonfile,option,shade,maxframes,newfigure,moviefile)
% ----------------------------------------------------------
% motion files supported: bvh and amc
% skeleton file supported: asf (dont need skel for bvh)
%
% option has 3 fields:
% shape = 'exp' or 'cyl' or 'spr' for exponential or cylindrical or spring surface
% render = 'mesh' or 'surf'
% style = 'stick','flesh','nodes','graph' 
%
% shade has 3 fields
% FaceAlpha = 0..1 (0=> transparent, 1=> opaque)
% FaceColor = [r;g;b]
% EdgeColor = [r;g;b]
% newfigure: 0 or 1
% moviefile: output (avi). give [] to save no movie
% ----------------------------------------------------------

%motionfile = '/home/gloucester/aagarwal/mocap/Data/poser_data_for2d/p_walkDrunk.bvh';
%motionfile = '/home/gloucester/aagarwal/mocap/Data/poser_data_for2d/p_walkSpiralLeft2.bvh';
%motionfile = '/home/gloucester/aagarwal/mocap1/17_06/17_06syn.amc';
%skeletonfile = '/home/gloucester/aagarwal/mocap1/17.asf';

if (newfigure==1),
    fig = figure; % returns the figure number in fig
    axis('equal'); hold on; grid on;
    set(gcf,'position',[6 60 500 800]); 
    axis([-35 35 -25 25 -10 70]);
    xlabel('x'); ylabel('y'); zlabel('z'); 
end
if (~isempty(moviefile)),
    mov = avifile('temp.avi');
end

global children Y1 filetype dump_dir 
filetype = motionfile(end-2:end);
skeltype = whos('skeletonfile');
if (filetype=='bvh'),        
    XYZ = bvh_to_3dmatrix(motionfile);
end

if (filetype=='amc'),        
    if (strcmp(skeltype.class,'char')), % so that i can directly pass a 63xn matrix in place of the skel file
        XYZ = amc_to_3dmatrix(motionfile,skeletonfile);
        %XYZ(:,1)
    else
        XYZ = skeletonfile;
        children = [];
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
    end
end
nframes = size(XYZ,2)

% setting default parameter values
% option
if (isempty(option))
    option.shape = 'exp'; 
    option.render = 'mesh';
    option.style = 'flesh'; 
end
% color
if (isempty(shade))
    shade.FaceAlpha = 1; 
    shade.FaceColor = [1;1;1];
    shade.EdgeColor = [0;0;0]; 
end
% maxframes
if (isempty(maxframes)),
    maxframes = nframes;
end
% visibility list for drawing parts as flesh                        
visible.root = 1;
visible.chest = 1;

visible.neck = 1;
visible.head = 1;

visible.arms = 1;
visible.legs = 1;



% adjacency matrix for drawing graph
adjmat = zeros(21);
for i=2:21,
    if (~isempty(children{i})),  
        adjmat(i,children{i}(1)) = 1;
    end
end
adjmat(1,14)=1;
adjmat(1,17)=1;
adjmat(3,6)=1;
adjmat(3,10)=1;


% extras for test
extra = 0;
if (extra==1),
    adjmat(3,7)=1;
    adjmat(3,11)=1;
    adjmat(14,7)=1;
    adjmat(17,11)=1;
    adjmat(14,17) = 1;
    adjmat(14,11) = 1;
end

for nf = 1:maxframes,
    if (newfigure)
        clf;    
    end
    axis('equal'); hold on; grid on;    
    set(gcf,'position',[6 60 500 800]); 
    axis([-35 35 -25 25 -10 70]);
    xlabel('x'); ylabel('y'); zlabel('z');     
    title(sprintf('frame no %d',nf));
    % a = get(gca); a.View
    view([0 0]);
    %view([15 0]); % for the black man
    % view([0 7]); % for shak. poser images
    %view([90 0]); 
    Xi = XYZ(1:3:61,nf);    
    Yi = XYZ(2:3:62,nf);
    Zi = XYZ(3:3:63,nf);

    % for thesis appendix 
    %view([20 15]);
    %axis([-20 20 -20 20 0 65]);
    %
    
    switch option.style
        case 'flesh'
            if (visible.neck),
                % drawing neck
                X1 = [Xi(3);Zi(3);-Yi(3)];
                X2 = [Xi(4);Zi(4);-Yi(4)];
                X1 = X1 + .75*(X2-X1);
                renderpart('limb',[X1,X2],2,option.shape,shade,filetype);
            end
            if (visible.head),
                % drawing head
                switch filetype
                    case 'bvh'
                       X1 = [Xi(5);Zi(5);-Yi(5)];
                       X2 = [Xi(4);Zi(4);-Yi(4)];            
                       renderpart('head',[X1,X2],3.8,option.shape,shade,filetype);    
                    case 'amc' % lowering and compressing the head a little for this guy
                       X1 = [Xi(5);Zi(5);-Yi(5)];
                       X2 = [Xi(4);Zi(4);-Yi(4)];
                       X1 = .75*X1 + .25*X2;
                       renderpart('head',[X1,X2],3.2,option.shape,shade,filetype); 
                end
            end
            if (visible.arms),
                % drawing upper arms
                for i=[7,11],
                    if (~isempty(children{i})),  
                        X1 = [Xi(i);Zi(i);-Yi(i)];
                        X2 = [Xi(children{i}(1));Zi(children{i}(1));-Yi(children{i}(1))];
                        renderpart('limb',[X1,X2],2.2,option.shape,shade,filetype);
                    end
                end
                % drawing forearms
                for i=[8:9,12:13],
                    if (~isempty(children{i})),  
                        X1 = [Xi(i);Zi(i);-Yi(i)];
                        X2 = [Xi(children{i}(1));Zi(children{i}(1));-Yi(children{i}(1))];                        
                        renderpart('limb',[X1,X2],1.8,option.shape,shade,filetype);
                    end
                end
                % drawing dummy wrists
                X0 = [Xi(8);Zi(8);-Yi(8)];
                X1 = [Xi(9);Zi(9);-Yi(9)];
                X2 = X1 + .2*(X1-X0);            
                renderpart('limb',[X1,X2],1.8,option.shape,shade,filetype);
                X0 = [Xi(12);Zi(12);-Yi(12)];
                X1 = [Xi(13);Zi(13);-Yi(13)];
                X2 = X1 + .2*(X1-X0);
                renderpart('limb',[X1,X2],1.8,option.shape,shade,filetype);            
            end
            if (visible.legs),
                % drawing upper legs
                for i=[14,17],
                    if (~isempty(children{i})),  
                        X1 = [Xi(i);Zi(i);-Yi(i)];
                        X2 = [Xi(children{i}(1));Zi(children{i}(1));-Yi(children{i}(1))];
                        renderpart('limb',[X1,X2],3,option.shape,shade,filetype);
                    end
                end
                % drawing lower legs 
                for i=[15,18],
                    if (~isempty(children{i})),  
                        X1 = [Xi(i);Zi(i);-Yi(i)];
                        X2 = [Xi(children{i}(1));Zi(children{i}(1));-Yi(children{i}(1))];
                        renderpart('limb',[X1,X2],2.2,option.shape,shade,filetype);
                    end
                end        
                % drawing feet
                for i=[16,19],
                    if (~isempty(children{i})),  
                        X1 = [Xi(i);Zi(i);-Yi(i)];
                        X2 = [Xi(children{i}(1));Zi(children{i}(1));-Yi(children{i}(1))];
                        renderpart('limb',[X1,X2],2,option.shape,shade,filetype);
                    end
                end
            end
            if (visible.root),  
                % drawing root
                X1 = [Xi(3);Zi(3);-Yi(3)]; % chest
                X3 = [Xi(7);Zi(7);-Yi(7)]; %rshoulder 
                X4 = [Xi(11);Zi(11);-Yi(11)]; %lshoulder                       
                X5 = [Xi(14);Zi(14);-Yi(14)]; %rhip 
                X6 = [Xi(17);Zi(17);-Yi(17)]; %lhip
                X2 = 0.5*(X5+X6); % mean of hips
                renderpart('root',[X1,X2,X3,X4,X5,X6],.65,option.shape,shade,filetype);    
            end
            if (visible.chest),
                %drawing chest
                X1 = [Xi(1);Zi(1);-Yi(1)]; % root
                X3 = [Xi(14);Zi(14);-Yi(14)]; %rhip 
                X4 = [Xi(17);Zi(17);-Yi(17)]; %lhip            
                X5 = [Xi(7);Zi(7);-Yi(7)]; %rshoulder          
                X6 = [Xi(11);Zi(11);-Yi(11)]; %lshoulder
                X2 = 0.5*(X5+X6); % mean of shoulders
                renderpart('ches',[X1,X2,X3,X4,X5,X6],.65,option.shape,shade,filetype);
            end
        case 'stick'
            for i=2:21,
                if (~isempty(children{i})),  
                    X1 = [Xi(i);Zi(i);-Yi(i)];
                    X2 = [Xi(children{i}(1));Zi(children{i}(1));-Yi(children{i}(1))];
                    renderpart('limb',[X1,X2],1,option.shape,shade,filetype);
                end
                i=1;
                X1 = [Xi(i);Zi(i);-Yi(i)];
                X2 = [Xi(children{i}(13));Zi(children{i}(13));-Yi(children{i}(13))];
                renderpart('limb',[X1,X2],1,option.shape,shade,filetype);
                X1 = [Xi(i);Zi(i);-Yi(i)];
                X2 = [Xi(children{i}(16));Zi(children{i}(16));-Yi(children{i}(16))];
                renderpart('limb',[X1,X2],1,option.shape,shade,filetype);
            end 
        case 'nodes'
            for i=1:21,
                X1 = [Xi(i);Zi(i);-Yi(i)];
                renderjoint(X1,1);
                %renderjoint(X1,1.3);
            end
        case 'graph'
            % first draw the nodes
            %for i=1:21,
            for i=1:19, % changed just to produce the 18-joint stick man for pami
                X1 = [Xi(i);Zi(i);-Yi(i)];
                %renderjoint(X1,1);
                renderjoint(X1,1); % changed just to produce the 18-joint stick man for pami
            end
            for i=1:21,
                for j=1:21,
                    if (adjmat(i,j)==1),
                        X1 = [Xi(i);Zi(i);-Yi(i)];
                        X2 = [Xi(j);Zi(j);-Yi(j)];
                        %renderpart('limb',[X1,X2],.8,option.shape,shade,filetype);
                        renderpart('limb',[X1,X2],.4,option.shape,shade,filetype); % changed just to produce the 18-joint stick man for pami
                    end
                end
            end                        
    end % switch 'option.style'
    
    if (option.render=='surf'),
        shading interp; % turn this off for the mesh to appear with lighting
        lighting gouraud; 
       %lighting none; % light none only for produced masks needed for composite images 
        camlight infinite; 
    end
    if (~isempty(moviefile)),
        mov = addframe(mov,getframe(fig));                        
    end
    %pause(1/120);
    pause;
    dump_images=0;
    %dump_dir = '/home/gloucester/aagarwal/NewData/matlab/UpperBody_V4HCI/matlab/TrackA';
    %dump_dir = '/home/gloucester/aagarwal/NewData/matnew/FExperiments1/accv_videos/test29_02smooth/orig_masks';
    %dump_dir = '/scratch/gloucester/aagarwal/NewData/post_cvpr05/desc_experiments/test_recs';
    %dump_dir = '/scratch/gloucester/aagarwal/NewData/post_cvpr05/desc_experiments/val_recs';    
    dump_dir = '/home/gloucester/aagarwal/NewData/matnew/FExperiments1/accv_videos/NEWCASE/test29_02/orig_masks';    
    %dump_dir = '/home/gloucester/aagarwal/NewData/matnew/FExperiments1/accv_videos/TRAINDATA/train26_02/reconstructed';    
    
    if (dump_images),
        axis('off');    
        print(gcf,'-dpng',sprintf('%s/%04d.png',dump_dir,nf));
        temp_img = imread(sprintf('%s/%04d.png',dump_dir,nf));        
        %temp_img = temp_img(100:799,445:794,:); % for black man videos
        
        %temp_img = temp_img(100:799,365:874,:); % wider for arm movements

        % accv real man
        temp_img = temp_img(126:505,384:855,:);
        temp_img([1:4,end-3:end],:,:) = 0;temp_img(:,[1:4,end-3:end],:) = 0;
        % 
        
        imwrite(temp_img,sprintf('%s/%04d.png',dump_dir,nf),'png');
        axis('on');
    end
end

if (~isempty(moviefile)),
    mov = close(mov)
    fprintf('\n MAKING THE VIDEO.... please wait :)');
    % compressing the avi file
    unix(sprintf('cat temp.avi | mencoder -ovc lavc -lavcopts vcodec=msmpeg4v2 -o %s -; rm -rf temp.avi',moviefile));
end
    