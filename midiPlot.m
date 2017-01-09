function midiPlot(filename)
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
  end

end

screensize = get( groot, 'Screensize' );
fig=figure(1);

set(fig,'Color','k','Name','Video-EASE','Position', screensize*.9);

filename = [filename,'_IntegratedPlot_MIDIPlot.gif'];

%MIDI plot

totalcolors=numel(midi);
% cmap1 = hsv(totalcolors);
% randomRows = randi(size(cmap1, 1), [totalcolors, 1])
% % Extract the rows from the combined color map.
% cmap1 = cmap1(randomRows, :)
cmap1 = hsv(totalcolors);
colorind=1;

% for i=1:numel(motion)
%     motionhsv{i}=cmap1(colorind,:);
%     colorind=colorind+1;
% end

for i=1:numel(midi)
    midihsv{i}=cmap1(colorind,:);
    colorind=colorind+1;
end



%% Subplot 223 Midi
%subplot(2,2,3)
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

bignmat=midi{1};
if numel(midi) > 1
for i=2:numel(midi)
    bignmat=[bignmat;midi{i}];
end
end
ymin=min(bignmat(:,4));
ymax=max(bignmat(:,4));
yrange=ymax-ymin;

ylim([ymin-.1*yrange ymax+.1*yrange]);
xlim([-1.5 1.5]);
drawnow

hold off



%% ANIMATION

for k = 2:length(motion{1}(:,1))
    
   
    
    
    % subplot 223 midi
   % subplot(2,2,3)
    hold on
    delete(lmidi(k-1));
    xlim([motion{i}(k,1)-1.5 motion{i}(k,1)+1.5]);
    lmidi(k)=line([motion{i}(k,1) motion{i}(k,1)],[32 72],'Color','w','LineWidth',3);
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
