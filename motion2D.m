function motion=motion2D(v,object,frameinterval)

framecount=v.obj.NumberOfFrames;

fig=figure(1);
screensize = get( groot, 'Screensize' );
set(fig,'Color','w','Name',v.filename,'Position', screensize*.9);
for i=1:framecount/frameinterval
    imagesc(v.video(:,:,:,i*frameinterval));
    title(strcat('\fontsize{32}','"',object,'" tracking: frame',sprintf(' %d',i*frameinterval),' of', ...
    sprintf(' %d',framecount), ...
    ' frames at interval of',sprintf(' %d',frameinterval)));
    try
        [x(i),y(i)] = ginput(1);
    catch
        x(i)=nan;
        y(i)=nan;

    end
    time(i)=(i*frameinterval)/v.fps;
end
close(figure(1))

motion=[time',x',y'];
save(strcat(v.filename,'_',object,'_fr',num2str(frameinterval),...
    '.mat'),'motion');

end

