figure(1)
mimo=video1dat;
ytick=[.5,1.5,2.5];
yticklab={'Down','Center','Up'};
time=(1:length(mimo.x))*5;
plot(time,ones(1,length(mimo.x))*2.5,'k:');

hold on
ax = gca;
ax.YTick = ytick;
ax.YTickLabels = yticklab;
plot(time,3.5-mimo.y,'b');
plot(time,3.5-mimo.y,'rx');

ylim([0,3]);
xlabel('Time (sec)');
hold off

figure(2)
lulu=video4dat;
ytick=[.5,1.5,2.5];
yticklab={'Right','Center','Left'};
time=(1:length(lulu.x));
plot(time,ones(1,length(lulu.x))*.5,'k:');

hold on
ax = gca;
ax.YTick = ytick;
ax.YTickLabels = yticklab;
plot(time,3.5-lulu.x,'b');
plot(time,3.5-lulu.x,'rx');

ylim([0,3]);
xlabel('Time (sec)');
hold off


xtick=[.5,1.5,2.5];
xticklab={'Left','Center','Right'};
ytick=[.5,1.5,2.5];
yticklab={'Up','Center','Down'};

fig=figure(3) 
%screensize = get( groot, 'Screensize' );
%set(fig,'Color','w','Name','Eyedirections','Position', screensize);
colormap jet
hold on
subplot(121)
imagesc(video1dat.countmat);
    ax = gca;
    ax.XTick = xtick;
    ax.XTickLabels = xticklab;
    ax.YTick = ytick;
    ax.YTickLabels = yticklab;
    a = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
    title('With Audience and Mic')
grid off
subplot(122)
imagesc(video2dat.countmat);

    ax = gca;
    ax.XTick = xtick;
    ax.XTickLabels = xticklab;
    ax.YTick = ytick;
    ax.YTickLabels = yticklab;
    a = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
    title('No Audience or Mic')
grid off
hold off


fig=figure(4) 
%screensize = get( groot, 'Screensize' );
%set(fig,'Color','w','Name','Eyedirections','Position', screensize);
colormap jet
hold on
subplot(121)
imagesc(video6dat.countmat);

    ax = gca;
    ax.XTick = xtick;
    ax.XTickLabels = xticklab;
    ax.YTick = ytick;
    ax.YTickLabels = yticklab;
    a = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
        title('With Audience and Mic')
grid off
subplot(122)
imagesc(video7dat.countmat);

    ax = gca;
    ax.XTick = xtick;
    ax.XTickLabels = xticklab;
    ax.YTick = ytick;
    ax.YTickLabels = yticklab;
    a = get(gca,'XTickLabel');
    set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
        title('No Audience or Mic')
grid off
hold off