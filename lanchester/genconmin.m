%function [move]=general(x)
% This is the consolidator strategy, it puts all its forces against the bigger enemy formation

[val,pos]=min(x(3:4));
x(pos)=x(1)+x(2);
if pos==1
   x(2)=0;
else
   x(1)=0;
end
redmove=[x(1) x(2)]';
