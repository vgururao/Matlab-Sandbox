function [gh]=blocksdraw(tbw,gh,axh,FLAG)
% BLOCKSDRAW Draw an instantaneous snapshot of a trapeze blocks world
%   Syntax: [gh]=blocksdraw(tbw,gh,axh,FLAG). tbw is a structure describing
%   a trapeze blocks world (created by trapblocksinit), gh is a structure
%   of graphic object handles (set to [] on the first invocation), and FLAG
%   is a string with values 'INIT' or 'UPDATE'
%
%   SEE ALSO: TRAPBLOCKSINIT
%

axes(gca);
if strcmp(FLAG,'INIT')    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% Initialization graphics
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cla
    hold on
    axis equal
    grid on
    blockWidth=max(tbw.blockX)-min(tbw.blockX);
    blockHeight=max(tbw.blockY)-min(tbw.blockY);
    OffX=blockWidth/2;
    OffY=blockHeight/2;
    gripWidth=max([tbw.gripOpenX tbw.gripClosedX])-min([tbw.gripOpenX tbw.gripClosedX]);
    gripHeight=max([tbw.gripOpenY tbw.gripClosedY])-min([tbw.gripOpenY tbw.gripClosedY]);
    roomX=[-(tbw.numGrips+2)*gripWidth-OffX -(tbw.numGrips+2)*gripWidth-OffX tbw.roomWidth-...
         (tbw.numGrips+2)*gripWidth-OffX tbw.roomWidth-(tbw.numGrips+2)*gripWidth-OffX -(tbw.numGrips+2)*gripWidth-OffX];
    roomY=[-blockHeight/2  tbw.roomHeight-blockHeight/2 tbw.roomHeight-...
        blockHeight/2  -blockHeight/2 -blockHeight/2];
    viewFrame=plot(roomX,roomY,'k');
    % Plot the railing on which the sliders move
    patch(roomX,tbw.cartHeight+tbw.cartY*0.7,tbw.rodCartColor);
    set(viewFrame,'LineWidth',2);
    actX=tbw.roomWidth-2*(tbw.numGrips+2)*gripWidth;
    actY=tbw.roomHeight-4*gripHeight;
    blockSpace=plot([-OffX -OffX actX-OffX actX-OffX -OffX],[-OffY actY-OffY actY-OffY -OffY -OffY],'k');
    set(blockSpace,'LineWidth',2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%% Draw the blocks for the first time
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for k=1:tbw.numBlocks
        xoff=tbw.xc(6*(k-1)+1);
        yoff=tbw.xc(6*(k-1)+3);
        th=tbw.xc(6*(k-1)+5);
        newCoords=[cos(th) -sin(th);sin(th) cos(th)]*[tbw.blockX;tbw.blockY];
        blockX=newCoords(1,:)+xoff;
        blockY=newCoords(2,:)+yoff;
        gh.B(k)=patch(blockX, blockY,tbw.colorVec(tbw.blockCols(k)));
        % Set any block display properties here
        gh.Bn(k)=text(xoff-0.1,yoff,num2str(k));
        set(gh.Bn(k),'FontSize',10)
        set(gh.Bn(k),'FontWeight','b')
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%% Draw the grippers and suspension bars for the first time
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for k=1:tbw.numGrips
        xCart=tbw.xc(tbw.numBlocks*6+6*(k-1)+1);       
        barLength=tbw.xc(tbw.numBlocks*6+6*(k-1)+3);
        th=tbw.xc(tbw.numBlocks*6+6*(k-1)+5);
        xoff=xCart+barLength*sin(th);
        yoff=tbw.cartHeight-barLength*cos(th);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%% Now draw the cart.......
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        gh.C(k)=patch(xCart+tbw.cartX,tbw.cartHeight+tbw.cartY,tbw.rodCartColor);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%% And the suspension bar...
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        gripBarY=[-barLength/2 barLength/2 barLength/2 -barLength/2 -barLength/2];

        newCoords=[cos(th) -sin(th);sin(th) cos(th)]*[tbw.gripBarX;gripBarY];
        barX=newCoords(1,:)+xCart+(barLength*sin(th))/2;
        barY=newCoords(2,:)+tbw.cartHeight-barLength*cos(th)/2;
        gh.R(k)=patch(barX,barY,tbw.rodCartColor);        
        th=tbw.xc(tbw.numBlocks*6+6*(k-1)+5);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% Finally, draw the grippers
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if ~tbw.xd(3*(k-1)+1)
            newCoords=[cos(th) -sin(th);sin(th) cos(th)]*[tbw.gripOpenX;tbw.gripOpenY];
            gripX=newCoords(1,:)+xoff;
            gripY=newCoords(2,:)+yoff;
            gh.G(k)=patch(gripX, gripY,tbw.gripOpenColor);
        else
           newCoords=[cos(th) -sin(th);sin(th) cos(th)]*[tbw.gripClosedX;tbw.gripClosedY];
            gripX=newCoords(1,:)+xoff;
            gripY=newCoords(2,:)+yoff;
            gh.G(k)=patch(gripX, gripY,tbw.gripClosedColor);
        end
        gh.Gn(k)=text(xoff-0.2,yoff,tbw.gripNames(k));
        set(gh.Gn,'FontSize',10)
        set(gh.Gn,'FontWeight','b')
    end
elseif strcmp(FLAG,'UPDATE')
    % Update  the blocks
    for k=1:tbw.numBlocks
        xoff=tbw.xc(6*(k-1)+1);
        yoff=tbw.xc(6*(k-1)+3);
        th=tbw.xc(6*(k-1)+5);
        newCoords=[cos(th) -sin(th);sin(th) cos(th)]*[tbw.blockX;tbw.blockY];
        blockX=newCoords(1,:)+xoff;
        blockY=newCoords(2,:)+yoff;
        set(gh.B(k),'Xdata',blockX,'Ydata',blockY);
        set(gh.Bn(k),'Position',[xoff-0.1 yoff])
    end

    %Update the grippers
    for k=1:tbw.numGrips
        xCart=tbw.xc(tbw.numBlocks*6+6*(k-1)+1);       
        barLength=tbw.xc(tbw.numBlocks*6+6*(k-1)+3);
        th=tbw.xc(tbw.numBlocks*6+6*(k-1)+5);
        xoff=xCart+barLength*sin(th);
        yoff=tbw.cartHeight-barLength*cos(th);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%% Now update the cart.......
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        set(gh.C(k),'Xdata',xCart+tbw.cartX,'Ydata',tbw.cartHeight+tbw.cartY);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%% And the suspension bar...
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        gripBarY=[-barLength/2 barLength/2 barLength/2 -barLength/2 -barLength/2];
        newCoords=[cos(th) -sin(th);sin(th) cos(th)]*[tbw.gripBarX;gripBarY];
        barX=newCoords(1,:)+xCart+(barLength*sin(th))/2;
        barY=newCoords(2,:)+tbw.cartHeight-barLength*cos(th)/2;
        set(gh.R(k),'Xdata',barX,'Ydata',barY);        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% and the grippers
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if ~tbw.xd(3*(k-1)+1)
            newCoords=[cos(th) -sin(th);sin(th) cos(th)]*[tbw.gripOpenX;tbw.gripOpenY];
            gripX=newCoords(1,:)+xoff;
            gripY=newCoords(2,:)+yoff;
            set(gh.G(k),'Xdata',gripX, 'Ydata',gripY);
            set(gh.G(k),'FaceColor',tbw.gripOpenColor);
        else
           newCoords=[cos(th) -sin(th);sin(th) cos(th)]*[tbw.gripClosedX;tbw.gripClosedY];
            gripX=newCoords(1,:)+xoff;
            gripY=newCoords(2,:)+yoff;
            set(gh.G(k),'Xdata',gripX, 'Ydata',gripY);
            set(gh.G(k),'FaceColor',tbw.gripClosedColor);
        end
        set(gh.Gn(k),'Position',[xoff-0.2 yoff]);        
    end
end
