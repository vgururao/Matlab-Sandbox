% made up words

consonants={'a','b','c','d','f','g','h','j','k','l','m','n','p','q','r','s','t','v','w','x','y','z'};
vowels={'a','e','i','o','u'};
s={};
for k=1:10
    s{k}='';
    for j=1:3
        s{k}=strcat(s{k},consonants{ceil(21*rand)});
        s{k}=strcat(s{k},vowels{ceil(5*rand)});
    end
end

s