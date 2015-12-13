function [uniqWordList,uniqFreqs]=wordlist2freq(wordList)
% Convert a raw wordlist with dups to a frequency list with counts

numWords=length(wordList);
uniqWordList={};
uniqFreqs=[];
numUniqWords=0;
for k=1:numWords
    numOccs=strcmp(wordList{k},uniqWordList);
    if sum(numOccs)==0
        % A new word, add it to the dictionary
        numUniqWords=numUniqWords+1;
        uniqWordList{numUniqWords}=wordList{k};
        % ...and append a counter for new word
        uniqFreqs=[uniqFreqs 1];
    elseif sum(numOccs)==1
        uniqFreqs(numOccs)=uniqFreqs(numOccs)+1;
        % Matlab strcmp returns position of matched string in cell array as
        % a vector of 1/0 truth values, so that can be used to update appropriate
        % counter... this may be hard to port to another language
    else
        disp('Error: multiple entries in dictionary for same word')
    end
end


        
        
