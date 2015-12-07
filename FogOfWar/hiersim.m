function hiersim
% Hierarchical and non-hierarchical simulations
% First set up the parameters
global MR
MR=[];
nagents=16;
npatches=8;
nviews=15; % hierarchical case
nviews =8; % non-hierarchical case
ngrid=[5 5]; % Can we compute this in closed-form from the hierarchy size?
% Now map view grid to nviews
vGrid=[3 3;3 2;3 4;2 2;4 2;4 4;2 4;1 2;2 1;4 1;5 2;5 4;4 5;2 5;1 4];       
D=[10 10];
thvec=linspace(0,2*pi);
scfac=0.8;
Rx=[1+(D(1)-2)*rand(1,npatches)]; % Initial patch centers
Ry=[1+(D(2)-2)*rand(1,npatches)];
X(nagents,1:2,1)=[[Rx Rx]' [Ry Ry]']; % Agent i, n+i are at center
hRx=diag(Rx)*ones(npatches,nviews);
hRy=diag(Ry)*ones(npatches,nviews);
allR=getallR(1,scfac); % Get all the patch radii, set up to form well-posed net
allRx=[];
allRy=[];

for COUNT=1:100    
    for k=1:nviews
        % Update patch positions and radii
        allRx=[allRx;Rx];
        allRy=[allRy;Ry];
    end
    % Storing all radii, x, y one row per column;
    % Will add 3-d layer for each additional time?
    % Now initialize agents centered inside parent circles
    % centers
    for k=1:nagents
        agx(k)=Rx(ceil(k/2));
        agy(k)=Ry(ceil(k/2));
    end
    % now initialize all circles to center with respective agent-pairs
    fieldpoly=[0 0 D(1) D(1) 0;0 D(2) D(2) 0 0];
    figure(1)
    clf
    axis equal
    hold on
    for k=1:ngrid(1)
        for j=1:ngrid(2)
            vOff(k,j,1:2)=[(k-1)*D(1)+D(1)/2 (j-1)*D(2)+D(2)/2]+(D/10)*diag([k-1 j-1]);
            plot(fieldpoly(1,:)+vOff(k,j,1),fieldpoly(2,:)+vOff(k,j,2),'k');
            % Initial plot of all the circles
        end
    end
    for k=1:nviews
        for p=1:npatches
    %         xvec=vOff(vGrid(k,1),vGrid(k,2),1)+allRx(k,p)+allR(k,p)*cos(thvec);
    %         yvec=vOff(vGrid(k,1),vGrid(k,2),2)+allRy(k,p)+allR(k,p)*sin(thvec);
            xoff=vOff(vGrid(k,1),vGrid(k,2),1);
            yoff=vOff(vGrid(k,1),vGrid(k,2),2);
            x=allRx(k,p);
            y=allRy(k,p);
            r=allR(k,p);
            [v,A]=circrectint(x,y,r,D);
            if (k>7)&(p==k-7)
                pcol='r';
                alp=0.8;
            else
                pcol='b';
                alp=0.3
            end
    %         plot(xvec,yvec,pcol);
            ph=patch(xoff+v(:,1),yoff+v(:,2),pcol);
            set(ph,'FaceAlpha',alp)
        end
    end
    % MR=[MR getframe]
    pause(0.1)
end

function allR=getallR(R,g);
% Get the initial radius matrix for all patches, all views, given initial
% radius and scaling factor...
% TO DO: rewrite as a recursive function in
% the general case

exmat=[0 0 0 0 0 0 0 0; % 1
    1 1 1 1 -1 -1 -1 -1; % 21=2, P=1
    -1 -1 -1 -1 1 1 1 1; % 22=3, P=1
    2 2 0 0 -2 -2 -2 -2; % 211=4,P=2
    0 0 2 2 -2 -2 -2 -2; % 212=5,P=2
    -2 -2 -2 -2 2 2 0 0; % 221=6, P=3
    -2 -2 -2 -2 0 0 2 2; % 222=7, P=3
    3 1 -1 -1 -3 -3 -3 -3; % 2111=8, P=4
    1 3 -1 -1 -3 -3 -3 -3; % 2112=9, P=4
    -1 -1 3 1 -3 -3 -3 -3; % 2121=10, P=5
    -1 -1 1 3 -3 -3 -3 -3; % 2122=11, P=5
    -3 -3 -3 -3 3 1 -1 -1; % 2211=8, P=6
    -3 -3 -3 -3 1 3 -1 -1; % 2212=9, P=6
    -3 -3 -3 -3 -1 -1 3 1; % 2221=10, P=7
    -3 -3 -3 -3 -1 -1 1 3]; % 2222=11, P=7
    
    allR=R*g.^(exmat);

      
        
        
        