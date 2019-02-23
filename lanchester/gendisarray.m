% function [move]=general(x)
% This is the random redeployment strategy, add red/blue suffixes
i=round(rand)+1;
m=floor(rand*x(i))
if i==1
   j=2;
else
   j=1
end

x(i)=x(i)-m;
x(j)=x(j)+m;
move=[x(1);x(2)]