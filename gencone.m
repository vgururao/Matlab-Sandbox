figure(1)
axis equal
box on
axis([0 200 -50 50]);
axis manual
hold on

plot(0,0,'r*');
theta=pi/12;
xvec=linspace(0,200);
plot(xvec,xvec*tan(theta),'b--');
plot(xvec,xvec*tan(-theta),'b--');

xstep=10;
ystep=5;

bfactor=2;
for treeLevels=1:5
    nfringe=bfactor^(treeLevels-1);
    for leafNodes=1:nfringe
        curNodeX=treeLevels-1)*xstep;
        curNodeY=ystep*(leafNodes-nfringe/2);
        parNodeX=treeLevels-2)*xstep;
        
        lastFringe
        parNodeY=ystep*((nfringe/bfactor)*(leafNodes/nfringe)-nfringe/2);
        plot((treeLevels-1)*xstep,ystep*(leafNodes-nfringe/2),'bo');
        
    end
end