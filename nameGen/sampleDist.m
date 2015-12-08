function sampleItem=sampleDist(freqVec)
% Return a sample given a discrete distribution in the form of a vector of
% relative frequencies (need not be normalized)

numBins=length(freqVec);
cdfVec(1)=freqVec(1);

% Compute the cumulative distribution function, cdf
for k=2:numBins
    cdfVec(k)=cdfVec(k-1)+freqVec(k);
end

totalMass=cdfVec(numBins);

cdfSampleY=totalMass*rand;
sampleItem=find(cdfVec>cdfSampleY,1);
