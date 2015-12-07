function basicdyn
% BASICDYN Demonstration file for dynamic trapeze blocks world
%   Syntax: basicdyn. The first few lines can be edited to load worlds
%   other than the default 'occ1'.

global MR
close all
MAKEMOVIE=1; % Make a movie if set to 1
% Insert world selection and loading code here
tbw=loadworld('occ1')

[gh]=blocksdraw(tbw,[],gca,'INIT')
if MAKEMOVIE
    MR=getframe;
end

tbw.xc(tbw.numBlocks*6+3)=tbw.xc(tbw.numBlocks*6+3)+5; 
% Let's increase the pendulum length here

x0=[tbw.xc(tbw.numBlocks*6+1) 0 tbw.xc(tbw.numBlocks*6+5) 0];
% Animating only the first cart/pendulum. We are fixing the pendulum length
% here, so the integration only requires cart position and rod angle.
% That's why we are skipping the extraction of the rod length. Dynamics
% will be MUCH more complex if you want to model that. This code also does
% not model the changes due to block loading.
t=0;
tspan=linspace(0,30);
options=odeset('Events',@pendevents);
[T,xvec, TE,YE,IE] = ode45(@pendyn,tspan,x0,options);

% Visualization code
for k=1:length(T)
    tbw.xc(tbw.numBlocks*6+1)=xvec(k,1);
    tbw.xc(tbw.numBlocks*6+2)=xvec(k,2);
    tbw.xc(tbw.numBlocks*6+5)=xvec(k,3);
    tbw.xc(tbw.numBlocks*6+6)=xvec(k,4);
    [gh]=blocksdraw(tbw,gh,gca,'UPDATE');
    pause(0.1)
    if MAKEMOVIE
        MR=[MR getframe];
    end
end
figure(2)
plot(T,xvec(:,1),'-',T,xvec(:,2),'g')

function [xdot,eventvals,isterms,dirs]=pendyn(t,x);
% PENDDYN Pendulum on a cart dynamics for use with ode45
%   Use this function to integrated pendulum on a cart dynamics. It will
%   need to be augmented to have mass adaptation for block pick up. I don't
%   know the equations for the rod extension/retraction in a dynamic
%   setting. If you can derive the Lagrangian and find the model, I'd like
%   to know!

global tbw
% Okay, this global is a lousy hack

m=tbw.Pend(1).m; % Pendulum mass
M=tbw.Pend(1).M; % Cart mass
g=tbw.g; % Gravity
d=tbw.Pend(1).d; % Cart friction
d=d*5;
b=tbw.Pend(1).b; % Pendulum friction
k=6; % Pendulum spring constant
R=tbw.xc(tbw.numBlocks*6+3); % Length of rod; constant
regPos=9;
cartposrate=(m*R*x(4)^2*sin(x(3))+m*g*sin(x(3))*cos(x(3))-k*(x(1)-regPos)-d*x(2)+(b/R)*x(4)*cos(x(3)))/(M+m*(sin(x(3)))^2);
pendanglerate=(-m*R*x(4)^2*sin(x(3))*cos(x(3))-(m+M)*g*sin(x(3))+k*(x(1)-regPos)*cos(x(3))+d*x(2)*cos(x(3))-(1+M/m)*(b/R)*x(4))/(R*(M+m*(sin(x(3)))^2));

xdot=[x(2) cartposrate x(4) pendanglerate]';
if abs(x(2))<0.2
    eventvals=[0 0 0]';
else
    eventvals=[1 1 1 1]';
end
isterms=[1 1 1 1]';
dirs=[0 0 0 0]';
return

function [eventvals,isterms,dirs]=pendevents(t,x)
% Very simple threshold based event detection to transition to "discrete"
% world of planning. You may want to try improving on this.
global tbw

eventval=norm(x);
if eventval<0.1
    eventvals=0;
else
    eventvals=1;
end
isterms=1;
dirs=0;
return