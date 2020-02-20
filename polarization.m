% Make a little movie

pivec=linspace(0,2*pi);

figure(1)
clf
axis equal
box on
axis([-5 5 -5 5]);
axis off

patch(cos(pivec),sin(pivec),'r');
text