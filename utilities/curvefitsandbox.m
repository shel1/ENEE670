
%%
<<<<<<< HEAD
load('LoganData.mat');
jump = 257;
[ T, lat, lon, hMSL, velN, velE, velD, hAcc, vAcc, sAcc ] = extractFlysightData( LoganData, jump );
dat = [ lat, lon, hMSL, velN, velE, velD, hAcc, vAcc, sAcc ];

h=.2;

output = (diff(dat(:,4:6),1,1))/h;
%estimated acceleration
vNp= SMA(output(:,1),25);
vEp= SMA(output(:,2),25);
vDp= SMA(output(:,3),25);

velPrime = [vNp vEp vDp];
exitIdx = getExit(LoganData(jump));

=======
% load('LoganData.mat');
jump = 257;
[ T, lat, lon, hMSL, velN, velE, velD, hAcc, vAcc, sAcc ] = extractFlysightData( LoganData, jump );
dat = [ lat, lon, hMSL, velN, velE, velD, hAcc, vAcc, sAcc ];
h=.2;
output = (diff(dat(:,4:6),1,1))/h;
%estimated acceleration
vNp= SMA(output(:,1),25);
vEp= SMA(output(:,2),25);
vDp= SMA(output(:,3),25);

velPrime = [vNp vEp vDp];
exitIdx = getExit(LoganData(jump));

>>>>>>> proximitySim007
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
<<<<<<< HEAD
x=1;

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
=======
% x=1;
% 
% i=startIdx+(x*inc);

>>>>>>> proximitySim007

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
        
        edIdx = i+(sz);
        edVIdx = i+szvalid;


        vNSamp = velN(i:edIdx);
        vESamp = velE(i:edIdx);
        vDSamp = velD(i:edIdx);

%         vNVSamp = velN(i:edVIdx);
%         vEVSamp = velE(i:edVIdx);
%         vDVSamp = velD(i:edVIdx);


        latSamp = lat(i:edIdx);
        latVSamp = lat(i:edVIdx);
        lonSamp = lon(i:edIdx);
        lonVSamp = lon(i:edVIdx);
        altSamp = hMSL(i:edIdx);
        altVSamp = hMSL(i:edVIdx);

        [latFr, latGOF(count)] = posFit(latSamp,latVSamp);
        [lonFr, lonGOF(count)] = posFit(lonSamp,lonVSamp);
        [altFr, altGOF(count)] = posFit(altSamp,altVSamp);

<<<<<<< HEAD
%         [latFr, latGOF(count)] = posFit(SMA(latSamp,k),latVSamp);
%         [lonFr, lonGOF(count)] = posFit(SMA(lonSamp,k),lonVSamp);
%         [altFr, altGOF(count)] = posFit(SMA(altSamp,k),altVSamp);        
    %     frStack = [frStack frTmp];
    %     gofStack = [gofStack gofTmp];
    %     outStack = [outStack outTmp'];

        %plot stuff

        xvals = linspace(0,60,100);


=======
        % fits are done against the range [1 50]
        % use [51 65] to extrapolate
        xvals = linspace(51,65,20);

>>>>>>> proximitySim007
        latFitData = [latFitData; feval(latFr,xvals)];
        lonFitData = [lonFitData; feval(lonFr,xvals)];
        altFitData = [altFitData; feval(altFr,xvals)];
        
<<<<<<< HEAD
=======
        % comparison plot
        
        plot3(lonSamp,latSamp,altSamp,'bo');
        hold all;
        plot3(lonFitData,latFitData,altFitData,'r.');
        
>>>>>>> proximitySim007
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
<<<<<<< HEAD

figure;plot3(lonFitData,latFitData,altFitData,'r+');
hold all;
plot3(lon,lat,hMSL,'b.');

grid on;
=======
for ct=1:length(lon)
    figure;plot3(lonFitData,latFitData,altFitData,'r+');
    hold all;
    plot3(lon,lat,hMSL,'b.');
    grid on;
    fprintf('Time: %6.3f\n',ct*.2);
    pause(1);
end

>>>>>>> proximitySim007
% ok, got thru fitting everything, now need to set up the visual.
% do a fit, and extrapolate a few points in front, plot the real data

