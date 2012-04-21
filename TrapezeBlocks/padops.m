function newmat=padops(oldmat,oppar)
% PADOPS Pad and truncate matrices and vectors. 
%   Syntax: newmat=padops(oldmat,oppar). oldmat is a vector or matrix. oppar
%   is 0 if trimming of zeros is desired, and the total size to pad to if
%   padding is desired. Row and column vectors return padded/trimmed row and
%   column vectors. Matrices return padded/trimmed matrices with the same
%   number of columns (i.e it is assumed that rows need to be trimmed or
%   padded). 


[n,m]=size(oldmat);
if ~((n==1)|(m==1))
    if oppar==0
        % call ptrunc
        newmat=ptrunc(oldmat);
    else
        % call ptruncinv
        newmat=ptruncinv(oldmat,oppar);
    end
else
    if oppar>0
        % call trailpad
        newmat=trailpad(oldmat,oppar);
    else
        % call trimtail
        newmat=trimtrail(oldmat);
    end
end
 


function Pout=ptrunc(Pin)
% Function to get trailing zero rows out of a matrix. If trailing zero
% columns are expected, pass transpose to this padops. MODIFY THIS TO NOT
% BE FOOLED BY INTERMEDIATE ZERO ROWS
Pout=[];
[maxrows,maxcols]=size(Pin);
for j=1:maxrows
    if ~(norm(Pin(j,:))==0)
        Pout=[Pout;Pin(j,:)];
    end
end
     
function Pout=ptruncinv(Pin,maxverts)
% Pads a matrix with extra zero rows to bring it up to size maxvertsXk

[nrows,ncols]=size(Pin);

if nrows>maxverts
    error('Error: input matrix has more rows than maximum designated for padding')
else
    Pout=[Pin;zeros(maxverts-nrows,ncols)];
end

function y=trimtrail(x)
% Removes trailing zeros from a vector. If there exists a MATLAB function
% for this, lemme know!

n=length(x);
for i=1:n
    if sum(x(i:n))==0
        y=x(1:i-1);
        return;
    end
end
y=x;

function [xret]=trailpad(xin,m)
% Pads the vector x with enough zeros to make it of length m
[vr,vc]=size(xin);

if vr==1
    x=xin;
    FLAG=0;
else
    x=xin';
    FLAG=1;
end

if length(x)<m
    xret=[x zeros(1,m-length(x))];
elseif length(x)==m
    xret=x;
else
    warning('Warning: vector longer than pad length; truncating')
    xret=x(1:m);
end

if FLAG
    xret=xret';
end