function csvdata=midi2csv(filename)
filename='YOR_130726_A_AdeyemoOrikiOgunVideo.mid';
if strcmp(filename(end-3:end),'.mid')==1
    filename=filename(1:end-4)
end
nmat=midi2nmat([filename '.mid']);
startsec=nmat(:,6);
dursec=nmat(:,7);
for i=1:numel(startsec)
    endsec(i,1)=startsec(i)+dursec(i);
end
annotation=nmat(:,4);
csvdata=[startsec,endsec,dursec,annotation];
csvwrite([filename '.csv'],csvdata)
