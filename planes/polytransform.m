function Pout=polytransform(P,s,varargin)
% POLYTRANSFORM Linearly transforms an input polygon P 
%   Syntax: Pout=polytransform(P,s,DATA), where P is the input polygon,
%   string s is the desired operation ('trans', 'rot', 'scale' are
%   supported in current version). P must be an nx2 matrix.
%   Linear translation: Pout=ptrans(P,'trans',Dx,Dy) 
%   CCW rotation: Pout=ptrans(P,'rot',theta)
%   Expansion/Contraction: Pout=ptrans(P,'scale',scalefactor).



% Get the centroid
[nverts,junk]=size(P);
pcent=ones(nverts,1)*[mean(P(1:nverts-1,1)) mean(P(1:nverts-1,2))];

thetavec=linspace(0,2*pi);

switch s
    case 'trans'
        Dx=varargin{1};
        Dy=varargin{2};
        Pout=P+ones(nverts,1)*[Dx Dy];
    case 'rot'
        th=varargin{1};
        R=[cos(th) -sin(th);sin(th) cos(th)];
        Pout=pcent+(R*(P-pcent)')';
    case 'scale'
        gam=varargin{1};
        R=eye(2)*gam;
        Pout=pcent+(R*(P-pcent)')';
    case 'stretch'
        Pout=P;
        % Not yet coded
    otherwise
        Pout=P;
end
