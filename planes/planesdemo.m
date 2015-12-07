
% Demo file for calling the planes.m function. The 'plan' here is
% hand-coded.

V=[0.3 0.3 0.3 0.5 0.5 0.5]
w=[pi/10 pi/20 pi/30 pi/10 pi/20 pi/30];
x0=[10 10 0 12 12 0 14 14 0 8 10 0 8 12 0 8 14 0]; % Initialize
planecols=char('r','b','g','r','g','b');
qtraj=[1 6 1 6 1 6 1 6 1 6 1 6;
    1 1 1 1 1 1 1 1 1 1 1 1;
    1 7 1 7 1 4 1 7 1 7 1 7;
    1 1 1 1 1 1 1 1 1 1 1 7;
    1 7 1 7 1 4 1 7 1 7 1 4;
    1 1 1 1 1 1 1 1 1 1 1 0.2];

qtraj=[qtraj;qtraj]
simpleplane(qtraj,V,w,x0,planecols)