% proximity tester

% Jumps 1-6 are in Florida
% Jumps 7-29 are in the carolina's
% Jumps 30+ are in NJ.

dFile = [srcroot filesep 'flysightdata' filesep 'LoganData.mat'];
load(dFile);
clf;
flysightPlot(LoganData(41:50),2);