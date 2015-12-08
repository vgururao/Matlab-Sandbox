% Test the distribution sampling function

% Make up a symmetric test distribution

freqVec=[1 1 1 1 2 2 2 3 3 4 3 3 2 2 2 1 1 1 1]/4;
outcomeVec=[1:length(freqVec)];
measVec=zeros(length(freqVec),1);
% Plot it

figure(1);
clf;
plot(outcomeVec,freqVec,'b*-');

hold on;

for k=1:10000
    samplePt=sampleDist(freqVec);
    measVec(samplePt)=measVec(samplePt)+1;
end

measVec=measVec/max(measVec);
plot(outcomeVec,measVec,'r*-');