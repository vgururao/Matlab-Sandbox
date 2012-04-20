function pendcart
% Pendulum on a cart

close all
global tbw

[gh]=blocksdraw(tbw,[],gca,'INIT')
x0=[tbw.xc(tbw.numBlocks*6+1) 0 tbw.xc(tbw.numBlocks*6+5) 0];
t=0;
tspan=linspace(0,30);
options=odeset('Events',@pendevents);
[T,xvec, TE,YE,IE] = ode45(@pendyn,tspan,x0,options);

for k=1:length(T)
    tbw.xc(tbw.numBlocks*6+1)=xvec(k,1);
    tbw.xc(tbw.numBlocks*6+2)=xvec(k,2);
    tbw.xc(tbw.numBlocks*6+5)=xvec(k,3);
    tbw.xc(tbw.numBlocks*6+6)=xvec(k,4);
    [gh]=blocksdraw(tbw,gh,gca,'UPDATE');
    pause(0.1)
end
figure(2)
plot(T,xvec(:,1),'-',T,xvec(:,2),'g')






function [xdot,eventvals,isterms,dirs]=pendyn(t,x);
% PENDDYN Pendulum on a cart dynamics for use with ode45
%   Use this function to integrated pendulum on a cart dynamics
global tbw

m=tbw.Pend(1).m; % Pendulum mass
M=tbw.Pend(1).M; % Cart mass
g=tbw.g; % Gravity
d=tbw.Pend(1).d; % Cart friction
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