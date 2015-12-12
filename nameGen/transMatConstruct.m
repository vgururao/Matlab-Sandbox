% Construct a transition matrix from a sample text

fid=fopen('sample.txt');
A=fread(fid);
C=char(A);
C=lower(C);
sampleLength=length(C);

Tmat=zeros(27,27);

for k=2:sampleLength
    curChar=C(k);
    lastChar=C(k-1);
    if (curChar>='a')&&(curChar<='z')&&(lastChar>='a')&&(lastChar<='z')
        Tmat(lastChar-96,curChar-96)=Tmat(lastChar-96,curChar-96)+1;
        % treat as ascii code num...
    elseif (curChar>='a')&&(curChar<='z')
        Tmat(27,curChar-96)=Tmat(27,curChar-96)+1;
        % Word beginning, treat all whitespace the same
    elseif (lastChar>='a')&&(lastChar<='z') 
        Tmat(lastChar-96,27)=Tmat(lastChar-96,27)+1;
        % Word ending, treat all whitespace the same
    else
        % Do nothing... stub in case punctuation is of interest
    end
end
        
