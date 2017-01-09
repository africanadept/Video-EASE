function p = nmatPoly2mono(nmat,midfile)
%parses polyphonic nmat (note matrices) of midi into separate note matrices.
%nmat = source
%n = number of voices

%[nrows ncols]=size(nmat);
%onsets=nmat(:,1);

%regulate channels (if channels are broken up on different onsets)
% numchans=numel(unique(nmat(:,3)));
% onsets=nmat(:,1);
% onsetuniq=unique(onsets);
% onsetcount=zeros(numel(onsetuniq),1);
% for j=1:numel(onsetuniq)
%     onsetcount(j,1)=numel(find(onsets==onsetuniq(j)));
% end
% numvoices=round(mean(onsetcount));
% if abs(numchans-numvoices) >
if nargin==2
    p.file=midfile;
end
p.nmat=nmat;
p.duration=nmat(end,1);

%% regulate onsets
onsets=nmat(:,1);
durs=nmat(:,2);
%onsetstest=round(onsets*4);
%remcheck=zeros(numel(onsetstest),1);
onsetuniq=unique(onsets);
onsetincr=[];
for i=2:numel(onsetuniq)
    onsetincr(end+1)=onsetuniq(i)-onsetuniq(i-1);
end
onsetincrmode=mode(onsetincr);
% while onsetincrmode < .8
%     onsetincrmode=onsetincrmode*2
% end

makemodeincrone=1/onsetincrmode;
onsets=onsets*makemodeincrone;
durs=durs*makemodeincrone;

%make sixteenth smallest value
for i=1:numel(onsets)
    if rem((onsets(i)*4),1)~=0
        onsets(i)=round(onsets(i)*4)/4;
    end
end

nmat(:,1)=onsets;
nmat(:,2)=durs;

%identify number of channels and separate
channelcolumn=nmat(:,3);
channels=unique(channelcolumn);
for i=1:numel(channels)
    ind= channelcolumn==channels(i);
    chanmat{i}=nmat(ind,:);
end

%ensure each channel is monophonic
chanismono=nan(numel(chanmat),1);
for i=1:numel(chanmat)
    [nrows, ~]=size(chanmat{i});
    onsets=chanmat{i}(:,1);
    onsets=100*onsets;
    onsets=round(onsets);
    onsets=onsets/100;
    chanmat{i}(:,1)=onsets;
    onsetuniq=unique(onsets);
    if numel(onsetuniq)==nrows
        chanismono(i,1)=1;
    else
        chanismono(i,1)=0;
    end
end
chanismono=chanismono;
%p.thischan=[];
%if channel is not monophonic, separate it
if sum(chanismono) < numel(chanmat)
    polychans=find(chanismono==0);
    for i=numel(polychans):-1:1
        thischan=chanmat{polychans(i)};
        onsets=thischan(:,1);
        %make sixteenth smallest value
        for j=1:numel(onsets)
            if rem((onsets(i)*4),1)~=0
                onsets(i)=round(onsets(i)*4)/4;
            end
        end
        thischan(:,1)=onsets;
        onsetuniq=unique(onsets);
        onsetcount=zeros(numel(onsetuniq),1);
        for j=1:numel(onsetuniq)
            onsetcount(j,1)=numel(find(onsets==onsetuniq(j)));
        end
        numvoicesinchan=mode(onsetcount);
        
        %p.thischan{1}=thischan;
  
        inequal=1;
        lastequal=[];
        while inequal > 0
        inequal=0;
        % make sure all simultaneous onset durations are equal
        for d=2:length(onsetuniq)
            ind=find(thischan(:,1)==onsetuniq(d-1));
            onsetdurs=thischan(ind,2);
            uonsetdurs=unique(onsetdurs);
            if numel(uonsetdurs) > 1
                onsetuniq(d-1)
                inequal=inequal+1;
                newonsetdur=min(onsetdurs);
                for j=1:numel(onsetdurs)
                    if onsetdurs(j)~=newonsetdur
                        onsrem=onsetdurs(j)-newonsetdur;
                        newrow=thischan(ind(j),:);
                        newrow(1)=newrow(1)+newonsetdur;
                        newrow(2)=onsrem;
                        thischan(end+1,:)=newrow;
                        thischan(ind(j),2)=newonsetdur;
                    end
                end
            end
        end

        [~, SortIndex] = sort(thischan(:,1));
        thischan=thischan(SortIndex,:);
        
        for j=size(thischan,1):-1:1
            if thischan(j,2) < .25
                thischan(j,:)=[]; %eliminate micro values
            end
        end
        
        onsets=thischan(:,1);
        %make sixteenth smallest value
        for j=1:numel(onsets)
            if rem((onsets(i)*4),1)~=0
                onsets(j)=round(onsets(j)*4,0)/4;
            else
                onsets(j)=fix(onsets(j));
            end
        end
        thischan(:,1)=onsets;
        onsetuniq=unique(onsets);
        onsetcount=zeros(numel(onsetuniq),1);
        for j=1:numel(onsetuniq)
            onsetcount(j,1)=numel(find(onsets==onsetuniq(j)));
        end
        numvoicesinchan=mode(onsetcount);
        if numel(lastequal) > 3
        if lastequal(end-1)==lastequal(end)
            if lastequal(end-2)==lastequal(end-1)
            break
            end
        end
        end
        lastequal(end+1)=inequal; %avoid unending loop
        end
        
        %p.thischan{2}=thischan;
        
        
        
        %chop durations
        
        onsets=thischan(:,1);
        for j=1:length(onsets)
            onset=onsets(j);
            onsrem=rem(onset,1);%alternatively use mod
            if onsrem~=0
                dur=thischan(j,2);
                onsfill=1-onsrem;
                if dur > onsfill
                    newonset=onset+1-onsfill; %fill up onset to next beat
                    newdur=dur-onsfill;
                    newrow=thischan(j,:);
                    newrow(1,1)=newonset;
                    newrow(1,2)=newdur;
                    thischan(end+1,:)=newrow;
                end
            end
        end
        
        
        [~, SortIndex] = sort(thischan(:,1));
        thischan=thischan(SortIndex,:);
        
        for j=size(thischan,1):-1:1
            if thischan(j,2) < .25
                thischan(j,:)=[]; %eliminate micro values
            end
        end
        
        onsets=thischan(:,1);
        %make sixteenth smallest value
        for j=1:numel(onsets)
            if rem((onsets(i)*4),1)~=0
                onsets(j)=round(onsets(j)*4,0)/4;
            else
                onsets(j)=fix(onsets(j));
            end
        end
        thischan(:,1)=onsets;
        onsetuniq=unique(onsets);
        onsetcount=zeros(numel(onsetuniq),1);
        for j=1:numel(onsetuniq)
            onsetcount(j,1)=numel(find(onsets==onsetuniq(j)));
        end
        numvoicesinchan=mode(onsetcount);
        
        
        %p.thischan{3}=thischan;
        
        %if there are not four voices for a specific onset, chop again
        
        for d=length(onsetuniq):-1:2
            if onsetcount(d) < numvoicesinchan %|| onsetcount(d) > numvoicesinchan; % this needs be more delicate
                ind=find(thischan(:,1) == onsetuniq(d-1));
                for z=1:numel(ind)
                    if thischan(ind(z),1)+thischan(ind(z),2) > onsetuniq(d)
                        dur=thischan(ind(z),2);
                        newrow=thischan(ind(z),:);
                        newrow(1,1)=onsetuniq(d);
                        onsetdiff=onsetuniq(d)-onsetuniq(d-1);
                        newrow(1,2)=dur-onsetdiff;
                        thischan(ind(z),2)=onsetdiff;
                    end
                end
            end
        end
        
        [~, SortIndex] = sort(thischan(:,1));
        thischan=thischan(SortIndex,:);
        
        for j=size(thischan,1):-1:1
            if thischan(j,2) < .25
                thischan(j,:)=[]; %eliminate micro values
            end
        end
        
        onsets=thischan(:,1);
        %make sixteenth smallest value
        for j=1:numel(onsets)
            if rem((onsets(i)*4),1)~=0
                onsets(j)=round(onsets(j)*4,0)/4;
            else
                onsets(j)=fix(onsets(j));
            end
        end
        thischan(:,1)=onsets;
        onsetuniq=unique(onsets);
        onsetcount=zeros(numel(onsetuniq),1);
        for j=1:numel(onsetuniq)
            onsetcount(j,1)=numel(find(onsets==onsetuniq(j)));
        end
        numvoicesinchan=mode(onsetcount);
        
        
        %p.thischan{4}=thischan;
        
        %delete extra
        
        for d=2:length(onsetuniq)
            if onsetcount(d) > numvoicesinchan %|| onsetcount(d) > numvoicesinchan; % this needs be more delicate
                %if onsetcount(d) == 1
                if onsetcount(d-1) == numvoicesinchan
                    ind=find(thischan(:,1) == onsetuniq(d-1));
                    ind2=find(thischan(:,1) == onsetuniq(d));
                    pitches=thischan(ind2,4);
                    previous=thischan(ind,:);
                    prevpitches=previous(:,4);
                    clearvars diffsum
                    for k=1:numel(pitches)
                        clearvars pitchdiff
                        for l=1:numel(prevpitches)
                            pitchdiff(l)=abs(pitches(k)-prevpitches(l));
                        end
                        diffsum(k)=sum(pitchdiff,2);
                    end
                    [val, loc]=max(diffsum);
                    thischan(ind2(loc),:)=[];
                    %                     for k=1:numel(prevpitches);
                    %                         newrow=thischan(ind2,:);
                    %                         newrow(1,4)=prevpitches(k);
                    %                         thischan(end+1,:)=newrow;
                    %                     end
                    
                end
                %end
            end
        end
        
        if onsetcount(1) > numvoicesinchan
            
            for j=2:numel(onsetcount)
                if onsetcount(j)==numvoicesinchan
                    break
                end
            end
            indc=find(thischan(:,1) == onsetuniq(j));
            ind=find(thischan(:,1) == onsetuniq(1));
            pitches=thischan(ind,4);
            postpitches=thischan(indc,4);
            clearvars diffsum
            for k=1:numel(pitches);
                clearvars pitchdiff
                for l=1:numel(postpitches)
                    pitchdiff(l)=abs(pitches(k)-postpitches(l));
                end
                diffsum(k)=sum(pitchdiff,2);
            end
            [val, loc]=max(diffsum);
            thischan(ind(loc),:)=[];
            
        end
        
        [~, SortIndex] = sort(thischan(:,1));
        thischan=thischan(SortIndex,:);
        
        for j=size(thischan,1):-1:1
            if thischan(j,2) < .25
                thischan(j,:)=[]; %eliminate micro values
            end
        end
        
        onsets=thischan(:,1);
        %make sixteenth smallest value
        for j=1:numel(onsets)
            if rem((onsets(i)*4),1)~=0
                onsets(j)=round(onsets(j)*4,0)/4;
            else
                onsets(j)=fix(onsets(j));
            end
        end
        thischan(:,1)=onsets;
        onsetuniq=unique(onsets);
        onsetcount=zeros(numel(onsetuniq),1);
        for j=1:numel(onsetuniq)
            onsetcount(j,1)=numel(find(onsets==onsetuniq(j)));
        end
        numvoicesinchan=mode(onsetcount);
        
        
        
        %p.thischan{5}=thischan;
        
        %fill empty
        
        for d=2:length(onsetuniq)
            if onsetcount(d) < numvoicesinchan %|| onsetcount(d) > numvoicesinchan; % this needs be more delicate
                hmm79=onsetuniq(d);
                if onsetcount(d) == 1
                    %hmm81=onsetuniq(d)
                    %hmm82=numvoicesinchan
                    ind=find(thischan(:,1)==onsetuniq(d-1));
                    if numel(ind) == numvoicesinchan
                        %hmm83=onsetuniq(d)
                        %ind= thischan(:,1) == onsetuniq(d-1);
                        ind2=find(thischan(:,1) == onsetuniq(d));
                        pitch=thischan(ind2,4);
                        previous=thischan(ind,:);
                        clearvars pitchdiff
                        prevpitches=previous(:,4);
                        for k=1:numel(prevpitches)
                            pitchdiff(k)=abs(pitch-prevpitches(k));
                        end
                        [val, loc]=min(pitchdiff);
                        prevpitches(loc)=[];
                        for k=1:numel(prevpitches)
                            newrow=thischan(ind2,:);
                            newrow(1,4)=prevpitches(k);
                            thischan(end+1,:)=newrow;
                        end
                        
                    end
                end
            end
        end
        
        [~, SortIndex] = sort(thischan(:,1));
        thischan=thischan(SortIndex,:);
        
        for j=size(thischan,1):-1:1
            if thischan(j,2) < .25
                thischan(j,:)=[]; %eliminate micro values
            end
        end
        
        onsets=thischan(:,1);
        %make sixteenth smallest value
        for j=1:numel(onsets)
            if rem((onsets(i)*4),1)~=0
                onsets(j)=round(onsets(j)*4,0)/4;
            else
                onsets(j)=fix(onsets(j));
            end
        end
        thischan(:,1)=onsets;
        onsetuniq=unique(onsets);
        onsetcount=zeros(numel(onsetuniq),1);
        for j=1:numel(onsetuniq)
            onsetcount(j,1)=numel(find(onsets==onsetuniq(j)));
        end
        numvoicesinchan=mode(onsetcount);
        
        
        %p.thischan{6}=thischan;
        
        %delete too many or too few
        
        for d=length(onsetuniq):-1:2
            if onsetcount(d) < numvoicesinchan || onsetcount(d) > numvoicesinchan % this needs be more delicate
                
                clearvars ind
                ind=find(onsets==onsetuniq(d));
                for z=length(ind):-1:1
                    thischan(ind(z),:)=[];
                end
            end
        end
        
        [nrows , ~]=size(thischan);
        
        for k=1:(nrows/numvoicesinchan)
            l=k*numvoicesinchan;
            temp=thischan(l+1-numvoicesinchan:l,:);
            [~, sortind] = sort(temp(:,4),'descend');
            tempsorted=temp(sortind,:);
            thischan(l+1-numvoicesinchan:l,:)=tempsorted;
        end
        onsets=thischan(:,1);
        %make sixteenth smallest value
        for j=1:numel(onsets)
            if rem((onsets(i)*4),1)~=0
                onsets(j)=round(onsets(j)*4,0)/4;
            else
                onsets(j)=fix(onsets(j));
            end
        end
        thischan(:,1)=onsets;
        onsetuniq=unique(onsets);
        numonsets=numel(onsetuniq);
        for j=1:numvoicesinchan
            newchan{j}=nan(numonsets,7);
        end
        for j=1:numonsets
            ind=find(onsets==onsetuniq(j));
            for k=1:numvoicesinchan
                if k<=numel(ind)
                    newchan{k}(j,:)=thischan(ind(k),:);
                    lastvalue=thischan(ind(k),:);
                else
                    newchan{k}(j,:)=lastvalue;
                end
            end
        end
        chanbefore=chanmat(1:polychans(i)-1);
        chanafter=chanmat(polychans(i)+1:end);
        chanmat=horzcat(chanbefore,newchan,chanafter);
        
        %p.thischan{7}=thischan;
        
    end
    
end

chanmat=chanmat;
p.v=chanmat;
v=p.v;

%eliminate overlapping time values from all voices
n=numel(v);
for i=1:n
    for j=2:size(v{i},1)
        if v{i}(j-1,1)+v{i}(j-1,2) > v{i}(j,1)
            v{i}(j-1,2)=v{i}(j,1)-v{i}(j-1,1);
        end
    end
end
p.v=v;

%determine whether aggregate of channels is polyphonic or homophonic
%1. aggregate time for each voice
for i=1:numel(p.v)
    clearvars durations
    durations=p.v{i}(:,2);
    durations=round(100*durations)/100;
    p.v{i}(:,2)=durations;
    totaldur(i)=sum(durations);
end

%2. calculate range of voice time durations
durrange=range(totaldur);
p.durrange=durrange;
if numel(p.v)==1
    texture='Mono';
elseif durrange < 1
    texture='Homo';
elseif p.v{1}(end,1)+p.v{1}(end,2) > 1.2*(mean(totaldur,2))
    if durrange < 2
        texture='Eqpo';
    else
        texture='Unpo';
    end
else
    texture='Mixd';
end
p.texture=texture;

n=numel(p.v);
v=p.v;

%calculate sum of MIDI values for each voice
vsumpitch=zeros(n,1);
for i=1:n
    vsumpitch(i)=sum(v{i}(:,4));
end

%eliminate duplicate voices
for i=n:-1:1
    n2=numel(v);
    for j=n2:-1:1
        if i~=j
            if totaldur(i)==totaldur(j) %compare durations
                if vsumpitch(i)==vsumpitch(j) %compare MIDI value sums
                    v(i)=[]; %delete voice
                    totaldur(i)=[]; %delete duration value
                    break
                end
            end
        end
    end
end

%eliminate overlapping time values from all voices
n=numel(v);
for i=1:n
    for j=2:size(v{i},1)
        if v{i}(j-1,1)+v{i}(j-1,2) > v{i}(j,1)
            v{i}(j-1,2)=v{i}(j,1)-v{i}(j-1,1);
        end
    end
end

%sort voices by highest average pitch per event
n=numel(v);
vavgpch=zeros(n,1);
for i=1:n
    vavgpch(i)=sum(v{i}(:,4))/numel(v{i}(:,4));
end

[~, SortIndex] = sort(vavgpch);
hmm=SortIndex;

nmat=[];
p.v=[];
for j=1:n
    p.v{j}=v{SortIndex(n+1-j)};
    p.v{j}(:,3)=(j)*(ones(size(p.v{j},1),1));
    nmat=vertcat(nmat,p.v{j}); %reconstitute nmat
end

%order nmat by time column
[~, SortIndex] = sort(nmat(:,1));
p.regnmat=nmat(SortIndex,:);

%if texture ~='Unpo'
%make homophonic version for harmonic analysis
p = SM_makeHarmMat2(p);

end

