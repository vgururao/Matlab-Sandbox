function pendcart
% Pendulum on a cart

% Dynamics parameters, to be passed to ODE45
% m= pendulum mass, M= cart mass, g=gravity, d=cart damping, b=pendulum
% damping, k=spring constant (nominal position=0), R=length of rod
Pend=struct('m',5,'M',2,'g',9.8,'d',1,'b',1,'k',6,'R',8);
% Graphics parameters
cartsize=[1 1];
cartheight=10;
bobradius=0.5;
Rsize=[20 20];

x0=[-10 0 pi/2 0]'; % Initial state vector, position, velocity, angle, angular velocity. 
t=0;
tspan=linspace(0,30);
options=odeset('Events',@pendevents);
[T,xvec, TE,YE,IE] = ode45(@pendyn,tspan,x0,options,Pend);
TE
YE
IE
figure(1)
clf
hold on
axis equal
% Cart
xcart=[-0.5 -0.5 0.5 0.5 -0.5]; ycart=[-0.5 0.5 0.5 -0.5 -0.5];
xcart=xcart*cartsize(1);
ycart=ycart*cartsize(2);
% Pendulum
xpend=bobradius*sin(linspace(0,2*pi));ypend=bobradius*cos(linspace(0,2*pi));
% Plot the initial animation scene
plot([-Rsize(1) -Rsize(1) Rsize(1) Rsize(1) -Rsize(1)],[-Rsize(2) Rsize(2) Rsize(2) -Rsize(2) -Rsize(2)]);
ch=plot(xcart+x0(1),ycart+cartheight,'k');
bobh=patch(x0(1)+Pend.R*sin(x0(3))+xpend,cartheight-Pend.R*cos(x0(3))+ypend,'k');
rodh=plot([x0(1) x0(1)+Pend.R*sin(x0(3))],[cartheight cartheight-Pend.R*cos(x0(3))],'k');
set(rodh,'Linewidth',2);
figure(2)
thvec=linspace(0,2*pi,100);
figure(1)

for k=1:length(T)
    set(ch,'Xdata',xcart+xvec(k,1),'Ydata',ycart+cartheight);
    set(bobh, 'Xdata', xvec(k,1)+Pend.R*sin(xvec(k,3))+xpend, 'Ydata',cartheight-Pend.R*cos(xvec(k,3))+ypend);
    set(rodh, 'Xdata',[xvec(k,1) xvec(k,1)+Pend.R*sin(xvec(k,3))],'Ydata',[cartheight cartheight-Pend.R*cos(xvec(k,3))]);
    circ=plot(xvec(k,1)+Pend.R*sin(thvec),cartheight-Pend.R*cos(thvec),'r:');
    pause(0.1);
    delete(circ)
end







function [xdot,eventvals,isterms,dirs]=pendyn(t,x,varargin);
% PENDDYN Pendulum on a cart dynamics for use with ode45
%   Use this function to integrated pendulum on a cart dynamics
Pend=varargin{1};
m=Pend.m; % Pendulum mass
M=Pend.M; % Cart mass
g=Pend.g; % Gravity
d=Pend.d; % Cart friction
b=Pend.b; % Pendulum friction
k=Pend.k; % Pendulum spring constant
R=Pend.R; % Length of rod; constant

cartposrate=(m*R*x(4)^2*sin(x(3))+m*g*sin(x(3))*cos(x(3))-k*x(1)-d*x(2)+(b/R)*x(4)*cos(x(3)))/(M+m*(sin(x(3)))^2);
pendanglerate=(-m*R*x(4)^2*sin(x(3))*cos(x(3))-(m+M)*g*sin(x(3))+k*x(1)*cos(x(3))+d*x(2)*cos(x(3))-(1+M/m)*(b/R)*x(4))/(R*(M+m*(sin(x(3)))^2));

xdot=[x(2) cartposrate x(4) pendanglerate]';
if abs(x(2))<0.2
    eventvals=[0 0 0]';
else
    eventvals=[1 1 1 1]';
end
isterms=[1 1 1 1]';
dirs=[0 0 0 0]';
return

function [eventvals,isterms,dirs]=pendevents(t,x,Pend)

eventval=norm(x);
if eventval<0.1
    eventvals=0;
else
    eventvals=1;
end
isterms=1;
dirs=0;
return