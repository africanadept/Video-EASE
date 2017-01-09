function r=searchAndRank(nmat,in)


if nargin==2
degrees=in.degrees;
cmin=in.cmin;
cmax=in.cmax;
delgap=in.delgap;
simmin=in.simmin;
covORpnts=in.covORpnts;
overlap=in.overlap;
elimRCE=in.elimRCE;
minRec=in.minRec;
simcard=in.simcard;
usetime=in.usetime;
else
    degrees=2;
    cmin=5;
    cmax=50;
    delgap=0;
    simmin=.9;
    covORpnts=0; %0 is coverage
    overlap=0;
    elimRCE=0;
    minRec=2;
    simcard=1; %secondary subjects should be within 20%
    usetime=0; %consider time when calculating coverage
end
    


rawnmat=nmat;
%this is only for monophonic pieces
%does not work with human playback settings
%(turn off in Finale or Sibelius)

pitches=nmat(:,4);
pitches=pitches';
contcom=CT_makeContCom(pitches,degrees);
CL=nansum(contcom);

durs=nmat(:,6);
durs=durs(2:end)-durs(1:end-1);
durs(end+1)=nmat(end,7);
contcom=CT_makeContCom(durs,1);
DCL=nansum(contcom);

CL=[CL;DCL];

for n=cmin:cmax
    clearvars segments segmentu segmentucount segmentuind temp
    for i=1:numel(pitches)-n+1
        segments{i}=CL(:,i:i+n-1);
%         for j=1:degrees
%             try
%                 segments{i}(1:degrees+1-j,j)=-1;
%                 segments{i}(degrees+j:end,end+1-j)=-1;
%             catch
%             end
%         end
    end

    
    [segmentu, idx ,idx2] = uniquecell(segments);
    %check to see if card saturation reached
    if numel(segmentu)==numel(segments)
        break
    end
    
   
    segmentucount=zeros(numel(segmentu),1);
    for i=1:length(segmentu)
        ind=find(idx2==i);
        segmentuind{i}=ind;
        segmentucount(i)=numel(ind);
%         numel(pitches)
%         segmentuind{i}(1)-2
%         segmentuind{i}(1)+n-1+2
        try
        segmentpitch{i}=pitches(segmentuind{i}(1)-2:segmentuind{i}(1)+n-1+2);
        catch
            try
            segmentpitch{i}=pitches(segmentuind{i}(2)-2:segmentuind{i}(2)+n-1+2);
            catch
             segmentpitch{i}=[];
            end
        end
        %segmentdurs{i}=durs(segmentuind{i}(1):segmentuind{i}(1)+n-1);
    end
    %inversions
    [segmentucount, SortInd]=sort(segmentucount,'descend');
    segmentu=segmentu(SortInd);
    numel(segmentu)
    numel(segmentuind)
    segmentuind=segmentuind(SortInd);
    segmentpitch=segmentpitch(SortInd);
    %segmentdurs=segmentdurs(SortInd);
    idx=idx(SortInd);
    
    for i=1:5
        try
        inv=-segmentpitch{i}+max(segmentpitch{i});
        catch
            break
        end
        invercom=CT_makeContCom(inv,degrees);
        invCL=nansum(invercom);
        if isempty(invCL)==1
            break
        end
        try
        invCL=[invCL(3:end-2);segmentu{i}(2,:)];
        catch
            break
        end
        segmentuinvind{i}=[];
        for j=i+1:numel(segmentucount)
            if segmentucount(j)==0
                continue
            end
            size(invCL)
            size(segmentu{j})
            if segmentu{j}==invCL
                hmm=0;
                segmentucount(i)=segmentucount(i)+segmentucount(j);
                segmentuinvind{i}=[segmentuinvind{i},segmentuind{j}];
                segmentucount(j)=0;
                segmentu{j}=[];
                segmentuind{j}=[];
                segmentupitch{j}=[];
            end
        end
    end
          
            
%     temp=find(segmentucount==1)
%     temp2=find(segmentucount==0);
%     temp=[temp',temp2'];
    segmentu(6:end)=[];
    segmentuind(6:end)=[];
    segmentucount(6:end)=[];
for i=1:numel(segmentu)
    segmentucov(i)=segmentucount(i)*n;
end
    
%     [segmentucount, SortInd]=sort(segmentucount,'descend');
%     segmentu=segmentu(SortInd);
%     segmentuind=segmentuind(SortInd);
%     idx=idx(SortInd);
    p(n).segments=segments;
    p(n).seg=segmentu;
    p(n).segcount=segmentucount;
    p(n).segind=segmentuind;  
    p(n).segcov=segmentucov;
    p(n).seginvind=segmentuinvind;
end

    allcov=0;
    r(1).seg=p(cmin).seg{1};
    r(1).segcount=p(cmin).segcount(1);
    r(1).segind=p(cmin).segind{1};
    r(1).cov=p(cmin).segcov(1);
    try
    r(1).invind=p(n).seginvind{1};
    catch
    r(1).invind=[];
    end
for i=1:numel(p)
    for j=1:numel(p(i).seg)
    allcov(end+1)=p(i).segcov(j);
    r(end+1).card=i;
    r(end).seg=p(i).seg{j};
    r(end).segcount=p(i).segcount(j);
    r(end).segind=p(i).segind{j};
    r(end).cov=p(i).segcov(j);
    try
    r(end).invind=p(i).seginvind{j};
    catch
    r(end).invind=[];
    end     
    end
end
r(1)=[];
allcov(1)=[];
    [allcov, SortInd]=sort(allcov,'descend');
    r=r(SortInd);

for i=1:numel(r)
        clearvars temp
        temp=[];
        for j=1:numel(r(i).segind)
        temp=[temp,r(i).segind(j):r(i).segind(j)+r(i).card-1];
        end
                for j=1:numel(r(i).invind)
        temp=[temp,r(i).invind(j):r(i).invind(j)+r(i).card-1];
                end
        r(i).inds=temp;
    end
rold=r;
    
    for i=numel(r):-1:1
        for j=1:i-1
            i
            a=r(i).inds;
            b=r(j).inds;
            c=intersect(a,b)
            if numel(a)==numel(c)
                r(i)=[]
                break
            end
        end
    end
    
    
   for i=numel(r):-1:1
        for j=1:i-1
            i;
            a=r(i).inds;
            b=r(j).inds;
            c=intersect(a,b);
            if .8*numel(a)<numel(c)
                r(j).inds=unique([r(j).inds,r(i).inds]);
%                 try
%                 r(j).sub(end+1)=r(i);
%                 catch
%                  r(j).sub(1)=r(i);   
%                 end
                r(i)=[];
                break
            end
        end
   end

   allcov=[];
for i=1:numel(r)
    allcov(end+1)=numel(r(i).inds);
end
    [allcov, SortInd]=sort(allcov,'descend');
    r=r(SortInd);
    
    
end

