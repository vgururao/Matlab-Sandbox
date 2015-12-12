% Text to words

fid=fopen('sampleSmall.txt');
A=fread(fid);
C=char(A);
C=lower(C);
sampleLength=length(C);

wordList={};
curWord='';
for k=1:sampleLength
    curChar=C(k);
    if (curChar>='a')&&(curChar<='z')
        curWord=strcat(curWord,curChar);
    else
        if ~isempty(curWord);
            wordList{length(wordList)+1}=curWord;
            disp(curWord);
        end
        curWord=[];
    end
end
            
