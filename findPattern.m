function out=findPattern(filename)

nmat=midi2nmat(filename);

nmatold=nmat;
chans=unique(nmat(:,3));
numchans=numel(chans);
allchans=[];
for z=1:numchans
    ind= nmat(:,3)==chans(z);
    chanmat{z}=nmat(ind,:);
    if z > 1
        chanmat{z}(:,1)=chanmat{z}(:,1)+round(allchans(end,1));
        chanmat{z}(:,6)=chanmat{z}(:,6)+round(allchans(end,6));
    end
    allchans=vertcat(allchans,chanmat{z});
end
 nmat=allchans;


r=searchAndRank(nmat);
out.r=r;
out.nmatFound=nmat;
out.nmat=nmatold;
end


