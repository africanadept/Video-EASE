%% IBO_140703_A_02_03
%% Motion Tracking

ekwebody=load('IBO_140703_A_02_03_EkweBody_fr1.mat');
ekwestick=load('IBO_140703_A_02_03_EkweStick_fr1.mat');
leftbeater=load('IBO_140703_A_02_03_LeftBeater_fr1.mat');
rightbeater=load('IBO_140703_A_02_03_RightBeater_fr1.mat');


[ekwe,n] = midi2nmat('IBO_140703_A_02_03_Ekwe.mid')
ekons=ekwe(:,6)
[udu,n] = midi2nmat('IBO_140703_A_02_03_Udu.mid')
udu(1,:)=[];
udons=udu(:,6)

eb=ekwebody.motion;
es=ekwestick.motion;
lb=leftbeater.motion;
rb=rightbeater.motion;

%motion tracking plot
fig=figure()
filename = 'IBO_140703_S_02_03_AnimatedMovement.gif';
screensize = get( groot, 'Screensize' );
set(fig,'Color','k','Name','Video-EASE','Position', screensize*.9);
%whitebg(1,'k');
imhandle(1)=imagesc(v.video(:,:,:,1));
set(gca,'Color','k','FontSize',16,'FontWeight','bold');
title(strcat('\fontsize{30}','Motion Tracking: Frame',sprintf(' %d',1),' of', ...
    sprintf(' %d',length(rb(:,1)))),'Color','w');
% xlabel('Time (sec)','FontSize',16,'Color','w');
% ylabel('Vertical Pixels','FontSize',16,'Color','w');
hold on
h1(1)=plot(lb(1,2),lb(1,3),'m+','MarkerSize',30,'LineWidth', 5);
h2(1)=plot(rb(1,2),rb(1,3),'g+','MarkerSize',30,'LineWidth', 5);
h3(1)=plot(es(1,2),es(1,3),'r+','MarkerSize',30,'LineWidth', 5);
h4(1)=plot(eb(1,2),eb(1,3),'c+','MarkerSize',30,'LineWidth', 5);
%ylim([0 550]);
%xlim([0 3]);
axis ij
ref=1;
ref2=1;
for k = 2:length(rb(:,1))-1
    
    delete(imhandle(k-1));
    delete(h1(k-1));
    delete(h2(k-1));
    delete(h3(k-1));
    delete(h4(k-1));
    
    if udons(ref2)<= lb(k,1)
        %plot([udons(ref2) udons(ref2)],[275, 600],'w');x = rand(150)*1.5-3;
        set(gca,'Color','w');
        imhandle(k)=imagesc([0,0,0]);
        
        if ref2 <numel(udons)
            ref2=ref2+1;
        end
    elseif ekons(ref)<= lb(k,1) && ekons(ref) >= lb(k-1,1)
        set(gca,'Color','w');
        imhandle(k)=imagesc([0,0,0]);
        
        %plot([ekons(ref) ekons(ref)], [0, 275], 'w');
        if ref <numel(ekons)
            ref=ref+1;
            
        end
    else
        set(gca,'Color','k');
        imhandle(k)=imagesc(v.video(:,:,:,k));
    end
    title(strcat('\fontsize{30}','Motion Tracking: Frame',sprintf(' %d',k),' of', ...
        sprintf(' %d',length(rb(:,1)))),'Color','w');
    h1(k)=plot(lb(k,2),lb(k,3),'m+','MarkerSize',30,'LineWidth', 5);
    h2(k)=plot(rb(k,2),rb(k,3),'g+','MarkerSize',30,'LineWidth', 5);
    h3(k)=plot(es(k,2),es(k,3),'r+','MarkerSize',30,'LineWidth', 5);
    h4(k)=plot(eb(k,2),eb(k,3),'c+','MarkerSize',30,'LineWidth', 5);
    drawnow
    
end
set(gca,'Color','k');
imhandle(k+1)=imagesc(v.video(:,:,:,end));
title(strcat('\fontsize{30}','Motion Tracking: Frame',sprintf(' %d',k),' of', ...
        sprintf(' %d',length(rb(:,1)))),'Color','w');
h1(k+1)=plot(lb(end,2),lb(end,3),'m+','MarkerSize',30,'LineWidth', 5);
h2(k+1)=plot(rb(end,2),rb(end,3),'g+','MarkerSize',30,'LineWidth', 5);
h3(k+1)=plot(es(end,2),es(end,3),'r+','MarkerSize',30,'LineWidth', 5);
h4(k+1)=plot(eb(end,2),eb(end,3),'c+','MarkerSize',30,'LineWidth', 5);

hold off

