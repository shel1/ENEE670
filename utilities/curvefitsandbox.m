
%load data
%%

% load('flysightdata\LoganData.mat');
% % fimport(LoganData)
% 
[ T, lat, lon, hMSL, velN, velE, velD, hAcc, vAcc, sAcc ] = extractFlysightData( LoganData, 44 );
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

startIdx    = 1; %probably good to limit this to when its determined to be airborne
XStart      = startIdx; %prime the plot
inc         = 25;
sz          = 50;   %sample size to fit
szvalid     = 80;
edIdx       = startIdx + sz;
% edVIdx      = startIdx + szvalid; % no X values here, so can't fit earlier in time, only forward.
count = 0;                                    %which is all we care about anyway
frStack =[];
gofStack=[];
outStack=[];

xvals=XStart:edIdx;
%%
x=1;

i=startIdx+(x*inc);
edIdx = i+(sz);
edVIdx = i+szvalid;
latSamp = lat(i:edIdx);
lonSamp = lon(i:edIdx);
altSamp = hMSL(i:edIdx);
latVSamp = lat(i:edVIdx);
lonVSamp = lon(i:edVIdx);
altVSamp = hMSL(i:edVIdx);
%%
fig=figure;
hold all;
grid on;
view(3);

for i = startIdx:inc:r-inc
    %%
    
        count = count+1;
%         if count == 311
%             disp();
%         end
        
        latSamp = lat(i:edIdx);
        latVSamp = lat(i:edVIdx);
        lonSamp = lon(i:edIdx);
        lonVSamp = lon(i:edVIdx);
        altSamp = hMSL(i:edIdx);
        altVSamp = hMSL(i:edVIdx);
    %     [frTmp, gofTmp, outTmp] = llafit(latSamp,latVSamp,lonSamp,lonVSamp,altSamp,altVSamp);


        [latFr, latGOF(count)] = posFit(latSamp,latVSamp);
        [lonFr, lonGOF(count)] = posFit(lonSamp,lonVSamp);
        [altFr, altGOF(count)] = posFit(altSamp,altVSamp);

    %     frStack = [frStack frTmp];
    %     gofStack = [gofStack gofTmp];
    %     outStack = [outStack outTmp'];

        %plot stuff
    %     plot(xvals,yFit(lonSamp),'r-');
    %     hold all;
    %     plot(xVvals,lonVSamp,'b-');

        xvals = linspace(0,60,100);
        latFitData = feval(latFr,xvals);
        lonFitData = feval(lonFr,xvals);
        altFitData = feval(altFr,xvals);

        plot3(lonFitData(1:50),latFitData(1:50),altFitData(1:50),'+',lonVSamp,latVSamp,altVSamp,'.');

        plot3(lonFitData(51:80),latFitData(51:80),altFitData(51:80),'bo');
        plot3(lonFitData(81:end),latFitData(81:end),altFitData(81:end),'ko');
%         camtarget([lonFitData(80),latFitData(80),altFitData(80)]);
%         campos([lonFitData(50),latFitData(50),altFitData(50)]);


        edIdx = i+inc+sz;
        edVIdx = i+inc+szvalid;
        if edIdx > r
            edIdx = r;
        end
        if edVIdx > r
            edVIdx = r;
        end
%         xvals=i+inc:edIdx;
%         xVvals=i+inc:edVIdx;
%     pause(.5);
    
end
% ok, got thru fitting everything, now need to set up the visual.
% do a fit, and extrapolate a few points in front, plot the real data

