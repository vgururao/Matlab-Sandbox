
close all
load worlds/test
[gh]=blocksdraw(tbw,[],gca,'INIT')
for k=1:5
    tbw.xc(3)=tbw.xc(3)+1;
    [gh]=blocksdraw(tbw,gh,gca,'UPDATE');
   pause
end

for k=1:5
    tbw.xc(77)=tbw.xc(77)+pi/20;
    tbw.xd(1)=1-tbw.xd(1);
    [gh]=blocksdraw(tbw,gh,gca,'UPDATE');
    pause
end