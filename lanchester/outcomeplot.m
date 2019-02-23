figure(3)
%set(gcf,'Position',[500,1,520,800])
clf
hold on
box on
dayvec=timevec/24;

bh=plot(dayvec,X(1,1:k)+X(2,1:k),'b-');
set(bh,'linewidth',2);

rh=plot(dayvec,Y(1,1:k)+Y(2,1:k),'r-');
set(rh,'linewidth',2);

legend('Blue forces', 'Red forces');
title('Effect of maneuvering on attrition dynamics')
xlabel('Time, days');
ylabel('Force sizes');