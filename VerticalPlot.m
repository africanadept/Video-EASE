%% IBO_140703_A_02_03
%% Static Plot

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

fig=figure()
screensize = get( groot, 'Screensize' );
set(fig,'Color','k','Name','Video-EASE','Position', screensize*.9);
plot(lb(:,1),lb(:,3),'m-.');
set(gca,'Color','k','FontSize',16,'FontWeight','bold','YColor','w','XColor','w');
title(strcat('\fontsize{30}','IBO: Udu and Ekwe Polyrhythm'),'Color','w');
hold on
xlabel('Time (sec)','FontSize',16,'Color','w');
ylabel('Vertical Pixels','FontSize',16,'Color','w');
plot(rb(:,1),rb(:,3),'g-.');
plot(es(:,1),es(:,3),'r-.');
plot(eb(:,1),eb(:,3),'c-.');
for i=1:numel(udons)
plot([udons(i) udons(i)],[275, 600],'w');
end
for i=1:numel(ekons)
plot([ekons(i) ekons(i)], [0, 275], 'w');
end
hlegend=legend('Left Beater','Right Beater','Ekwe Stick','Ekwe Body');
set(hlegend,'FontSize',16,'Color','w');
ylim([0 550]);
xlim([5 10]);
axis ij
hold off
