function blocksdraw(ws)
colorvec=char('r','g','b');
numBlocks=10;
numGrips=3;
ws.xoff=ws.xoff+0.5;
ws.yoff=ws.yoff+0.5;
w=numBlocks+numGrips+2;
h=numBlocks+2;
ws.grippers(:,1:2)=ws.grippers(:,1:2)+0.5;
axes(gca)
cla
hold on
axis equal
viewFrame=plot([0 0 w w 0],[0 h h 0 0],'k');
set(viewFrame,'LineWidth',2);
blockSpace=plot([0 0 w-numGrips w-numGrips 0],[0 h-2 h-2 0 0],'k');
set(blockSpace,'LineWidth',2);
blockX=[-0.5 -0.5 0.5 0.5 -0.5];
blockY=[-0.5 0.5 0.5 -0.5 -0.5];

% Draw the blocks
for k=1:numBlocks
    patch(blockX+ws.xoff(k), blockY+ws.yoff(k),colorvec(ws.blockcols(k)));
    gnamehandle=text(ws.xoff(k)-0.1,ws.yoff(k),num2str(k));
    set(gnamehandle,'FontSize',12)
    set(gnamehandle,'FontWeight','b')
end
  
% Gripper polygons for end-effector and bar
gripOpenX=[-0.5 -0.4 0.4 0.5 -0.5];
gripOpenY=[-0.3 0.5 0.5 -0.3 -0.3];
gripClosedX=[-0.4 -0.5 0.5 0.4 -0.4];
gripClosedY=[-0.3 0.5 0.5 -0.3 -0.3];
gripBarX=[-0.1 -0.1 0.1 0.1 -0.1];
% No gripBarY, since it extends from ceiling
gripnames=char('A','B','C');

for j=1:numGrips
    if ~ws.grippers(j,3)
        patch(gripOpenX+ws.grippers(j,1),gripOpenY+ws.grippers(j,2),[0.8 0.8 0.8]);
    else
        patch(gripClosedX+ws.grippers(j,1),gripClosedY+ws.grippers(j,2),[0.5 0.5 0.5]);
    end
    patch(gripBarX+ws.grippers(j,1),[ws.grippers(j,2)+0.5 h h ws.grippers(j,2)+0.5 ws.grippers(j,2)+0.5],[0.7 0.7 0.7]);  
    gnamehandle=text(ws.grippers(j,1)-0.2,ws.grippers(j,2),gripnames(j));
    set(gnamehandle,'FontSize',12)
    set(gnamehandle,'FontWeight','b')
end
