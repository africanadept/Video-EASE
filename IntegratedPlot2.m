ekwebody=load('IBO_140703_A_02_03_EkweBody_fr1.mat');
ekwestick=load('IBO_140703_A_02_03_EkweStick_fr1.mat');
leftbeater=load('IBO_140703_A_02_03_LeftBeater_fr1.mat');
rightbeater=load('IBO_140703_A_02_03_RightBeater_fr1.mat');
load('IBO_140703_A_02_03.mat');

[ekwe,n] = midi2nmat('IBO_140703_A_02_03_Ekwe.mid');
ekons=ekwe(:,6);
[udu,n] = midi2nmat('IBO_140703_A_02_03_Udu.mid');
udu(1,:)=[];
udons=udu(:,6);

eb=ekwebody.motion;
es=ekwestick.motion;
lb=leftbeater.motion;
rb=rightbeater.motion;


fig=figure(1)
screensize = get( groot, 'Screensize' );
set(fig,'Color','k','Name','Video-EASE','Position', screensize*.9);

filename = 'IBO_140703_S_02_03_IntegratedPlot.gif';

%Integrated plot

%whitebg(1,'k');



%% subplot 221 motion tracking
subplot(2,2,1);
imhandle(1)=imagesc(v.video(:,:,:,1));
set(gca,'Color','k','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
title(strcat('\fontsize{30}','Motion Tracking: Frame',sprintf(' %d',1),' of', ...
    sprintf(' %d',length(rb(:,1)))),'Color','w');
xlabel('Horizontal Pixels','FontSize',16,'Color','w');
ylabel('Vertical Pixels','FontSize',16,'Color','w');

hold on
hMov1(1)=plot(lb(1,2),lb(1,3),'m+','MarkerSize',30,'LineWidth', 5);
hMov2(1)=plot(rb(1,2),rb(1,3),'g+','MarkerSize',30,'LineWidth', 5);
hMov3(1)=plot(es(1,2),es(1,3),'r+','MarkerSize',30,'LineWidth', 5);
hMov4(1)=plot(eb(1,2),eb(1,3),'c+','MarkerSize',30,'LineWidth', 5);
%ylim([0 550]);
%xlim([0 3]);
axis ij
ref=1;
ref2=1;
for k = 2:length(rb(:,1))-1
    
end
hold off

%% subplot 222 vertical
subplot(2,2,2)
plot(lb(1,1),lb(1,3),'m-.');
set(gca,'Color','k','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
title(strcat('\fontsize{30}','Vertical Motion at',sprintf(' %f',rb(1,1)),' seconds'),'Color','w');
hold on
xlabel('Time (sec)','FontSize',16,'Color','w');
ylabel('Vertical Pixels','FontSize',16,'Color','w');
plot(rb(1,1),rb(1,3),'g-.');
plot(es(1,1),es(1,3),'r-.');
plot(eb(1,1),eb(1,3),'c-.');
hlegend=legend('Left Beater','Right Beater','Ekwe Stick','Ekwe Body');
set(hlegend,'FontSize',16,'Color','w');
ylim([0 550]);
xlim([-1.5 1.5]);
axis ij

h1=animatedline(lb(1,1),lb(1,3),'Color','m');
h2=animatedline(rb(1,1),rb(1,3),'Color','g');
h3=animatedline(es(1,1),es(1,3),'Color','r');
h4=animatedline(eb(1,1),eb(1,3),'Color','c');

hold off

%% Subplot 223 Midi
subplot(2,2,3)
hudu(1)=plot([udu(1,1) (udu(1,1)+udu(1,2))], [udu(1,4) udu(1,4)],'LineWidth', 10);
hold on
if udu(1,4) > 38
    hudu(1).Color=[0,1,0,(udu(1,5)-min(udu(:,5))+20)/(max(udu(:,5))-min(udu(:,5))+20)];%green
else
    hudu(1).Color=[1,0,1,(udu(1,5)-min(udu(:,5))+20)/(max(udu(:,5))-min(udu(:,5))+20)]; %magenta
end
set(gca,'Color','k','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
title(strcat('\fontsize{30}','Music Transcription'),'Color','w');
xlabel('Time (sec)','FontSize',16,'Color','w');
ylabel('MIDI Pitch (C4=60)','FontSize',16,'Color','w');

for i=2:numel(udons)
    hudu(i)=plot([udu(i,1) (udu(i,1)+udu(i,2))], [udu(i,4) udu(i,4)],'LineWidth',10);
    if udu(i,4) > 38
        hudu(i).Color=[0,1,0,(udu(i,5)-min(udu(:,5))+20)/(max(udu(:,5))-min(udu(:,5))+20)];%green
    else
        hudu(i).Color=[1,0,1,(udu(i,5)-min(udu(:,5))+20)/(max(udu(:,5))-min(udu(:,5))+20)]; %magenta
    end
end
hekw(1)=plot([ekwe(1,1) (ekwe(1,1)+ekwe(1,2))], [ekwe(1,4) ekwe(1,4)],'Color','c','LineWidth', 10);
for i=2:numel(udons)
    hekw(i)=plot([ekwe(i,1) (ekwe(i,1)+ekwe(i,2))], [ekwe(i,4) ekwe(i,4)],'LineWidth',10);
    hekw(i).Color=[0,1,1,(ekwe(i,5)-min(ekwe(:,5)))/(max(ekwe(:,5))-min(ekwe(:,5)))];%red
end
lmidi(1)=plot([0 0],[32 72],'Color','w','LineWidth',3);
ylim([32 72])
xlim([-1.5 1.5]);
drawnow

hold off

%% subplot 224 horizontal
subplot(2,2,4)
plot(lb(1,2),lb(1,1),'m-.');
set(gca,'Color','k','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
title(strcat('\fontsize{30}','Horizontal Motion at',sprintf(' %f',rb(1,1)),' seconds'),'Color','w');
hold on
xlabel('Horizontal Pixels','FontSize',16,'Color','w');
ylabel('Time (sec)','FontSize',16,'Color','w');
plot(rb(1,2),rb(1,1),'g-.');
plot(es(1,2),es(1,1),'r-.');
plot(eb(1,2),eb(1,1),'c-.');
% hlegend=legend('Left Beater','Right Beater','Ekwe Stick','Ekwe Body');
% set(hlegend,'FontSize',16,'Color','w');
ylim([-1.5 1.5]);
xlim([200 1400]);
axis ij

hh1=animatedline(lb(1,2),lb(1,1),'Color','m');
hh2=animatedline(rb(1,2),rb(1,1),'Color','g');
hh3=animatedline(es(1,2),es(1,1),'Color','r');
hh4=animatedline(eb(1,2),eb(1,1),'Color','c');

hold off


%% Indexes
ref=1;
ref2=1;

for k = 2:length(rb(:,1))
    
    %% subplot 221 motion tracking
    
    subplot(2,2,1);
    delete(imhandle(k-1));
    delete(hMov1(k-1));
    delete(hMov2(k-1));
    delete(hMov3(k-1));
    delete(hMov4(k-1));
    hold on
    
    if udons(ref2)<= lb(k,1)
        set(gca,'Color','w','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
        imhandle(k)=imagesc([0,0,0]);   
    elseif ekons(ref)<= lb(k,1) && ekons(ref) >= lb(k-1,1)
        set(gca,'Color','w','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
        imhandle(k)=imagesc([0,0,0]);
    else
        set(gca,'Color','k','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
        imhandle(k)=imagesc(v.video(:,:,:,k));
    end
    
    title(strcat('\fontsize{30}','Motion Tracking: Frame',sprintf(' %d',k),' of', ...
        sprintf(' %d',length(rb(:,1)))),'Color','w');
    hMov1(k)=plot(lb(k,2),lb(k,3),'m+','MarkerSize',30,'LineWidth', 5);
    hMov2(k)=plot(rb(k,2),rb(k,3),'g+','MarkerSize',30,'LineWidth', 5);
    hMov3(k)=plot(es(k,2),es(k,3),'r+','MarkerSize',30,'LineWidth', 5);
    hMov4(k)=plot(eb(k,2),eb(k,3),'c+','MarkerSize',30,'LineWidth', 5);
    drawnow
    hold off
    
    %% subplot222 Vertical Motion
    subplot(2,2,2)
    hold on
    %set(gca,'Color','k','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
    if udons(ref2)<= lb(k,1)
        plot([udons(ref2) udons(ref2)],[275, 600],'w');   
    end
    if ekons(ref)<= lb(k,1) && ekons(ref) >= lb(k-1,1)  
        plot([ekons(ref) ekons(ref)], [0, 275], 'w');  
    end

    addpoints(h1,lb(k,1),lb(k,3));
    addpoints(h2,rb(k,1),rb(k,3));
    addpoints(h3,es(k,1),es(k,3));
    addpoints(h4,eb(k,1),eb(k,3));
    title(strcat('\fontsize{30}','Vertical Motion at',sprintf(' %4.2f',rb(k,1)),' seconds'),'Color','w');
    
    xlim([lb(k,1)-1.5 lb(k,1)+1.5]);
    
    drawnow
    hold off
    
    
    %% subplot 223 midi
    subplot(2,2,3)
    hold on
    %     set(gca,'Color','k','FontSize',16,'FontWeight','bold');
    % title(strcat('\fontsize{30}',''),'Color','w');
    % xlabel('Time (seconds)','FontSize',16,'Color','w');
    % ylabel('MIDI Pitch (C4=60)','FontSize',16,'Color','w');
    delete(lmidi(k-1));
    xlim([lb(k,1)-1.5 lb(k,1)+1.5]);
    lmidi(k)=line([lb(k,1) lb(k,1)],[32 72],'Color','w','LineWidth',3);
    drawnow
    
    hold off
    
    %% subplot 224 horizontal
    subplot(2,2,4)
    hold on
    if udons(ref2)<= lb(k,1)
        plot([200, 800],[udons(ref2) udons(ref2)],'w');
        
        if ref2 <numel(udons)
            ref2=ref2+1;
        end
    end
    if ekons(ref)<= lb(k,1) && ekons(ref) >= lb(k-1,1)
        
        plot([800, 1400],[ekons(ref) ekons(ref)], 'w');
        if ref <numel(ekons)
            ref=ref+1;
            
        end
    end
    
    
    addpoints(hh1,lb(k,2),lb(k,1));
    addpoints(hh2,rb(k,2),rb(k,1));
    addpoints(hh3,es(k,2),es(k,1));
    addpoints(hh4,eb(k,2),eb(k,1));
    title(strcat('\fontsize{30}','Horizontal Motion at',sprintf(' %4.2f',rb(k,1)),' seconds'),'Color','w');
    
    % if lb(k,1) > 1.5 && lb(k,1) < 13.5
    ylim([lb(k,1)-1.5 lb(k,1)+1.5]);
    % end
    drawnow
    hold off
    
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
    sprintf(' %d',length(rb(:,1)))),'Color','w');
hMov1(end)=plot(lb(end,2),lb(end,3),'m+','MarkerSize',30,'LineWidth', 5);
hMov2(end)=plot(rb(end,2),rb(end,3),'g+','MarkerSize',30,'LineWidth', 5);
hMov3(end)=plot(es(end,2),es(end,3),'r+','MarkerSize',30,'LineWidth', 5);
hMov4(end)=plot(eb(end,2),eb(end,3),'c+','MarkerSize',30,'LineWidth', 5);

hold off
drawnow
frame = getframe(fig);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
imwrite(imind,cm,filename,'gif','WriteMode','append');
