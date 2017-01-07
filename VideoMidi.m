figure()
hudu(1)=line([udu(1,1) (udu(1,1)+udu(1,2))], [udu(1,4) udu(1,4)],'Color','g','LineWidth', 10);
hold on
for i=1:numel(udons)
hudu(i)=plot([udu(i,1) (udu(i,1)+udu(i,2))], [udu(i,4) udu(i,4)],'LineWidth',10);
if udu(i,4) > 38
    hudu(i).Color=[0,1,0,(udu(i,5)-min(udu(:,5)))/(max(udu(:,5))-min(udu(:,5)))];%green
else
    hudu(i).Color=[1,0,1,(udu(i,5)-min(udu(:,5)))/(max(udu(:,5))-min(udu(:,5)))]; %magenta
end
end
hekw(1)=line([ekwe(1,1) (ekwe(1,1)+ekwe(1,2))], [ekwe(1,4) ekwe(1,4)],'Color','g','LineWidth', 10);
for i=1:numel(udons)
hekw(i)=plot([ekwe(i,1) (ekwe(i,1)+ekwe(i,2))], [ekwe(i,4) ekwe(i,4)],'LineWidth',10);
    hekw(i).Color=[1,0,0,(ekwe(i,5)-min(ekwe(:,5)))/(max(ekwe(:,5))-min(ekwe(:,5)))];%red
end
ylim([32 72])
xlim([-1.5 1.5]);
drawnow

for k = 2:length(rb(:,1))
            xlim([lb(k,1)-1.5 lb(k,1)+1.5]);
            drawnow
end
hold off
