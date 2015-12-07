% This is a demo file showing you how to load, display and animate a
% trapezeblocks world using the blocksdraw command. Play with this file to
% get a basic feel for the visualization code. To experiment with less 
% trivial things, try working with basicdyn and basicplan.

tbw=loadworld('occ1')
[gh]=blocksdraw(tbw,[],gca,'INIT')
for k=1:5
    tbw.xc(3)=tbw.xc(3)+1;
    [gh]=blocksdraw(tbw,gh,gca,'UPDATE');
   pause(0.1)
end

for k=1:5
    tbw.xc(77)=tbw.xc(77)+pi/20;
    tbw.xd(1)=1-tbw.xd(1);
    [gh]=blocksdraw(tbw,gh,gca,'UPDATE');
    pause(0.1)
end