function h = arc(x,y,r,nsegments,coloralpha,linewidthstart,linewidthend)
if nargin<4
    nsegments=50;
    coloralpha=[1,0,1,1];
    linewidthstart=5;
    linewidthend=5;
    
end
linewidth=linewidthstart;
hold on
th = 0:pi/nsegments:pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;


linewidthincrement=(linewidthstart-linewidthend)/numel(xunit);
for i=2:numel(xunit)
    h(i) = plot(xunit(i-1:i), yunit(i-1:i),'Color',coloralpha,'LineWidth',linewidthend+i*linewidthincrement);
end
hold off