function videoPlot(input)

if isstruct(input)
v=input;
filename=v.filename;
else
    filename=input;
end

files=dir;
motionref=1;
midiref=1;
for i=1:numel(files)
    try
        if strcmp(files(i).name(1:length(filename)),filename)==1
            if strcmp(files(i).name,[filename,'.mat'])==1
                if exist('v')==0
                load(files(i).name);
                end
            elseif strcmp(files(i).name(end-3:end),'.mat')==1
                motionid{motionref}=files(i).name(length(filename)+2:end-4);
                temp=load(files(i).name);
                try
                    frameint=str2num(files(i).name(end-4));
                    if frameint > 1
                        clearvars newmotion
                        frameincrement=1/v.fps;
                        for j=1:numel(temp.motion(:,1))
                            newmotion(j*frameint-2:j*frameint,:)=[temp.motion(j,:);temp.motion(j,:);temp.motion(j,:)];
                            newmotion(j*frameint-1,1)=newmotion(j*frameint-2,1)+frameincrement;
                            newmotion(j*frameint,1)=newmotion(j*frameint-1,1)+frameincrement;
                        end
                        motion{motionref}=newmotion;
                    else
                        motion{motionref}=temp.motion;
                    end
                catch                                        
                    motion{motionref}=temp.motion;
                end
                motionref=motionref+1;
            elseif strcmp(files(i).name(end-3:end),'.mid')==1
                midiid{midiref}=files(i).name(length(filename)+2:end-4);
                midi{midiref}=midi2nmat(files(i).name);
                midiref=midiref+1;
            end
        end
    catch
        continue
    end
end

screensize = get( groot, 'Screensize' );
fig=figure(1);

set(fig,'Color','k','Name','Video-EASE','Position', screensize*.9);

filename = [filename,'_IntegratedPlot.gif'];

%Integrated plot
try
totalcolors=numel(motion)+numel(midi);
catch
totalcolors=numel(motion);
end
% cmap1 = hsv(totalcolors);
% randomRows = randi(size(cmap1, 1), [totalcolors, 1])
% % Extract the rows from the combined color map.
% cmap1 = cmap1(randomRows, :)
cmap1 = hsv(totalcolors);
colorind=1;

for i=1:numel(motion)
    motionhsv{i}=cmap1(colorind,:);
    colorind=colorind+1;
end

if exist('midi')~=0
for i=1:numel(midi)
    midihsv{i}=cmap1(colorind,:);
    colorind=colorind+1;
end
end

%% motion tracking
imhandle(1)=imagesc(v.video(:,:,:,1));
set(gca,'Color','k','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
title(strcat('\fontsize{30}','Motion Tracking: Frame',sprintf(' %d',1),' of', ...
    sprintf(' %d',length(motion{1}(:,1)))),'Color','w');
xlabel('Horizontal Pixels','FontSize',16,'Color','w');
ylabel('Vertical Pixels','FontSize',16,'Color','w');

hold on
for i=1:numel(motion)
    hMov{i}(1)=plot(motion{i}(1,2),motion{i}(1,3),...
        'Color',motionhsv{i},'Marker','+','MarkerSize',60,'LineWidth', 5);
end
axis ij

drawnow
hold off



%% Indexes
if exist('midi')~=0
for i=1:numel(midi)
    ref{i}=1;
end
end



%% ANIMATION

for k = 2:length(motion{1}(:,1))
    
    %% subplot 221 motion tracking
    
    
    delete(imhandle(k-1));
    for i=1:numel(motion)
        delete(hMov{i}(k-1));
    end
    hold on
    
    whitescreen=0;
    if exist('midi')~=0
    for i=1:numel(midi)
        try
            if midi{i}(ref{i},6)<= motion{1}(k,1) && ref{i} <=numel(midi{i}(:,6))
                whitescreen=1;
                ref{i}=ref{i}+1;
            end
        catch
        end
    end
    end
    set(gca,'Color','w','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
    imhandle(k)=imagesc([0,0,0]);
    if whitescreen==1
        set(gca,'Color','w','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
        imhandle(k)=imagesc([0,0,0]);
    else
        set(gca,'Color','k','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
        imhandle(k)=imagesc(v.video(:,:,:,k));
    end
    whitescreen=0;
    
    title(strcat('\fontsize{30}','Motion Tracking: Frame',sprintf(' %d',k),' of', ...
        sprintf(' %d',length(motion{1}(:,1)))),'Color','w');
    for i=1:numel(motion)
        hMov{i}(k)=plot(motion{i}(k,2),motion{i}(k,3),...
            'Color',motionhsv{i},'Marker','+','MarkerSize',60,'LineWidth', 5);
    end
    drawnow
    hold off
    
    
    
    %% add to animated gif file
    frame = getframe(fig);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if k == 2
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append');
    end
    
    
end

%% final screen motion tracking

hold on
imhandle(end)=imagesc(v.video(:,:,:,end));
%set(gca,'Color','k','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
title(strcat('\fontsize{30}','Motion Tracking: Frame',sprintf(' %d',k),' of', ...
    sprintf(' %d',length(motion{1}(:,1)))),'Color','w');

for i=1:numel(motion)
    hMov{i}(end)=plot(motion{i}(end,2),motion{i}(end,3),'Color',motionhsv{i},'MarkerSize',60,'LineWidth', 5);
end

hold off
drawnow
frame = getframe(fig);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,filename,'gif','WriteMode','append');

end