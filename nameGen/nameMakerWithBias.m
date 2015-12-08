% made up words

consonants={'a','b','c','d','f','g','h','j','k','l','m','n','p','q','r','s','t','v','w','x','y','z'};
vowels={'a','e','i','o','u'};

% Define relative probabilities of different letters

consonantFreq=ceil(3*rand(21,1));
vowelFreq=ceil(3*rand(5,1));

s={};

for k=1:10
    s{k}='';
    for j=1:3
        s{k}=strcat(s{k},consonants{sampleDist(consonantFreq)});
        s{k}=strcat(s{k},vowels{sampleDist(vowelFreq)});
    end
end

disp(s);