
% Modeling attritive combat with Lanchester's law
clear all
close all
N=2;
X=[1000 1000]';
Y=[1000 1000]';
k=1;
att=0.02;
clc
disp('Initial Conditions')
disp('------------------')
disp(['Blue Force Levels: ' num2str(X(:,k)')])
disp(['Red Force Levels: ' num2str(Y(:,k)')])
disp(char(12))
battleplot([X(:,k);Y(:,k)]);
disp('Hit any key to start')
disp(char(12))
pause
sound([rand(1,1000) zeros(1,1000) rand(1,1000) zeros(1,1000) rand(1,1000) zeros(1,1000) rand(1,1000) zeros(1,1000) rand(1,1000)])


while ((norm(X(:,k))>0)&&(norm(Y(:,k))>0)) 
   k=k+1;
   % Basic update
   X(1:N,k)=floor(X(1:N,k-1)-att*eye(N)*Y(1:N,k-1));
   Y(1:N,k)=floor(Y(1:N,k-1)-att*eye(N)*X(1:N,k-1));
   
   % Set to zero if negative
   X(1:N,k)=0.5*(X(1:N,k)+abs(X(1:N,k)));
   Y(1:N,k)=0.5*(Y(1:N,k)+abs(Y(1:N,k)));
   
   if mod(k,24)==0
      % Time for some reconfiguration
      
      battleplot([X(:,k);Y(:,k)]);      
      clc
      disp(['DAY: ' num2str((k-mod(k,24))/24)])
      disp('----------')

      disp(['Blue Force Levels: ' num2str(X(:,k)')])
      disp(['Red Force Levels: ' num2str(Y(:,k)')])
      disp(char(12))
      f=1;
      while f==1
         youmove=input('How many to move? (+ve for left to right, -ve for right to left): ');
         if isempty(youmove)
            youmove=0;
         end
         Ytemp=Y(:,k)+[-youmove youmove]';
         if ~(sum(abs(Ytemp)-Ytemp)==0)
            disp('Error: Cannot redeploy more than you have, try again')
            disp(char(12))
            f=1;
         else
            f=0;
         end
      end
      
      % Computer's strategy
      if ((X(1,k)/(Y(1,k)+0.1)<0.5)&&(X(1,k)>0))
         %disp('1')
         X(2,k)=X(2,k)+X(1,k);
         X(1,k)=0;
      elseif (X(1,k)/(Y(1,k)+0.1)>2)
         %disp('2')
         X(2,k)=X(2,k)+floor(X(1,k)/2);
         X(1,k)=ceil(X(1,k)/2);
      elseif ((X(2,k)/(Y(2,k)+0.1)<0.5)&&(X(2,k)>0))
         %disp('3')
         X(1,k)=X(1,k)+X(2,k);
         X(2,k)=0;
      elseif X(2,k)/(Y(2,k)+0.1)>2
         %disp('4')
         X(1,k)=X(1,k)+floor(X(2,k)/2);
         X(2,k)=ceil(X(2,k)/2); 
      end
      Y(:,k)=Ytemp;
      battleplot([X(:,k);Y(:,k)]);
      disp(char(12))
      disp('Blue has also redployed')
      disp(['New Blue Force Levels: ' num2str(X(:,k)')])
      disp(['New Red Force Levels: ' num2str(Y(:,k)')])
      disp(char(12))
      disp('Hit any key to fight another day')
      pause
      clc
      disp('Fighting... Fighting... Fighting...')
      disp(char(12))
      sound([rand(1,1000) zeros(1,1000) rand(1,1000) zeros(1,1000) rand(1,1000) zeros(1,1000) rand(1,1000) zeros(1,1000) rand(1,1000)])     
   end
   
   
 
      
end
clc
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
set(gcf,'Position',[500,1,520,800])
clf
hold on
subplot(4,1,1)
plot(timevec,X(1,1:k),'b');
legend('Blue Left Flank')
ylabel('force size')

subplot(4,1,2)
plot(timevec,X(2,1:k),'b--');
legend('Blue Right Flank')
ylabel('force size')



%plot(timevec,X(3,1:k),'b-.');

subplot(4,1,3)
plot(timevec,Y(1,1:k),'r');
legend('Red Left Flank')
ylabel('force size')



subplot(4,1,4)
plot(timevec,Y(2,1:k),'r--');
legend('Red Right Flank')
xlabel('time (hours)')
ylabel('force size')


%plot(timevec,Y(3,1:k),'b-.');


