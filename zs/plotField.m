function [delXg, P]=plotField
% Make a game of it!

% Let's keep track of the probabilities
global P delXg;

gh=figure(1);
clf;
set(gh,'Position',[250 100 800 600]);
axis equal;
axis manual;
axis([0 500 0 500]);
box on;
hold on;
x=floor(500*rand(50,2));
plot(x(:,1),x(:,2),'.');
nx(1,1:2)=[5 5];
sch=plot(5,5,'o');
for k=0:5:500
    for j=0:5:500
        for m=1:100
        nx=(1,2);
        plot([nx(k-1,1) nx(k,1)],[nx(k-1,2),nx(k,2)],'r:');
        nx(k,1:2)=getModifiedJump(nx(k-1),nx(k-1,2),nx(k,1),nx(k,2),'lx');
        plot([nx(k-1,1) nx(k,1)],[nx(k-1,2),nx(k,2)],'k--');
        set(sch,'XData',nx(k,1),'YData',nx(k,2));
    end
end

[nj,junk]=size(P);
jvec=1:nj;
figure(2);
plot(jvec,P(:,1:4));
legend('Potential','Distance','Total','Floored');
% Jump functions
function mx=getModifiedJump(x1,y1,x2,y2,s)
    % Compute the miss
    potFieldAtOrigin=[50 200]; % 
    dx=sqrt((x2-x1)^2+(y2-y1)^2);
    dtheta=atan2(y2-y1,x2-x1);
    switch s
        case 'lx'
            % Linear x gradient with linear distance fall off
            
            % Potential field function is simply x/500;
            p1=(potFieldAtOrigin(1)+x1)/(potFieldAtOrigin(1)+500);
            p2=(potFieldAtOrigin(1)+x2)/(potFieldAtOrigin(1)+500);
           
            if p2>p1
                % Compute the probability of being on target
                relProbP=(p1/p2); % Potential field contribution; =1 along contours
                relProbD=(500*sqrt(2)-dx)/(500*sqrt(2)); % Leap distance contribution; = higher for big leaps
                relProbT=relProbP*relProbD; % Total leap probability
                
                % Now compute actual leap probability by setting floor
                % based on absolute P(x1)
                relProb=max(p1,relProbT);
                P=[P; relProbP relProbD relProbT relProb p1 p2];
                % Now compute actual x-leap as a fraction achieved along x
                delX=(relProb+randn(1))*dx*cos(dtheta);
                delXg=[delXg;delX];
                mx(1,1)=max(0,x1+delX);
                disp([p1 delX]);
        
                % y does not
                mx(1,2)=y2;                
            else
                mx=[x2 y2];
            end
            
        case 'ly'
            % Linear y gradient
            mx=[x2 y2];
        case 'lxy'
            % Linear x-y gradient
            mx=[x2 y2];
        otherwise
            mx=[x2 y2]+ceil(50*rand(1,2));
    end
%    return mx;
end

end

