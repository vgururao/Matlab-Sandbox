% function [move]=general(x)
% This is the basic greedy tactic, to use, add red/blue suffixes

if (x(1)/(x(3)+0.1)<0.5)&(x(1)>0)
   move=[0 x(2)+x(1)]';
elseif (x(1)/(x(3)+0.1)>2)
   move=[ceil(x(1)/2) x(2)+floor(x(1)/2)]';
elseif ((x(2)/(x(4)+0.1)<0.5)&(x(2)>0))
   move=[x(1)+x(2) 0]';
elseif x(2)/(x(4)+0.1)>2
   move=[x(1)+floor(x(2)/2) ceil(x(2)/2)]'; 
else
   move=[x(1) x(2)]'
end