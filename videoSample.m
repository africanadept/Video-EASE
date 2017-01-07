function clipout=videoSample(clipin,p) %p=period between sample
if nargin==1
    p=1;
end
[height width z framecount]=size(clipin);
frames=framecount/(29.97*p);

for i=1:frames
    j=round(i*29.97*p);
    clipout(:,:,:,i)=clipin(:,:,:,j);
end
end