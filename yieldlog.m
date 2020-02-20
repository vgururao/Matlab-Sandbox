
% A simple model of yield from creative activities, assuming that the output
% volume/unit time declines over time, but not to zero, while yield rate
% increases as taste improves and "formulas" stabilize

tvec=linspace(1,100); % time vec
a=100; % y-intercept of assumed linear decay output volume
b=-0.95; % slope of output volume
c=0.01; % slope of yield rate function (improving quality)

% absolute yield, this is basically the logistic map
yvec=c*tvec.*(a+b*tvec);

% now plot it all

figure(1)
clf
hold on
box on
plot(tvec,a+b*tvec,'r--');
plot(tvec,100*c*tvec,'b--');
plot(tvec,yvec,'k');
xlabel('Time');
ylabel('Percentage');
legend('Output volume/unit time (% of initial)','Yield Rate %','Absolute yield (as % of max output at 100% yield')
title('The selection/control tradeoff');