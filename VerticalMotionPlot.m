


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
fig=figure(1)
filename = 'IBO_140703_S_02_03_AnimatedPlot.gif';
screensize = get( groot, 'Screensize' );
set(fig,'Color','k','Name','Video-EASE','Position', screensize*.9);
%whitebg(1,'k');
plot(lb(1,1),lb(1,3),'m-.');
set(gca,'Color','k','FontSize',16,'FontWeight','bold');
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

h1=animatedline(lb(1,1),lb(1,3),'Color','m','LineStyle','-.');
h2=animatedline(rb(1,1),rb(1,3),'Color','g','LineStyle','-.');
h3=animatedline(es(1,1),es(1,3),'Color','r','LineStyle','-.');
h4=animatedline(eb(1,1),eb(1,3),'Color','c','LineStyle','-.');
ref=1;
ref2=1;
for k = 2:length(rb(:,1))
    if udons(ref2)<= lb(k,1)
        plot([udons(ref2) udons(ref2)],[275, 600],'w');
        
        if ref2 <numel(udons)
            ref2=ref2+1;
        end
    end
    if ekons(ref)<= lb(k,1) && ekons(ref) >= lb(k-1,1)
        
        plot([ekons(ref) ekons(ref)], [0, 275], 'w');
        if ref <numel(ekons)
            ref=ref+1;
            
        end
    end
    
    
    addpoints(h1,lb(k,1),lb(k,3));
    addpoints(h2,rb(k,1),rb(k,3));
    addpoints(h3,es(k,1),es(k,3));
    addpoints(h4,eb(k,1),eb(k,3));
    title(strcat('\fontsize{30}','Vertical Motion at',sprintf(' %4.2f',rb(k,1)),' seconds'),'Color','w');

   % if lb(k,1) > 1.5 && lb(k,1) < 13.5
        xlim([lb(k,1)-1.5 lb(k,1)+1.5]);
   % end
    drawnow
%           frame = getframe(fig);
%       im = frame2im(frame);
%       [imind,cm] = rgb2ind(im,256);
%       if k == 2
%           imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
%       else
%           imwrite(imind,cm,filename,'gif','WriteMode','append');
%       end
end
hold off




