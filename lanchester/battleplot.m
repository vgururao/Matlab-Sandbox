function []=battleplot(x)

figure(1)
clf
set(gcf,'Position',[1 450 550 300])
hold on
patch([0 10 20 50 80 80 46 18 12 0],[7 8 8 7 5 12 14 14 16 12],'b')
patch([0 10 20 50 80 80 46 18 12 0],[0 0 0 0 0 1 2 1 2 2],'g')
patch([0 10 20 50 80 80 46 18 12 0],[23 25 28 26 30 30 30 30 30 30],'g')

xmax=1000;
y=xmax/20;
x=floor(x/y);

if x(1)>0
    plot(linspace(5,5+x(1),x(1)),18,'b*')
end

if x(2)>0
    plot(linspace(55,55+x(2),x(2)),20,'b*')
end

if x(3)>0
    plot(linspace(5,5+x(3),x(3)),5,'r*')
end

if x(4)>0
    plot(linspace(55,55+x(4),x(4)),5,'r*')
end

text(5,20,'Blue Left')
text(55,22,'Blue Right')
text(5,3,'Red Left')
text(55,3,'Red Right')
title('Deployment Diagram, Red versus Blue')

box on