% 3-gripper blocksworld
global MR
MAKEMOVIE=1;
ws=struct('xoff',[],'yoff',[],'grippers',[]);
ws.xoff=[0 1 1 2 3 4 4 5 6 7];
ws.yoff=[0 0 1 0 0 0 1 0 0 0];
ws.blockcols=ceil(3*rand(10,1)); % Color the blocks randomly
ws.grippers=[3 5 0;8 4 0;5 10 0]; % [x y open/closed]
holdState=zeros(3,10); % holdState(i,j)=1 if gripper i is carrying block j
blocksdrawold(ws)
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
commQueues(1,1:16)=[2 4 4 4 4 5 3 3 1 1 1 4 5 3 3 0];
commQueues(2,1:16)=[1 4 4 4 4 5 3 3 3 2 4 4 4 5 3 3];
commQueues(3,1:16)=[4 4 4 4 4 4 4 4 4 4 5 3 1 5 3 0];
commQueues(1:3,17)=[-1 -1 -1]';

% -1 is the end of queue indicator. Simulation will stop after 100 nulls,
% if nothing happens.
tcount=1
while ~(commQueues(1:3,1)==[-1 -1 -1]');
    % FIRST, update all gripper states
    disp(['Step: ' num2str(tcount) ' Gripper Moves: ' num2str(commQueues(1:3,1)')]);
    disp(['Gripper 1: ' num2str(ws.grippers(1,:))]);
    pause(0.1)
    for k=1:3
        blockInd=find(holdState(k,:)==1);
        switch commQueues(k,1)
            case -1
                error('All queues must be ended simultaneously. Pad with zeros')
            case 0
                % NULL, do nothing
            case 1
                % Left
                ws.grippers(k,1)=ws.grippers(k,1)-1;
                if ~isempty(blockInd)
                    ws.xoff(blockInd)=ws.xoff(blockInd)-1;
                end
            case 2
                % Right
                ws.grippers(k,1)=ws.grippers(k,1)+1;
                if ~isempty(blockInd)
                    ws.xoff(blockInd)=ws.xoff(blockInd)+1;
                end
            case 3
                % Up
                ws.grippers(k,2)=ws.grippers(k,2)+1;
                if ~isempty(blockInd)
                    ws.yoff(blockInd)=ws.yoff(blockInd)+1;
                end

            case 4
                % Down
                ws.grippers(k,2)=ws.grippers(k,2)-1;
                if ~isempty(blockInd)
                    ws.yoff(blockInd)=ws.yoff(blockInd)-1;
                end
            case 5
                % Open... can also implement as a toggle, 1-currstate
                ws.grippers(k,3)=1-ws.grippers(k,3);
            otherwise
                error('Unsupported primitive command option')             
        end
    end
    % Check to see if anything was gripped or released
    for k=1:3
        if (commQueues(k,1)==5)&(ws.grippers(k,3)==0)
            % Anything held is released
            disp('Releasing')
            holdState(k,1:10)=zeros(1,10);
        elseif (commQueues(k,1)==5)&(ws.grippers(k,3)==1)
            disp('Grabbing')
            % Any coincident block is gripped
            blockInd=find((ws.xoff==ws.grippers(k,1))&(ws.yoff==ws.grippers(k,2)));
            if ~isempty(blockInd)
                holdState(k,blockInd)=1;
            end
        end
    end           
            

    % Move queue up
    commQueues=commQueues(1:3,2:100);
    commQueues(1:3,100)=[0 0 0]';
    blocksdrawold(ws)
    if MAKEMOVIE
        MR=[MR getframe];
    end
    tcount=tcount+1;
end
    
    