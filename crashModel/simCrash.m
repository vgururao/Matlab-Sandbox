itfunction simCrash

global canvasSize

canvasSize=[10 10];
spacelims=[-canvasSize(1)/2 canvasSize(1)/2 -canvasSize(2)/2 canvasSize(2)/2];

x0=[1 0.5 1 0.3]';
x(1:4,1)=x0;

A=[1 1 0 0;0 1 0 0;0 0 1 1;0 0 0 1];

for k=2:2000
    x(1:4,k-1)=wallBounce(x(1:4,k-1));
    x(1:4,k)=A*x(1:4,k-1);
    if k/400==round(k/400)
        disp('crash!')
        A=A+0.4*[0 randn 0 0;0 0 0 0;0 0 0 randn;0 0 0 0];
    end
end


figure(1)
clf
hold on
% plot(x(1,1:400),x(3,1:400),'.');
% plot(x(1,1:400),x(3,401:800),'r.');
% plot(x(1,1:400),x(3,801:1200),'g.');
% plot(x(1,1:400),x(3,1201:1600),'k.');
% plot(x(1,1:400),x(3,1601:2000),'b*');

for k=1:2000
    plot(x(1,k),x(3,k),'.');
    pause(0.05);
end

function xout=wallBounce(xin)
    if abs(xin(1))>canvasSize(1)
        xin(2)=-xin(2);
    end
    if abs(xin(3))>canvasSize(2)
        xin(4)=-xin(4);
    end
    xout=xin;
end


end
