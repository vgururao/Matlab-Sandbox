
% Modeling attritive combat with Lanchester's law
clear all
close all
N=2;
X=[500 500]';
Y=[500 500]';
k=1;
att=0.02;
redmove=X;
bluemove=Y;
while ((norm(X(:,k)>0))&(norm(Y(:,k)>0))) 
   k=k+1;
   % Basic update
   X(1:N,k)=floor(X(1:N,k-1)-att*eye(N)*Y(1:N,k-1));
   Y(1:N,k)=floor(Y(1:N,k-1)-att*eye(N)*X(1:N,k-1));
   
   % Set to zero if negative
   X(1:N,k)=0.5*(X(1:N,k)+abs(X(1:N,k)));
   Y(1:N,k)=0.5*(Y(1:N,k)+abs(Y(1:N,k)));
   bluestate=[X(1:N,k);Y(1:N,k)];
   redstate=[Y(1:N,k);X(1:N,k)];
   if mod(k,24)==0
      % Call Blue and Red to make their moves
      % They return redeployment vectors
      disp(['Before Move State: ' num2str(redstate')])
      
      bluemove=bluegeneral(bluestate);
      redmove=redgeneral(redstate);
      
      
      X(:,k)=bluemove;
      Y(:,k)=redmove;
      disp(['Aftermove state: ' num2str([bluemove' redmove'])]);
      disp(char(12));
   end      
end
disp('Initial Conditions')
disp('------------------')
disp(['Blue Force Levels: ' num2str(X(:,1)')])
disp(['Red Force Levels: ' num2str(Y(:,1)')])
disp(char(12))

disp('Final Conditions')
disp('------------------')
disp(['Blue Force Levels: ' num2str(X(:,k)')])
disp(['Red Force Levels: ' num2str(Y(:,k)')])
disp(char(12))


timevec=linspace(1,k,k);

figure(2)
%set(gcf,'Position',[500,1,520,800])
clf
hold on
subplot(2,2,1)
plot(timevec,X(1,1:k),'b');
legend('Blue Left Flank')
xlabel('time (hours)')
ylabel('force size')

subplot(2,2,2)
plot(timevec,X(2,1:k),'b');
legend('Blue Right Flank')
xlabel('time (hours)')
ylabel('force size')



%plot(timevec,X(3,1:k),'b-.');

subplot(2,2,3)
plot(timevec,Y(1,1:k),'r');
legend('Red Left Flank')
xlabel('time (hours)')
ylabel('force size')



subplot(2,2,4)
plot(timevec,Y(2,1:k),'r');
legend('Red Right Flank')
xlabel('time (hours)')
ylabel('force size')


%plot(timevec,Y(3,1:k),'b-.');


