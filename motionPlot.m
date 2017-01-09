function motionPlot(filename,type,lim)

files=dir;
motionref=1;
midiref=1;
for i=1:numel(files)
    try
        if strcmp(files(i).name(1:length(filename)),filename)==1
            if strcmp(files(i).name(end-3:end),'.mat')==1
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



%motion plot

totalcolors=numel(motion)+numel(midi);
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


%% Indexes

for i=1:numel(midi)
    ref{i}=1;
end



screensize = get( groot, 'Screensize' );
fig=figure(1);
set(fig,'Color','k','Name','Video-EASE','Position', screensize*.9);

%% vertical
if strcmp(type,'v')==1
    filename = [filename,'_MotionPlot_Vertical.gif'];
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
    try
            ylim(lim);
    catch
            lim=[0 550];

    ylim(lim);
    end
    xlim([-1.5 1.5]);
    axis ij
    
    for k = 2:length(motion{1}(:,1))
        %set(gca,'Color','k','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
        try
            for i=1:numel(midi)
                if midi{i}(ref{i},6)<= motion{1}(k,1) && ref{i} <=numel(midi{i}(:,6))
                    plot([midi{i}(ref{i}) midi{i}(ref{i})],[0, 600],'w');
                    ref{i}=ref{i}+1;
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
    hold off
    
    
    
    %% horizontal
    
elseif strcmp(type,'h')==1
    for i=1:numel(motion)
        hh{i}=animatedline(motion{i}(1,2),motion{i}(1,1),'Color',motionhsv{i});
    end
    set(gca,'Color','k','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
    title(strcat('\fontsize{30}','Horizontal Motion at',sprintf(' %f',motion{1}(1,1)),' seconds'),'Color','w');
    hold on
    xlabel('Horizontal Pixels','FontSize',16,'Color','w');
    ylabel('Time (sec)','FontSize',16,'Color','w');
    
    
    ylim([-1.5 1.5]);
    
        try
            xlim(lim);
    catch
            lim=[200 1400];

    xlim(lim);
    end
    
    axis ij
    
    
    
     for k = 2:length(motion{1}(:,1))   
    
    for i=1:numel(midi)
        try
            if midi{i}(ref{i},6)<= motion{1}(k,1) && ref{i} <=numel(midi{i}(:,6))
                plot(lim,[midi{i}(ref{i}) midi{i}(ref{i})],'w');
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

         hold off 
end
% else
%    subplot(2,1,1)
%      filename = [filename,'_MotionPlot_Vertical.gif'];
%     hold on
%     for i=1:numel(motion)
%         h{i}=animatedline(motion{i}(1,1),motion{i}(1,3),'Color',motionhsv{i});
%     end
%     set(gca,'Color','k','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
%     title(strcat('\fontsize{30}','Vertical Motion at',sprintf(' %f',motion{1}(1,1)),' seconds'),'Color','w');
%     hold on
%     xlabel('Time (sec)','FontSize',16,'Color','w');
%     ylabel('Vertical Pixels','FontSize',16,'Color','w');
%     
%     
%     hlegend=legend(motionid);
%     set(hlegend,'FontSize',16,'Color','w');
%     ylim([0 550]);
%     xlim([-1.5 1.5]);
%     axis ij
% 
%    subplot(2,1,2)    
%     for i=1:numel(motion)
%         hh{i}=animatedline(motion{i}(1,2),motion{i}(1,1),'Color',motionhsv{i});
%     end
%     set(gca,'Color','k','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
%     title(strcat('\fontsize{30}','Horizontal Motion at',sprintf(' %f',motion{1}(1,1)),' seconds'),'Color','w');
%     hold on
%     xlabel('Horizontal Pixels','FontSize',16,'Color','w');
%     ylabel('Time (sec)','FontSize',16,'Color','w');
%     
%     
%     ylim([-1.5 1.5]);
%     xlim([200 1400]);
%     axis ij
%     
%     
%     
%     for k = 2:length(motion{1}(:,1))
%         %set(gca,'Color','k','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
%         try
%             for i=1:numel(midi)
%                 if midi{i}(ref{i},6)<= motion{1}(k,1) && ref{i} <=numel(midi{i}(:,6))
%                     plot([midi{i}(ref{i}) midi{i}(ref{i})],[0, 600],'w');
%                 end
%             end
%         catch
%         end
%         for i=1:numel(motion)
%             addpoints(h{i},motion{i}(k,1),motion{i}(k,3));
%         end
%         title(strcat('\fontsize{30}','Vertical Motion at',sprintf(' %4.2f',motion{i}(k,1)),' seconds'),'Color','w');
%         
%         xlim([motion{i}(k,1)-1.5 motion{i}(k,1)+1.5]);
%         
%         drawnow
% 
% 
%     
%     %% horizontal
%     
% 
%     
%   
%     
%     for i=1:numel(midi)
%         try
%             if midi{i}(ref{i},6)<= motion{1}(k,1) && ref{i} <=numel(midi{i}(:,6))
%                 plot([200, 1400],[midi{i}(ref{i}) midi{i}(ref{i})],'w');
%                 ref{i}=ref{i}+1;
%             end
%         catch
%         end
%     end
%     for i=1:numel(motion)
%         addpoints(hh{i},motion{i}(k,2),motion{i}(k,1));
%     end
%     title(strcat('\fontsize{30}','Horizontal Motion at',sprintf(' %4.2f',motion{i}(k,1)),' seconds'),'Color','w');
%     
%     ylim([motion{i}(k,1)-1.5 motion{i}(k,1)+1.5]);
%     
%     drawnow
% 
%     
%     %% add to animated gif file
%     frame = getframe(fig);
%     im = frame2im(frame);
%     [imind,cm] = rgb2ind(im,256);
%     if k == 2
%         imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
%     else
%         imwrite(imind,cm,filename,'gif','WriteMode','append');
%     end
%    
%     
%      end
% 
%          hold off 
%     
%     
% end


end