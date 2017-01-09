function nmat=removeRepeatedPitches(nmat)

for i=numel(nmat(:,1)):-1:2
if nmat(i,4)==nmat(i-1,4)
 if nmat(i-1,1)+nmat(i-1,2)+.1 >nmat(i,1)
     nmat(i-1,2)=nmat(i-1,2)+nmat(i,2);
     nmat(i,:)=[];
 end
end
end
end