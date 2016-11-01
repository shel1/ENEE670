
%load data
%%

load('flysightdata\LoganData.mat');
% % fimport(LoganData)
% 
[ T, lat, lon, hMSL, velN, velE, velD, hAcc, vAcc, sAcc ] = extractFlysightData( LoganData, 30 );
% 
% flysightPlot(LoganData(30),1);
% 
% %%
% latV = lat(2600:2800)
% lonV = lon(2600:2800)
% altV = hMSL(2600:2800)

%%
close all;

[r,c] = size(lat);

startIdx    = 2600; %probably good to limit this to when its determined to be airborne
XStart      = startIdx; %prime the plot
inc         = 25;
sz          = 50;   %sample size to fit
szvalid     = 150;
edIdx       = startIdx + sz;
edVIdx      = startIdx + szvalid; % no X values here, so can't fit earlier in time, only forward.
count = 0;                                    %which is all we care about anyway
frStack =[];
gofStack=[];
outStack=[];

xvals=XStart:edIdx;
xVvals = XStart:edVIdx;
fig=figure;

for i = startIdx:inc:r
    count = count+1;
    latSamp = lat(i:edIdx);
    latVSamp = lat(i:edVIdx);
    lonSamp = lon(i:edIdx);
    lonVSamp = lon(i:edVIdx);
    altSamp = hMSL(i:edIdx);
    altVSamp = hMSL(i:edVIdx);
    [frTmp, gofTmp, outTmp] = llafit(latSamp,latVSamp,lonSamp,lonVSamp,altSamp,altVSamp);
    frStack = [frStack frTmp];
    gofStack = [gofStack gofTmp];
    outStack = [outStack outTmp'];

    xFit = frTmp{1};
    yFit = frTmp{2};
    hFit = frTmp{3};
    %plot stuff
%     plot(xvals,yFit(lonSamp),'r-');
%     hold all;
%     plot(xVvals,lonVSamp,'b-');
    plot(xvals,feval(yFit,latSamp),'ro');
    hold all;
    plot(xVvals,latVSamp,'b-');
    hold off;
    
    edIdx = i+inc+sz;
    edVIdx = i++inc+szvalid;
    xvals=i+inc:edIdx;
    xVvals=i+inc:edVIdx;
end
% ok, got thru fitting everything, now need to set up the visual.
% do a fit, and extrapolate a few points in front, plot the real data

