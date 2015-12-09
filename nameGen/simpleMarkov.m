% Markov chain generator

% consonants={'b','c','d','f','g','h','j','k','l','m','n','p','q','r','s','t','v','w','x','y','z'};
% vowels={'a','e','i','o','u'};
fullAlph={'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};

% Define the transition probability matrix
transMat=rand(26,26);
for k=1:26
    transMat(k,:)=transMat(k,:)/sum(transMat(k,:));
end

s={};

for k=1:10
    s{k}='';
    lastInd=ceil(26*rand);
    for j=1:6        
        newInd=sampleDist(transMat(lastInd,:));
        s{k}=strcat(s{k},fullAlph{lastInd});
        lastInd=newInd;
    end
end

disp(s);
