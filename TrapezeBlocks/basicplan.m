function basicplan(varargin)
% Example functiont showing the animation of a 3-gripper trapeze blocksworld.

global MR
MAKEMOVIE=0; 
% Set to 1 for movie-making, you will need to declare MR global in the 
% workspace first. Use movie and movie2avi commands to create your movie,
% you can convert to lower weight .wmv movies from .avi using Windows Movie
% Maker, and also add things like title slides. Make sure you use the
% 'compression','none' option in movie2avi, or it will not run without a
% codec.

SHOWMOVES=0; % Set to 1 for a verbose output during plan simulation.
clf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Plan loading routine: customize to load your plans, copy some
%%%%%%%%%%%%%% of the interactive loading code in loadworld.m. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin==0;
    w=what('rawplans');
    disp('Available Raw Plans')
    disp('-------------------')
    disp(w.mat)
    planname=[];
    while isempty(planname)
        planname=input('Name of plan to load: ','s');
    end
else
    planname=varargin{1};
end
load(strcat('rawplans/',planname));
tbw=loadworld(worldname); % Load the world underlying the sample raw plan

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Restrict motion to blockwidth/height units. This constraint will be 
% relaxed if you want to model toppling dynamics (warning VERY HARD!) or
% more general placements.

HORSTEP=max(tbw.blockX)-min(tbw.blockX);
VERTSTEP=max(tbw.blockY)-min(tbw.blockY);
[gh]=blocksdraw(tbw,[],gca,'INIT'); % Initialize the graphics screen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% This is part of presentation logic, and the title handle should
%%%%%%%% really be managed by blocksdraw, but I put it here for convenience
%%%%%%%% since you are most likely to want to change this in order to put
%%%%%%%% useful run-time data in the title string. Use
%%%%%%%% set(titstring,'string',your_string) to manipulate this. You can
%%%%%%%% also use automatic text overlays with the 'text' command, and
%%%%%%%% delete it using its handle.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
titstring=title('Simulation Time Step 0');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if MAKEMOVIE
    MR=getframe;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Main plan simulation loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tcount=1;
% NOTE that the termination condition is ALL queues being -1.
while ~(commQueues(1:3,1)==[-1 -1 -1]');
    %%%%%%%%% Note how the movie is automatically annotated.
    set(titstring,'string',strcat('Simulation time step: ',num2str(tcount)));
    % FIRST, update all gripper states
    if SHOWMOVES
        disp(['Step: ' num2str(tcount) ' Gripper Moves: ' num2str(commQueues(1:3,1)')]);
    end
    pause(0.1)
    for k=1:3
        % First pull out the indices of the gripper's states
        gXi=tbw.numBlocks*6+6*(k-1)+1;
        gYi=tbw.numBlocks*6+6*(k-1)+3;
        gGripi=3*(k-1)+1;
        blockInd=find(tbw.holdState(k,:)==1);
        if ~isempty(blockInd)
           bXi=(blockInd-1)*6+1;
           bYi=(blockInd-1)*6+3;
        end
        %%% This big switch condition updates gripper positions
        
        switch commQueues(k,1)
            case -1
                error('All queues must be ended simultaneously. Pad with zeros')
            case 0
                % NULL, do nothing
            case 1
                % Left
                if SHOWMOVES
                    disp(['Left' num2str(k)])
                end
                tbw.xc(gXi)=tbw.xc(gXi)-HORSTEP;
                if ~isempty(blockInd)
                    tbw.xc(bXi)=tbw.xc(bXi)-HORSTEP;
                end
            case 2
                % Right
                if SHOWMOVES
                    disp(['Right' num2str(k)])
                end
                tbw.xc(gXi)=tbw.xc(gXi)+HORSTEP;
                if ~isempty(blockInd)
                    tbw.xc(bXi)=tbw.xc(bXi)+HORSTEP;
                end
            case 3
                % Up
                if SHOWMOVES
                    disp(['Up' num2str(k)])
                end
                % NOTE: y(gripper) change is opposite to gripped block
                % y change, because the former is the extension rod length
                tbw.xc(gYi)=tbw.xc(gYi)-VERTSTEP;
                if ~isempty(blockInd)
                    tbw.xc(bYi)=tbw.xc(bYi)+VERTSTEP;
                end

            case 4
                % Down
                if SHOWMOVES
                    disp(['Down' num2str(k)])
                end
                % NOTE: y(gripper) change is opposite to gripped block
                % y change, because the former is the extension rod length
                tbw.xc(gYi)=tbw.xc(gYi)+VERTSTEP;
                if ~isempty(blockInd)
                    tbw.xc(bYi)=tbw.xc(bYi)-VERTSTEP;
                end
            case 5
                if SHOWMOVES
                    disp(['GripperToggle' num2str(k)])
                end
              % Open... can also implement as a toggle, 1-currstate
                tbw.xd(gGripi)=1-tbw.xd(gGripi);
            otherwise
                error('Unsupported primitive command option')             
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%% Gripping logic, implemented with the tbw.holdstate variable;
        %%%%%% note that this is not a particularly brilliant solution, but
        %%%%%% it works for small numbers of grippers and blocks. For
        %%%%%% large numbers, this is a waste of space.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if (commQueues(k,1)==5)&(tbw.xd(gGripi)==0)
            % Anything held is released, releasing is easy, just zero
            % everything in the relevant row.
            if SHOWMOVES
                disp(['Releasing' num2str(k)])
            end
            tbw.holdState(k,1:10)=zeros(1,10);
        elseif (commQueues(k,1)==5)&(tbw.xd(gGripi)==1)
            % Gripping is not so easy...
            if SHOWMOVES
                disp(['Grabbing' num2str(k)])
            end
            % Any coincident block is gripped. Note that this code only
            % works for gripping one block at a time, and by checking exact
            % coincidence of gripper and block coordinates. To allow long
            % blocks to be cooperatively grabbed by multiple grippers, the
            % grab-coincidence test must be extended to a horizontal line
            % through the block coordinates, and vice versa to allow a
            % single gripper to grab multiple blocks. To implement
            % lego-style inter-block connections, you will need a second
            % data structure, similar to tbw.holdState, to capture block
            % connections.
            allBx=find(tbw.xc(1:6*tbw.numBlocks)==tbw.xc(6*tbw.numBlocks+6*(k-1)+1));
            allBy=find(tbw.xc(1:6*tbw.numBlocks)==tbw.cartHeight-tbw.xc(6*tbw.numBlocks+6*(k-1)+3));
            grabbedBlock=[];
            blockInd=[];
            if ~isempty(allBx)&~isempty(allBy)
                % Ineffcient way of finding grabbed blocks... should be able to
                % write better code using 'find' operations 
                FINDINGBLOCK=1;
                ix=1;
                while FINDINGBLOCK
                    if mod(allBx(ix),6)==1 % Only every 6th element is an x coord
                        blockInd=find((allBy==allBx(ix)+2)); % Corresponding y coord matches
                        if ~isempty(blockInd)
                            FINDINGBLOCK=0;
                            blockInd=ix;
                        end
                    end
                    if ix==length(allBx)
                        FINDINGBLOCK=0;
                    end
                    ix=ix+1;
                end
                if ~isempty(blockInd)
                    grabbedBlock=(allBx(blockInd)-1)/6+1;
                end
            end           
            if ~isempty(grabbedBlock)
                tbw.holdState(k,grabbedBlock)=1;
            end
        end
    end           
            

    % Move queue up, maintain the 100 step length.
    commQueues=commQueues(1:3,2:100);
    commQueues(1:3,100)=[0 0 0]';
    [gh]=blocksdraw(tbw,gh,gca,'UPDATE');
    % Well... blocksdraw doesn't really have an efficient update mode, but
    % this is a placeholder for the future.
    pause(0.02)
    if MAKEMOVIE
        MR=[MR getframe];
    end
    tcount=tcount+1;
    % YOU MAY WANT TO INSERT A "SAVE END STATE AS NEW WORLD? " Prompt here.
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% In this basic plan simulator, nothing can go wrong, so there is no
%%%% point in dumping a log file, since the original plan is perfectly
%%%% executed. If you ARE doing something not described in the raw plan,
%%%% you would need logfile dumping in the main while loop, and some
%%%% logfile visualizaiton here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    