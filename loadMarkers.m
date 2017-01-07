function markers=loadMarkers(fn)

%Takes an Adobe Premiere formatted marker.csv and takes out seconds and frames
%Needs markers2cellstrings
%Format for each marker: insec, frame, outsec, frame

a=fileread(fn);
cells=markers2cellstrings(fn)
cells(1:7)=[];
num=numel(cells);
for i=1:num
    ind=regexp(cells{i},'\W');
    for j=numel(ind):-1:1
        cells{i}(ind(j))=[];
    end
end
numMarkers=floor(num/7);
markers=nan(numMarkers,4)
for i=1:numMarkers
     in=cells{3+(i-1)*7};
     markers(i,1)=str2num(in(3:4))*60+str2num(in(5:6));
     markers(i,2)=str2num(in(7:8));
     out=cells{4+(i-1)*7};
     markers(i,3)=str2num(in(3:4))*60+str2num(in(5:6));
     markers(i,4)=str2num(in(7:8))     
end

end