function tbw=loadworld(varargin)
% LOADWORLD Load a Trapeze Blocks world configuration structure tbw
%   Syntax: loadworld('worldname') loads the file, worlds/worldname.mat.
%   If no argument is provided, a list of available worlds is displayed.
%   The structure tbw is returned as well as declared global. Modify as
%   appropriate for your purpose.

global tbw
   
if nargin==0;
    w=what('worlds');
    disp('Available Worlds')
    disp('----------------')
    disp(w.mat)
    worldname=[];
    while isempty(worldname)
        worldname=input('Name of world to load: ','s');
    end
else
    worldname=varargin{1};
end
load(strcat('worlds/',worldname));

