function tbw=trapblocksinit
% TRAPBLOCKSINIT Initialize a trapeze blocks world
%   Syntax: trapblocksinit
%   Creates and saves a structure to hold all data pertaining to a blocks
%   world.

% Number of blocks and grippers
% TO DO: Update the position initialization routine to work with blockWidth
% and blockHeight units
% 
global tbw
% Colors
tbw.gripOpenColor=[0.8 0.8 0.8];
tbw.gripClosedColor=[0.5 0.5 0.5];
tbw.colorVec=char('r','g','b');
tbw.rodCartColor=[0.5 0.5 0.5];

WCHOICE=menu('New trapeze blocks world', 'Default Unstacked','Default Stacked','Occupancy Distribution','Interactive definition');
switch WCHOICE
    case {1,2,3}
        % Basic parameters: number of blocks and grippers, block size
        tbw.numBlocks=10; tbw.numGrips=3; facX=1; facY=1; tbw.xc=[];
        % Continuous states: tbw.numBlocks*6 block states+tbw.numGrips*6. All in the
        % form: (x,y,theta, xdot, ydot, thdot). For grippers x refers to cart
        % position, y refers to suspension bar length, theta to gripper swing angle.
        % Cart y position is fixed.
            tbw.xc=[]
            if WCHOICE==1
                % Horizontal world
                for k=1:tbw.numBlocks
                    tbw.xc=[tbw.xc (k-1)*facX 0 0 0 0 0];
                end
                tbw.blockCols=ones(1,tbw.numBlocks); 
            elseif WCHOICE==2
                % Vertically stacked world
                for k=1:tbw.numBlocks
                    tbw.xc=[tbw.xc 0 0 (k-1)*facY 0 0 0];
                end
                tbw.blockCols=ones(1,tbw.numBlocks); 
            elseif WCHOICE==3
                % Random world (Occupancy distribution)
                for k=1:tbw.numBlocks                
                    % NOTE: choose x randomly, y to stack... this method will
                    % create an urn-occupancy distribution. See the book
                    % N.L. Johnson and S. Kotz, Urn Models and their
                    % applications,John Wiley & Sons, 1977.
                    xpos=floor((tbw.numBlocks+2)*rand);
                    filtInd1=find(tbw.xc==xpos*facX);
                    filtInd2=find(mod(filtInd1,6)==1);
                    ypos=length(filtInd2)+1;
                    tbw.xc=[tbw.xc xpos*facX 0 (ypos-1)*facY 0 0 0];
                end
                tbw.blockCols=ceil(3*rand(1,tbw.numBlocks)); 
            end
            % Gripper dynamics (pendulum-on-a-cart) parameters
            % m= pendulum mass, M= cart mass, g=gravity, d=cart damping, b=pendulum
            % damping, k=spring constant (nominal position=0), Rmin/Rmax=length range of rod
            % dB, bB are braking values of cart and pendulum
            for k=1:tbw.numGrips
                tbw.xc=[tbw.xc -k*facX 0 2*facY 0 0 0];
                tbw.Pend(k)=struct('m',5,'M',2,'d',1,'dB',10,'b',1,'bB',10);
            end            
            tbw.mB=tbw.Pend(1).m*0.5*ones(1,tbw.numBlocks); 
    case 4
        tbw.numBlocks=input('Number of blocks: ');
        tbw.numGrips=input('Number of grippers: '); 
        facX=input('Block width (m): '); 
        facY=input('Block height (m): '); 
        tbw.xc=[];
        % Continuous states: tbw.numBlocks*6 block states+tbw.numGrips*6. All in the
        % form: (x,y,theta, xdot, ydot, thdot). For grippers x refers to cart
        % position, y refers to suspension bar length, theta to gripper swing angle.
        % Cart y position is fixed.
            tbw.xc=[]
            disp('Choose initial blocks distribution')
            disp('----------------------------------')
            DISTYPE=input('Horizontal, Vertical, Occupancy or User-placed [1-4]: ');
            if DISTYPE==1
                % Horizontal world
                for k=1:tbw.numBlocks
                    tbw.xc=[tbw.xc (k-1)*facX 0 0 0 0 0];
                end
                tbw.blockCols=ones(1,tbw.numBlocks);
           elseif DISTYPE==2
                % Vertically stacked world
                for k=1:tbw.numBlocks
                    tbw.xc=[tbw.xc 0 0 (k-1)*facY 0 0 0];
                end
                tbw.blockCols=ones(1,tbw.numBlocks); 
            elseif DISTYPE==3
                % Random world (Occupancy distribution)
                for k=1:tbw.numBlocks                
                    % NOTE: choose x randomly, y to stack... this method will
                    % create an urn-occupancy distribution. See the book
                    % N.L. Johnson and S. Kotz, Urn Models and their
                    % applications,John Wiley & Sons, 1977.
                    xpos=floor((tbw.numBlocks+2)*rand);
                    filtInd1=find(tbw.xc==xpos*facX);
                    filtInd2=find(mod(filtInd1,6)==1);
                    ypos=length(filtInd2)+1;
                    tbw.xc=[tbw.xc xpos*facX 0 (ypos-1)*facY 0 0 0];
                end
                tbw.blockCols=ceil(3*rand(1,tbw.numBlocks)); 
            elseif DISTYPE==4
                tbw.xc=ones(1,6*(tbw.numBlocks+tbw.numGrips))*-1;
                figure(1)
                clf
                hold on
                for nBx=1:tbw.numBlocks+2
                    for nBy=1:tbw.numBlocks
                        temph(nBx,nBy)=patch([nBx-1 nBx-1 nBx nBx nBx-1],[nBy-1 nBy nBy nBy-1 nBy-1],'y');
                    end
                end
                for k=1:tbw.numBlocks
                    title('Click to drop a block and enter workspace data')
                    [x,y]=ginput(1);
                    x=max(0,x); x=min(x,tbw.numBlocks+2-0.1)
                    xpos=floor(x);
                    filtInd1=find(tbw.xc==xpos*facX);
                    filtInd2=find(mod(filtInd1,6)==1);
                    ypos=length(filtInd2)+1;
                    bnum=input(['Block number, 1 - ' num2str(tbw.numBlocks)  ', (do not repeat): ']);
                    tbw.xc(6*(bnum-1)+1:6*(bnum-1)+6)=[xpos*facX 0 (ypos-1)*facY 0 0 0];
                    tempcol=input('Color (R=1, G=2, B=3): ');
                    set(temph(xpos+1,ypos),'FaceColor',tbw.colorVec(tempcol));
                    text(xpos+0.5,ypos-0.5,num2str(bnum));
                    tbw.blockCols(bnum)=tempcol;
                    tbw.mB(bnum)=input('Mass (kg): ');
                end
                close(gcf)
                tbw.xc(1,6*tbw.numBlocks+1:6*(tbw.numBlocks+tbw.numGrips))=zeros(1,6*tbw.numGrips);
            end                       
            for k=1:tbw.numGrips
                tbw.xc=[tbw.xc -k*facX 0 2*facY 0 0 0];
                disp(['Gripper ' num2str(k) ' definition']);
                disp('--------------------');
                tbw.Pend(k)=struct('m',5,'M',2,'d',1,'dB',10,'b',1,'bB',10);
                tbw.Pend(k).m=input('Gripper mass (kg): ');
                tbw.Pend(k).M=input('Cart mass (kg): ');
                tbw.Pend(k).d=input('Cart damping (normal): ');
                tbw.Pend(k).dB=input('Cart damping (braking): ');
                tbw.Pend(k).b=input('Suspension damping (normal): ');
                tbw.Pend(k).bB=input('Suspension damping (braking): ');               
            end            
            
    otherwise
        error('Unsupported world creation case')
end
% Computed parameters/static parameters
tbw.g=9.8;
% 3 Discrete states per gripper: on-off positions for grippers, cart brake,
% and pendulum brake. Brakes in on position cause braking values of cart
% and pendulum dynamics to be used instead of regular.
tbw.xd=zeros(1,3*tbw.numGrips);
% holdState(i,j)=1 if gripper i is carrying block j
tbw.holdState=zeros(tbw.numGrips,tbw.numBlocks); 



% Geometric parameters
% Make the workspace big enough so that all blocks can be stacked
% vertically and still leave 3*blockY clearance, and so that grippers can be
% 'parked' on either side of the active workspace, allowing simulation of 1
% to tbw.numGrips grippers.
% Polygons for block, overhead cart-slider, end-effector and bar

% ALL MACRO DIMENSIONS DEPEND ON BLOCK DIMENSIONS, SET WITH CARE
tbw.blockX=[-0.5 -0.5 0.5 0.5 -0.5]*facX;
tbw.blockY=[-0.5 0.5 0.5 -0.5 -0.5]*facY;
% Gripper should be a smaller polygon, but coincident with top edge of
% block
tbw.gripOpenX=[-0.5 -0.4 0.4 0.5 -0.5]*facX;
tbw.gripOpenY=[-0.3 0.5 0.5 -0.3 -0.3]*facY;
tbw.gripClosedX=[-0.4 -0.5 0.5 0.4 -0.4]*facX;
tbw.gripClosedY=[-0.3 0.5 0.5 -0.3 -0.3]*facY;

blockWidth=max(tbw.blockX)-min(tbw.blockX);
blockHeight=max(tbw.blockY)-min(tbw.blockY);
gripWidth=max([tbw.gripOpenX tbw.gripClosedX])-min([tbw.gripOpenX tbw.gripClosedX]);
gripHeight=max([tbw.gripOpenY tbw.gripClosedY])-min([tbw.gripOpenY tbw.gripClosedY]);

% numBlocks+2 wide active workspace, numGrips+2 padding on each side
tbw.roomWidth=(tbw.numBlocks+2+2*(tbw.numGrips+2))*blockWidth;
% numBlocks high, with numGrips*4 vertical padding
tbw.roomHeight=(tbw.numBlocks+4)*blockHeight;
tbw.cartX=[-0.5 -0.5 0.5 0.5 -0.5]*facX;
tbw.cartY=[-0.1 0.1 0.1 -0.1 -0.1]*facY;
tbw.cartHeight=tbw.roomHeight-blockHeight;
tbw.gripBarX=[-0.1 -0.1 0.1 0.1 -0.1]*facX;
% gripBarY is dynamically computed, since it extends from cart
tbw.gripNames=char('A','B','C','D','E','F');

% Save the configuration
tbw.worldname=input('Enter trapeze blocks world name: ','s');
worldname=strcat('worlds/',tbw.worldname);
save(worldname,'tbw');
figure(1)
clf
[gh]=blocksdraw(tbw,[],gca,'INIT');