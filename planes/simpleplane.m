function simpleplane(qtraj,V,w,x0,planecols)
% function simpleplane(qtraj);
% Syntax: simpleplane(V,w). A simple program to simulate a Left/Right/Straight constant velocity
% airplane. V and w are the velocity and (fixed) turn rate. qtraj is a
% qualitative trajectory in terms of basic moves, numbered 1-7. Any moves
% that require
% time parameters, such as straight line or S moves, are in terms of the
% time for a single circle. This purely non-dimensional description will
% need to be changed to allow dimensioned distances in the picture
% NOTE: Use the non-empty input functional form instead of test input once
% program behavior is satisfactory.
numplanes=length(V);
[allmovesqueue,alltimesqueue,MAXTIME]=refineplan(qtraj,w);
%%%%%%%%%% Main simulation loop
x=zeros(MAXTIME,3*numplanes); % Create the empty [x,y, heading] matrix
x(1,:)=x0; % Initialize
[ph,Pall]=initscene(x(1,:),planecols);
% Load the first move
for k=1:MAXTIME
    for j=1:numplanes
        P(1:20,1:2)=Pall(1:20,1:2,j);
        movesqueue=allmovesqueue(j,:);
        timesqueue=alltimesqueue(j,:);
        if (k>=timesqueue(1))&(~isempty(movesqueue))        
            curstate(j)=movesqueue(1);
            movesqueue=movesqueue(2:length(movesqueue));
            timesqueue=timesqueue(2:length(timesqueue));
            allmovesqueue(j,:)=[movesqueue -1];
            alltimesqueue(j,:)=[timesqueue MAXTIME];
        end
        x(k+1,(j-1)*3+1:(j-1)*3+3)=posevol(x(k,(j-1)*3+1:(j-1)*3+3),curstate(j),V(j),w(j));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
        % Redraw the plane in its current position
        plot(x(k,(j-1)*3+1),x(k,(j-1)*3+2),planecols(j));
        P=polytransform(P,'trans',x(k,(j-1)*3+1)-x(1,(j-1)*3+1),x(k,(j-1)*3+2)-x(1,(j-1)*3+2));
        P=polytransform(P,'rot',x(k,(j-1)*3+3)-x(1,(j-1)*3+3)); % Rotate it
        set(ph(j),'Xdata',P(:,1),'Ydata',P(:,2))
    end
    pause(0.01)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Functions and function stubs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function xout=posevol(xin,curstate,V,w);
% FUNCTION 1: POSEVOL - domain evolution
%   This simply integrates position
xy=xin(1:2);
th=xin(3);
xyn=xy+[V*cos(th) V*sin(th)];
thn=th+curstate*w;
xout=[xyn thn];
return


function [allmovesqueue,alltimesqueue,MAXTIME]=refineplan(qtraj,w)
% FUNCTION 2: MOVE TRANSLATION DICTIONARY
%   This translates the 7-move vocabulary used in qtraj to the 3-move
%   vocabulary, and changes relative times to absolute times
%%%%% States: 0 is straight, 1 is left, -1 is right
%%%%% Basic moves are left/right turns by an angle, and straight ahead, we
%%%%% define more complex moves using these simple moves
%%%%% DEFINE THE DICTIONARY
circtime=2*pi./w; % Time to go in a circle, 20 time steps for test case
[numplanes,NUMMOVES]=size(qtraj); 
numplanes=numplanes/2; % Each plane has two rows
allmovesqueue=[];
alltimesqueue=zeros(numplanes,1);   
for i=1:numplanes
    movesqueue=[]; % allmovesqueue is initialized empty
    timesqueue=[0];
    for k=1:NUMMOVES
        % Relative moves dictionary:
        % Straight, nR, nL (n=number of circles), sR, sL=[1 2 3 4 5]
        curmove=qtraj((i-1)*2+1,k);
        curtime=qtraj((i-1)*2+2,k);
        if ~isempty(timesqueue)
            ms_time=max(timesqueue);
        else
            ms_time=0;
        end
        switch curmove
            case 1
                % Straight: the second parameter is time of straight leg,
                % measured in non-dimensional units related to minimum circle 
                % time of airplane
                movesqueue=[movesqueue 0];
                timesqueue=[timesqueue ms_time+curtime*circtime(i)];
            case 2
                % Circle CCW: the time (second column) is ignored
                movesqueue=[movesqueue -1];
                timesqueue=[timesqueue ms_time+circtime(i)]; 
            case 3
                % Circle CW: time ignored
                movesqueue=[movesqueue 1];
                timesqueue=[timesqueue ms_time+circtime(i)]; 
            case 4
                % Shift left: 'lane change left'... time variable is used for
                % varying distance of sideways shift between the 2 turns
                movesqueue=[movesqueue 1 0 -1];
                timesqueue=[timesqueue ms_time+[circtime(i)/4 circtime(i)/4+circtime(i)*curtime 2*circtime(i)/4+circtime(i)*curtime]]; 
            case 5
                % Shift right
                movesqueue=[movesqueue -1 0 1];
                timesqueue=[timesqueue ms_time+[circtime(i)/4 circtime(i)/4+circtime(i)*curtime 2*circtime(i)/4+circtime(i)*curtime]]; 
            case 6
                % Turn right: time is ignored, 90 deg right turn
                movesqueue=[movesqueue -1];
                timesqueue=[timesqueue ms_time+circtime(i)/4];
            case 7
                % Turn left: 90 left, time is ignored
                movesqueue=[movesqueue 1];
                timesqueue=[timesqueue ms_time+circtime(i)/4];
            otherwise
                % Hold pattern: unsupported case option leads to circling
                movesqueue=[movesqueue -1];
                timesqueue=[timesqueue ms_time+circtime(i)];            
        end
    end
    allmovesqueue(i,1:length(movesqueue))=movesqueue;
    alltimesqueue(i,1:length(timesqueue))=timesqueue;
end
% Tack on a holding turn pattern at end of mission, a 2-loop loiter. This
% will be useful as a wait mechanism for a new plan.

MAXTIME=max(max(timesqueue))+2*max(circtime);
allmovesqueue=[allmovesqueue -1*ones(numplanes,1)]
alltimesqueue

function [ph,Pall]=initscene(x,planecols)
% FUNCTION 3: Scene graphics initialization
numplanes=length(x)/3;
figure(1)
clf
hold on
axis equal
%%%%%%%%%%%%%%%  Now define an icon for the airplane and draw it at a
%%%%%%%%%%%%%%%  nominal position, will draw it later with 'patch' command
px=([0.2 0.8 0.8 0.6 0.6 0.9 0.9 0.6 0.5 0.4 0.1 0.1 0.4 0.4 0.2 0.2 0.2 0.2 0.2 0.2]'-0.5)*1.5;
py=([0.1 0.1 0.2 0.2 0.5 0.5 0.6 0.6 0.8 0.6 0.6 0.5 0.5 0.2 0.2 0.1 0.1 0.1 0.1 0.1]'-0.5)*1.5;
Pall=zeros(20,2,numplanes);
for k=1:numplanes
    P=[px py]; % Polygon defined as nx2 matrix
    P=polytransform(P,'trans',x((k-1)*3+1),x((k-1)*3+2)); % call polytransform to move the thing to middle of field
    P=polytransform(P,'rot',-pi/2+x((k-1)*3+3)); % 
    ph(k)=patch(P(:,1),P(:,2),planecols(k));   % Use patch command, will need handle to modify it later
    Pall(1:20,1:2,k)=P;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% STUB FUNCTIONS, REACTION, RECOVERY, REPLAN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% STUB #1 Reactive planning
% If you want to use partial global state feedback (self state, other
% states) to implement things like a) missile avoidance, b) dogfighting
% c) Modifying measurement-dependent details to the qtraj, this is the
% place to do it. Not that these are OUTER-LOOP reactions. If you want
% to model, say, a wind gust that throws the plane off the nominal
% trajectory, you'd need to add that disturbance process to 'posevol',
% maintain a nominal and actual state, and do regulate to the nominal.
% We won't do this, we'll assume it is being done well enough that we
% can assume that the nominal and actual are identical. The psedocode
% for any reactive planning code-invocation is below: 
% 
% [movesqueue,timesqueue]=reaction(movesqueue,timesqueue,r-self,r-other)
% 
% STUB #2 Recovery policy
% What happens after you've (say) inserted a zig-zag into movesqueue to
% avoid a missile? You can do one of two things, you can use an
% assumption about the INTENTION of the original qualitative trajectory
% to directly modify movesqueue and timesqueue. A trivial example assumption 
% is that qtraj simply intends to effect a start-to-finish transfer (in
% which case, you could recompute to the original destination using
% movesqueue directly (rendering the whole qtraj level redundant). A
% less trivial example is to assume that qtraj encodes tactical
% maneuvering intentions of the planner (say a feint maneuver) in which
% case you want to get back to the trajectory (not replan to the destination).
% Finally, the intentions of qtraj may not be visible in the geometry
% at all. For example qtraj may be a sky-writing trajectory that smokes
% a "HELLO" into the sky. In these ``semantic intention" cases, you are
% forced to do qualitative replanning. These are not exclusive -- you may
% try several recovery policies by testing conditions, and invoke
% qualitative replanning if none of them is appropriate. Pseudo code
% is:
% 
% [movesqueue,timesqueue]=recovery(movesqueue,timesqueue,r-self,r-other,qtraj)
%
% STUB #1 Qualitative replanning
% There are two good reasons to do qualitative replanning. First, you
% might want to delibrately throw away the old qtraj because of a newly
% adopted intention, in which case you want to be able to interrupt
% processing top-down. Second, your policy-checking may have failed to
% recover after a reaction. You would pass the 
%
% [movesqueue,timesqueue,qtraj]=replan(movesqueue,timesqueue,qtraj) 
