% (r, theta) meme map for a bunch of links

nvec = ceil(10*rand(100,1));

rvec=1./nvec;

thvec=360*rand(100,1);

rfVec=round(rand(100,1));
figure(1)
hold on
for k=1:100
    if rfVec(k)==0
        s='o';
    else
        s='s';
    end
    
    polar(thvec(k),rvec(k),s);
end