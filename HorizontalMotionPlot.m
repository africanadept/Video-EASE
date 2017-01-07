


%% IBO_140703_A_02_03
%% Vertical Motion

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

%animated plot
fig=figure()
filename = 'IBO_140703_S_02_03_AnimatedPlot.gif';
screensize = get( groot, 'Screensize' );
set(fig,'Color','k','Name','Video-EASE','Position', screensize*.9);
%whitebg(1,'k');
plot(lb(1,2),lb(1,1),'m-.');
set(gca,'Color','k','FontSize',16,'FontWeight','bold');
title(strcat('\fontsize{30}','Horizontal Motion at',sprintf(' %f',rb(1,1)),' seconds'),'Color','w');
hold on
xlabel('Horizontal Pixels','FontSize',16,'Color','w');
ylabel('Time (sec)','FontSize',16,'Color','w');
plot(rb(1,2),rb(1,1),'g-.');
plot(es(1,2),es(1,1),'r-.');
plot(eb(1,2),eb(1,1),'c-.');
hlegend=legend('Left Beater','Right Beater','Ekwe Stick','Ekwe Body');
set(hlegend,'FontSize',16,'Color','w');
ylim([-1.5 1.5]);
xlim([200 1400]);
axis ij

h1=animatedline(lb(1,2),lb(1,1),'Color','m','LineStyle','-.');
h2=animatedline(rb(1,2),rb(1,1),'Color','g','LineStyle','-.');
h3=animatedline(es(1,2),es(1,1),'Color','r','LineStyle','-.');
h4=animatedline(eb(1,2),eb(1,1),'Color','c','LineStyle','-.');
ref=1;
ref2=1;
for k = 2:length(rb(:,1))
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
    
    
    addpoints(h1,lb(k,2),lb(k,1));
    addpoints(h2,rb(k,2),rb(k,1));
    addpoints(h3,es(k,2),es(k,1));
    addpoints(h4,eb(k,2),eb(k,1));
    title(strcat('\fontsize{30}','Horizontal Motion at',sprintf(' %4.2f',rb(k,1)),' seconds'),'Color','w');

   % if lb(k,1) > 1.5 && lb(k,1) < 13.5
        ylim([lb(k,1)-1.5 lb(k,1)+1.5]);
   % end
    drawnow
%           frame = getframe(2);
%       im = frame2im(frame);
%       [imind,cm] = rgb2ind(im,256);
%       if k == 2
%           imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
%       else
%           imwrite(imind,cm,filename,'gif','WriteMode','append');
%       end
end
hold off




