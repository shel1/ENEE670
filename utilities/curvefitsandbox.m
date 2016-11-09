
%%
load('flysightdata\LoganData.mat');
jump = 257;
[ T, lat, lon, hMSL, velN, velE, velD, hAcc, vAcc, sAcc ] = extractFlysightData( LoganData, jump );
dat = [ lat, lon, hMSL, velN, velE, velD, hAcc, vAcc, sAcc ];

output = (diff(dat(:,4:6),1,1))/h;
%estimated acceleration
vNp= SMA(output(:,1),25);
vEp= SMA(output(:,2),25);
vDp= SMA(output(:,3),25);

velPrime = [vNp vEp vDp];
exitIdx = getExit(LoganData(jump));

close all;

[r,c] = size(lat);

startIdx    = 800; %probably good to limit this to when its determined to be airborne
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
h=.2;
i=startIdx+(x*inc);
edIdx = i+(sz);
edVIdx = i+szvalid;
latSamp = lat(i:edIdx);
lonSamp = lon(i:edIdx);
altSamp = hMSL(i:edIdx);

vNSamp = velN(i:edIdx);
vESamp = velE(i:edIdx);
vDSamp = velD(i:edIdx);
latVSamp = lat(i:edVIdx);
lonVSamp = lon(i:edVIdx);
altVSamp = hMSL(i:edVIdx);
vNVSamp = velN(i:edVIdx);
vEVSamp = velE(i:edVIdx);
vDVSamp = velD(i:edVIdx);

%%
fig=figure;
hold all;
grid on;
% view(3);
latFitData = [];
lonFitData = [];
altFitData = [];
latFitDataraw = [];
lonFitDataraw = [];
altFitDataraw = [];
k = 25;
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

%         [latFr, latGOF(count)] = posFit(SMA(latSamp,k),latVSamp);
%         [lonFr, lonGOF(count)] = posFit(SMA(lonSamp,k),lonVSamp);
%         [altFr, altGOF(count)] = posFit(SMA(altSamp,k),altVSamp);        
    %     frStack = [frStack frTmp];
    %     gofStack = [gofStack gofTmp];
    %     outStack = [outStack outTmp'];

        %plot stuff

        xvals = linspace(0,60,100);


        latFitData = [latFitData; feval(latFr,xvals)];
        lonFitData = [lonFitData; feval(lonFr,xvals)];
        altFitData = [altFitData; feval(altFr,xvals)];
        
%         clf;
% 
%         plot(xvals,latFitData,'r+');
%         hold all;
%         plot(xvals(1:80),latVSamp(1:80),'bo');
% 
%         grid on;
        
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

figure;plot3(lonFitData,latFitData,altFitData,'r+');
hold all;
plot3(lon,lat,hMSL,'b.');

grid on;
% ok, got thru fitting everything, now need to set up the visual.
% do a fit, and extrapolate a few points in front, plot the real data

