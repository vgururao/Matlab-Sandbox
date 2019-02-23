% function [move]=general(x)
% This is the balanced strategy, to use, add red/blue suffixes 
move=[floor((x(1)+x(2))/2);ceil((x(1)+x(2))/2)];
