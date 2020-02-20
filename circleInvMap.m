% inside outside map

figure(1)
axis manual;
axis equal;
axis([-5,5,-5, 5]);
hold on;
R=1
thvec=linspace(0,2*pi);

plot(R*cos(thvec),R*sin(thvec),'k:');

for k=1:10 
    r=5*rand;
    th=2*pi*rand;
    r1=1/abs(r-R);
    plot(r*cos(th),r*sin(th),'bx');
    plot(r1*cos(th),r1*sin(th),'ro');
    plot([r r1]*cos(th),[r r1]*sin(th),':');
end