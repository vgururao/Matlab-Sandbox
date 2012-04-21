function makeplan
% DEMONSTRATION of planning language definition and sample plan. This
% segment shows a very simple planning language and a sample plan in
% that language. If you want to develop a different planning language,
% you will essentially have to rewrite this file. You can use this file
% if you want to define and work with a higher-level language that
% compiles to this one. The language is the primitive action set: 
% {NULL, Left, Right, Up, Down, Gripper Toggle, EOQ}. These are encoded
% {0, 1, 2, 3, 4, 5, -1}. 

% First obtain the world with which the plan is associated
w=what('worlds');
disp('Available Worlds for Plan')
disp('-------------------------')
disp(w.mat)
worldname=[];
while isempty(worldname)
    worldname=input('Enter underlying world name: ','s');
end

load(strcat('worlds/',worldname));
%% Display the world. Delete or comment out if you are modifying this code
%% to do something other than allow manual plan definition.
tbw=loadworld(worldname)
[gh]=blocksdraw(tbw,[],gca,'INIT')


% Define a queue of commands to each gripper, 3 parallel action sequences

% INITIALIZE queue to be of length 100, and put end of queue marker in
% 100th position. Simulation will stop after 100 nulls if no plan is
% provided.
commQueues=zeros(3,100);
commQueues(1:3,100)=[-1 -1 -1]';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% SAMPLE PLAN: padded to qLen moves on each gripper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Option 1: Interactive input
planA=input('Enter plan for gripper A: ');
planB=input('Enter plan for gripper B: ');
planC=input('Enter plan for gripper C: ');
qLen=max([length(planA) length(planB) length(planC)])+1;
commQueues(1,1:qLen)=padops(planA,qLen);
commQueues(2,1:qLen)=padops(planB,qLen);
commQueues(3,1:qLen)=padops(planC,qLen);

%%%%% Option 2: Preset input, easier if you want to repeatedly modify the
%%%%% same plan
% qLen=50; 
% commQueues(1,1:qLen)=padops([2 2 2 2 2 2 4 4 4 4 4 4 4 4 4 5 3 3 1 1 1 4 4 4 5 3 3 2 2 2 0],qLen);
% commQueues(2,1:qLen)=padops([2 2 4 4 4 4 4 4 4 4 4 4 4 5 3 3 3 3 3 0 0 0 0 0 0 0 2 2 4 4 4 5 3 3 2 2 2 2 2],qLen);
% commQueues(3,1:qLen)=padops([4 4 4 4 4 4 4 4 0 0 0 0 0 0 0 0 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2 2 2 4 5 3 1 1 4 4 4 5 3 0],qLen);
commQueues(1:3,qLen+1)=[-1 -1 -1]';

%%%%%%%%%%%%%% The plan above was constructed manually. You may want to
%%%%%%%%%%%%%% experiment with a few such plans, (graph paper will help)
%%%%%%%%%%%%%% before deciding how to automate it.

% Save the plan
planname=input('Enter plan name: ','s');
fullplanname=strcat('rawplans/',planname);
save(fullplanname,'worldname','planname','qLen','commQueues');
basicplan(planname);