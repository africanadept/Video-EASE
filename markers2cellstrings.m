function cellstrings=markers2cellstrings(fn)
%vectorized to save time


str=fileread(fn);

ind=regexp(str,'\t|\n');

z=numel(ind);
cellstrings=cell(z+1,1);

if z > 0;
    cellstrings{1,1}=str(1:ind(1)-1);
    for i=2:z;
        cellstrings{i,1}=str(ind(i-1)+1:ind(i)-1);
    end
    cellstrings{z+1,1}=str(ind(end)+1:end);
    cellstrings(strcmp('',cellstrings)) = [];
else 
    cellstrings{1,1}=str;
end

cellstrings(strcmp('',cellstrings)) = [];
cellstrings=cellstrings;
end
