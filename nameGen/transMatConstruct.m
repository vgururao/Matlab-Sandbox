% Construct a transition matrix from a sample text

fid=fopen('sample.txt');
A=fread(fid);
C=char(A);
C=lower(C);
sampleLength=length(C);

Tmat=zeros(26,26);

for k=2:sampleLength
    curChar=C(k);
    lastChar=C(k-1);
    if (curChar>='a')&(curChar<='z')&(lastChar>='a')&(lastChar<='z')
        Tmat(lastChar-96,curChar-96)=Tmat(lastChar-96,curChar-96)+1;
        % treat as ascii code num...
    end
end
        
