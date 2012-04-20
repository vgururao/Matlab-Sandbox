% 3-gripper blocksworld
% TO DO: Update the 'Gripped' condition to detect the right value of
% gripper y position (offset from cartheight... cartheight-gripY)
% TO DO: Change the position motions to +/- blockHeight/blockWidth
% variables
global MR
MAKEMOVIE=0;
SHOWMOVES=1;
clf
tbw=trapblocksinit;

% Restrict motion to blockwidth/height units...
HORSTEP=max(tbw.blockX)-min(tbw.blockX)
VERTSTEP=max(tbw.blockY)-min(tbw.blockY)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Move to more convenient coordinates for this discrete world
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% xoff=[0 1 1 2 3 4 4 5 6 7];
% yoff=[0 0 1 0 0 0 1 0 0 0];
% grippers=[3 5 0;8 4 0;5 10 0]; % [x y open/closed]
[gh]=blocksdraw(tbw,[],gca,'INIT')

if MAKEMOVIE
    MR=getframe;
end
pause
% Queue of commands to each gripper, 3 parallel action sequences: left,
% right, up, down, gripper toggle: NULL=0, L=1, R=2, U=3, D=4, GT=5, -1=
% End of Queue
commQueues=zeros(3,100);
commQueues(1:3,100)=[-1 -1 -1]';
% commQueues(1:3,1:9)=[1 2 3 4 5 5 5 5 -1;1 2 3 4 5 5 5 5 -1;1 2 3 4 5 5 5 5 -1];
qLen=16;
commQueues(1,1:qLen)=[2 4 4 4 4 5 3 3 1 1 1 4 5 3 3 0];
% commQueues(2,1:qLen)=[1 4 4 4 4 5 3 3 3 2 4 4 4 5 3 3];
% commQueues(3,1:qLen)=[4 4 4 4 4 4 4 4 4 4 5 3 1 5 3 0];
commQueues(1:3,qLen+1)=[-1 -1 -1]';

% -1 is the end of queue indicator. Simulation will stop after 100 nulls,
% if nothing happens.
tcount=1
while ~(commQueues(1:3,1)==[-1 -1 -1]');
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
        if (commQueues(k,1)==5)&(tbw.xd(gGripi)==0)
            % Anything held is released
            if SHOWMOVES
                disp(['Releasing' num2str(k)])
            end
            tbw.holdState(k,1:10)=zeros(1,10);
        elseif (commQueues(k,1)==5)&(tbw.xd(gGripi)==1)
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
            disp(['Block 7: ' num2str(tbw.xc(37:39))]);
            disp(['Gripper 1: ' num2str([tbw.xc(61) tbw.cartHeight-tbw.xc(63)])]);
            allBx=find(tbw.xc(1:6*tbw.numBlocks)==tbw.xc(6*tbw.numBlocks+6*(k-1)+1))
            allBy=find(tbw.xc(1:6*tbw.numBlocks)==tbw.cartHeight-tbw.xc(6*tbw.numBlocks+6*(k-1)+3))
            grabbedBlock=[];
            blockInd=[];
            if ~isempty(allBx)&~isempty(allBy)
                % Ineffcient way of finding grabbed blocks... should be able to
                % write better code using 'find' operations 
                FINDINGBLOCK=1
                ix=1;
                while FINDINGBLOCK
                    if mod(allBx(ix),6)==1 % Only every 6th element is an x coord
                        blockInd=find((allBy==allBx(ix)+2)) % Corresponding y coord matches
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
            

    % Move queue up
    commQueues=commQueues(1:3,2:100);
    commQueues(1:3,100)=[0 0 0]';
    [gh]=blocksdraw(tbw,gh,gca,'UPDATE');
    pause(0.2)
    if MAKEMOVIE
        MR=[MR getframe];
    end
    tcount=tcount+1;
end
    
    