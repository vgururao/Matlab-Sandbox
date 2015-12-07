function planes()
% function simpleplane(V,w,qtraj);
% Syntax: simpleplane(V,w). A simple program to simulate a Left/Right/Straight constant velocity
% airplane. V and w are the velocity and (fixed) turn rate. qtraj is a
% qualitative trajectory in terms of basic moves, numbered 1-7. Any moves that require
% time parameters, such as straight line or S moves, are in terms of the
% time for a single circle. This purely non-dimensional description will
% need to be changed to allow dimensioned distances in the picture
% NOTE: Use the non-empty input functional form instead of test input once
% program behavior is satisfactory.

%%% Test input: comment out and move to function input form when required
V=0.3; % airplane velocity
w=pi/10; % turn rate pi/10=20 timesteps to complete a 360 deg turn
% First column is move type, second is time, which may be used (see move dictionary)
qtraj=[1 1;
    6 1;
    1 1;
    6 1;
    1 1;
    6 1;
    1 1;
    6 1;
    6 1;
    1 0.5;
    7 1;
    7 1;
    1 0.8;
    4 0.2;
    1 0.2;
    7 0.2];
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

%%%%%%%%%%%%%%% This sets up a 20x20 field, resize with realistic
%%%%%%%%%%%%%%% dimensioning
D=[20 20];
fieldpoly=[0 0 D(1) D(1) 0;0 D(2) D(2) 0 0];
figure(1)
clf
plot(fieldpoly(1,:),fieldpoly(2,:),'k') % the battlefield
hold on
axis equal
axis manual
%%%%%%%%%%%%%%%  Now define an icon for the airplane and draw it at a
%%%%%%%%%%%%%%%  nominal position, will draw it later with 'patch' command
px=[0.2 0.8 0.8 0.6 0.6 0.9 0.9 0.6 0.5 0.4 0.1 0.1 0.4 0.4 0.2 0.2 0.2 0.2 0.2 0.2]'*1.5;
py=[0.1 0.1 0.2 0.2 0.5 0.5 0.6 0.6 0.8 0.6 0.6 0.5 0.5 0.2 0.2 0.1 0.1 0.1 0.1 0.1]'*1.5;
P=[px py]; % Polygon defined as nx2 matrix
inithead=pi/2; % Initially headed north
P=polytransform(P,'trans',9.5,9.5); % call polytransform to move the thing to middle of field
P=polytransform(P,'rot',-pi/2); % 
[NUMMOVES,junk]=size(qtraj); % Number of moves in qtraj

%%%%% States: 0 is straight, 1 is left, -1 is right
%%%%% Basic moves are left/right turns by an angle, and straight ahead, we
%%%%% define more complex moves using these simple moves
%%%%% DEFINE THE DICTIONARY
movesqueue=[];
timesqueue=[0];   
circtime=2*pi/w; % Time to go in a circle, 20 time steps for test case

for k=1:NUMMOVES
    % Relative moves dictionary:
    % Straight, nR, nL (n=number of circles), sR, sL=[1 2 3 4 5]
    curmove=qtraj(k,1);
    curtime=qtraj(k,2);
    if ~isempty(timesqueue)
        ms_time=max(timesqueue);
    else
        ms_time=0;
    end
    switch curmove
        case 1
            % Straight: the second parameter is time of straight leg,
            % measured in non-dimensional units related to circle time of
            % airplane
            movesqueue=[movesqueue 0];
            timesqueue=[timesqueue ms_time+curtime*circtime];
        case 2
            % Circle CCW: the time (second column) is ignored
            movesqueue=[movesqueue -1];
            timesqueue=[timesqueue ms_time+circtime]; 
        case 3
            % Circle CW: time ignored
            movesqueue=[movesqueue 1];
            timesqueue=[timesqueue ms_time+circtime]; 
        case 4
            % Shift left: 'lane change left'... time variable is used for
            % varying distance of sideways shift between the 2 turns
            movesqueue=[movesqueue 1 0 -1];
            timesqueue=[timesqueue ms_time+[circtime/4 circtime/4+circtime*curtime 2*circtime/4+circtime*curtime]]; 
        case 5
            % Shift right
            movesqueue=[movesqueue -1 0 1];
            timesqueue=[timesqueue ms_time+[circtime/4 circtime/4+circtime*curtime 2*circtime/4+circtime*curtime]]; 
        case 6
            % Turn right: time is ignored, 90 deg right turn
            movesqueue=[movesqueue -1];
            timesqueue=[timesqueue ms_time+circtime/4];
        case 7
            % Turn left: 90 left, time is ignored
            movesqueue=[movesqueue 1];
            timesqueue=[timesqueue ms_time+circtime/4];
        otherwise
            % Hold pattern: unsupported case option leads to circling
            movesqueue=[movesqueue -1];
            timesqueue=[timesqueue ms_time+circtime];            
    end
end
MAXTIME=max(timesqueue)+2*circtime;
movesqueue=[movesqueue -1]; % Tack on a holding turn pattern at end of mission 
disp(['Move end times queue: ' num2str(timesqueue)]);
r=zeros(MAXTIME,3); % Create the empty [x,y, heading] matrix
r(1,1:3)=[10 10 0]; % Initialize
% Load the first move
curstate=movesqueue(1);
for k=1:MAXTIME
    % Draw the plane in its current position
    ph=patch(px,py,'r');   % Use patch command, will need handle to modify it later
    pause(0.05)
    if (k>=min(timesqueue))&(~isempty(movesqueue))        
        curstate=movesqueue(1);
        movesqueue=movesqueue(2:length(movesqueue));
        timesqueue=timesqueue(2:length(timesqueue));
    end
    r(k+1,1:3)=posevol(r(k,1:3),curstate,V,w);
    % Segment for changing queue using planning layer
    % [movesqueue,timesqueue]=changequeue(movesqueue,timesqueue);
    delete(ph)
    plot(r(k,1),r(k,2),'r.');
    P=polytransform(P,'trans',r(k+1,1)-r(k,1),r(k+1,2)-r(k,2)); % Move the plane polygon
    P=polytransform(P,'rot',r(k+1,3)-r(k,3)); % Rotate it
    px=P(:,1);
    py=P(:,2);    
end

function rout=posevol(rin,curstate,V,w);
% Subfunction to update state of the airplane, basically integrates
% position and heading
x=rin(1:2);
th=rin(3);
xn=x+[V*cos(th) V*sin(th)];
thn=th+curstate*w;
rout=[xn thn];
return