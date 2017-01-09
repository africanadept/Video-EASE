function integratedPlot(input)

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
                load(files(i).name);
            elseif strcmp(files(i).name(end-3:end),'.mat')==1
                motionid{motionref}=files(i).name(length(filename)+2:end-4);
                temp=load(files(i).name);
                motion{motionref}=temp.motion;
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

totalcolors=numel(motion)+numel(midi);
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

for i=1:numel(midi)
    midihsv{i}=cmap1(colorind,:);
    colorind=colorind+1;
end

%% subplot 221 motion tracking
subplot(2,2,1);
imhandle(1)=imagesc(v.video(:,:,:,1));
set(gca,'Color','k','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
title(strcat('\fontsize{30}','Motion Tracking: Frame',sprintf(' %d',1),' of', ...
    sprintf(' %d',length(motion{1}(:,1)))),'Color','w');
xlabel('Horizontal Pixels','FontSize',16,'Color','w');
ylabel('Vertical Pixels','FontSize',16,'Color','w');

hold on
for i=1:numel(motion)
    hMov{i}(1)=plot(motion{i}(1,2),motion{i}(1,3),...
        'Color',motionhsv{i},'Marker','+','MarkerSize',30,'LineWidth', 5);
end
axis ij


hold off


%% Indexes

for i=1:numel(midi)
    ref{i}=1;
end

%% subplot 222 vertical
subplot(2,2,2)
hold on
for i=1:numel(motion)
    h{i}=animatedline(motion{i}(1,1),motion{i}(1,3),'Color',motionhsv{i});
end
set(gca,'Color','k','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
title(strcat('\fontsize{30}','Vertical Motion at',sprintf(' %f',motion{1}(1,1)),' seconds'),'Color','w');
hold on
xlabel('Time (sec)','FontSize',16,'Color','w');
ylabel('Vertical Pixels','FontSize',16,'Color','w');


hlegend=legend(motionid);
set(hlegend,'FontSize',16,'Color','w');
ylim([0 550]);
xlim([-1.5 1.5]);
axis ij

hold off

%% Subplot 223 Midi
subplot(2,2,3)
hmid{1}(1)=plot([midi{1}(1,1) (midi{1}(1,1)+midi{1}(1,2))], [midi{1}(1,4) midi{1}(1,4)],'Color',midihsv{1},'LineWidth', 10);
hold on
% if udu(1,4) > 38
%     hudu(1).Color=[0,1,0,(udu(1,5)-min(udu(:,5))+20)/(max(udu(:,5))-min(udu(:,5))+20)];%green
% else
%     hudu(1).Color=[1,0,1,(udu(1,5)-min(udu(:,5))+20)/(max(udu(:,5))-min(udu(:,5))+20)]; %magenta
% end
set(gca,'Color','k','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
title(strcat('\fontsize{30}','Music Transcription'),'Color','w');
xlabel('Time (sec)','FontSize',16,'Color','w');
ylabel('MIDI Pitch (C4=60)','FontSize',16,'Color','w');

for i=1:numel(midi)
    for j=1:numel(midi{i}(:,1))
        hmid{j}(i)=plot([midi{i}(j,1) (midi{i}(j,1)+midi{i}(j,2))], ...
            [midi{i}(j,4) midi{i}(j,4)],'Color',midihsv{i},'LineWidth', 10);
    end
end

lmidi(1)=plot([0 0],[32 72],'Color','w','LineWidth',3);
ylim([32 72])
xlim([-1.5 1.5]);
drawnow

hold off

%% subplot 224 horizontal
subplot(2,2,4)
for i=1:numel(motion)
    hh{i}=animatedline(motion{i}(1,2),motion{i}(1,1),'Color',motionhsv{i});
end
set(gca,'Color','k','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
title(strcat('\fontsize{30}','Horizontal Motion at',sprintf(' %f',motion{1}(1,1)),' seconds'),'Color','w');
hold on
xlabel('Horizontal Pixels','FontSize',16,'Color','w');
ylabel('Time (sec)','FontSize',16,'Color','w');


ylim([-1.5 1.5]);
xlim([200 1400]);
axis ij



hold off

%% ANIMATION

for k = 2:length(motion{1}(:,1))
    
    %% subplot 221 motion tracking
    
    subplot(2,2,1);
    delete(imhandle(k-1));
    for i=1:numel(motion)
        delete(hMov{i}(k-1));
    end
    hold on
    
    whitescreen=0;
    for i=1:numel(midi)
        try
            if midi{i}(ref{i},6)<= motion{1}(k,1) && ref{i} <=numel(midi{i}(:,6))
                whitescreen=1;
            end
        catch
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
            'Color',motionhsv{i},'Marker','+','MarkerSize',30,'LineWidth', 5);
    end
    drawnow
    hold off
    
    %% subplot222 Vertical Motion
    subplot(2,2,2)
    hold on
    %set(gca,'Color','k','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
    try
        for i=1:numel(midi)
            if midi{i}(ref{i},6)<= motion{1}(k,1) && ref{i} <=numel(midi{i}(:,6))
                plot([midi{i}(ref{i}) midi{i}(ref{i})],[0, 600],'w');
            end
        end
    catch
    end
    for i=1:numel(motion)
        addpoints(h{i},motion{i}(k,1),motion{i}(k,3));
    end
    title(strcat('\fontsize{30}','Vertical Motion at',sprintf(' %4.2f',motion{i}(k,1)),' seconds'),'Color','w');
    
    xlim([motion{i}(k,1)-1.5 motion{i}(k,1)+1.5]);
    
    drawnow
    hold off
    
    
    %% subplot 223 midi
    subplot(2,2,3)
    hold on
    delete(lmidi(k-1));
    xlim([motion{i}(k,1)-1.5 motion{i}(k,1)+1.5]);
    lmidi(k)=line([motion{i}(k,1) motion{i}(k,1)],[32 72],'Color','w','LineWidth',3);
    drawnow
    hold off
    
    %% subplot 224 horizontal
    subplot(2,2,4)
    hold on
    
    for i=1:numel(midi)
        try
            if midi{i}(ref{i},6)<= motion{1}(k,1) && ref{i} <=numel(midi{i}(:,6))
                plot([200, 1400],[midi{i}(ref{i}) midi{i}(ref{i})],'w');
                ref{i}=ref{i}+1;
            end
        catch
        end
    end
    for i=1:numel(motion)
        addpoints(hh{i},motion{i}(k,2),motion{i}(k,1));
    end
    title(strcat('\fontsize{30}','Horizontal Motion at',sprintf(' %4.2f',motion{i}(k,1)),' seconds'),'Color','w');
    
    ylim([motion{i}(k,1)-1.5 motion{i}(k,1)+1.5]);
    
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

%% subplot 221 motion tracking
subplot(2,2,1)
hold on
imhandle(end)=imagesc(v.video(:,:,:,end));
%set(gca,'Color','k','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
title(strcat('\fontsize{30}','Motion Tracking: Frame',sprintf(' %d',k),' of', ...
    sprintf(' %d',length(motion{1}(:,1)))),'Color','w');

for i=1:numel(motion)
    hMov{i}(end)=plot(motion{i}(end,2),motion{i}(end,3),'Color',motionhsv{i},'MarkerSize',30,'LineWidth', 5);
end

hold off
drawnow
frame = getframe(fig);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,filename,'gif','WriteMode','append');

end