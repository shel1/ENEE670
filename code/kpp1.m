
%kpp1 Capacity simulation for HawkEye

    %m is the current UAT frame 
    %R(m-1) is a randomly generated number that will be put into N(0) and N(1)
    
    %N(0) = 12 LSBs of latitude
    %N(1) = 12 LSBs of longitude
    
    
    %% Set up the first frame. Assume center of CK airport
    
    %reference value for testing
    %39.7054758 / -75.0330031 %http://www.airnav.com/airport/17n
    
    % no charge number, so we're ignoring the full globe, assume quadrant 1
    % for latitude and quadrant 4 for longitude, per Table 2-14 DO-282B
    
    
%%
    close all;
    clear all;
    lat = 39.7054758;
    lon = -75.0330031;
    radius = 10; %nautical miles
    N   =50; %number of trials
    sj = 600; %simultaneous messages
    LSB = 360/(2.^24);
    
    m2nm = 1852; %conversion
    
    % determine deltaLat and deltaLon for range to origin checking
    [deltaLat,deltaLon] = findLocDelta(lat,lon,radius);
    %initialize empty structs for random lat and random lon results
    rLatN0=struct();
    rLonN1=struct();
    %initialize the counters for validated values, and the trash can
    goodValCollector = 0;
    trashCollector = 0;
    idx =0;
    skel.val=[];
    skel.qval=[];
    skel.bin=[];
    skel.b2d=[];
    
    latSt= skel;
    lonSt=skel;

    [lat1s,lon1s, ~, ~]= posGenWrapper(lat,lon,deltaLat,deltaLon,0,0,radius);
    lat1 = lat1s.val;
    lon1 = lon1s.val;
    load('pStruct.mat');
    % dont forget to put pStruct somewhere

%%
   
    R = []; % random number stack
    % so if the USA wasn't the center of the universe,we would care about
    % the rest here, and deal with the negative DD/DMS conversions 

%%    

    % generate first N(0) and N(1)
    ct = 0;
    trash = 0;
    NVals = repmat(skel,N,sj);
    
    rData = zeros(2,N,sj);
    vStructskel.dr=zeros(1,sj);
    vStructskel.zeroidx=zeros(1,sj);
    vStructMSO = repmat(vStructskel,1,600,600);
    
    
    [latSttmp,lonSttmp, trash, ct]= posGenWrapper(lat1,lon1,deltaLat,deltaLon,ct,trash,radius);
    latSt = latSttmp;
    lonSt = lonSttmp;
    trashCollector = trashCollector + trash;
    goodValCollector = goodValCollector + ct;

    NVals(1:2) = [latSt;lonSt]';
    
    axesm(pStruct);
   distUnit = earthRadius('nm');   
 [latc, lonc] = scircle1(lat,lon,radius,[],distUnit);
 plotm(lat,lon,'o'); %plot the origin
 plotm(latc,lonc,'g'); % plot the range
 plotm(latSt.val,lonSt.val,'r.');
%  plotm([rLatN0.val],[rLonN1.val],'r.'); % plot the values
%  title('2D Location vectors relative to center');
%  hold off;
    
%%
    % deal with the m=0 case
%     Rzero = mod(bin2dec(Nzero),3200); %convert back to an int, take modulus
%     rNOne  = [randi([0,4095],N,1) ]; %12 bytes each 2^12=4096    
%     Rzero = mod(NVals(1,1).b2d,3200);
    %set up the loop to make unique samples for 'simultaneous messages'
%     R = Rzero; %prime the loop
    % loop for simultaneous messages
    MSO = zeros(N,sj);
    Ttx = zeros(N,sj);
    
    rStream = RandStream('mlfg6331_64');
    RandStream.setGlobalStream(rStream);
    
    for s = 1:sj
        % N number of trials for each sj
%         rng('shuffle');%seed the random number generator
        sjtic(s) = tic;
        if s == 103
            sj;
        end
%         rStream.Substream = s;
        for m = 0:N
            m1 = m+1;
            mtic(m1) = tic;
            switch m
                case 0 
%                     fprintf('m = %g\n',m);
                    [latSttmp,lonSttmp, trash, ct]= posGenWrapper(lat,lon,deltaLat,deltaLon,ct,trash,radius);
                    rData(1,m1,s)= latSttmp.val;
                    rData(2,m1,s)= lonSttmp.val;
%                     plotm(latSttmp.val,lonSttmp.val,'r.');
                    newRow = [latSttmp;lonSttmp]';
                    NVals(1:2,s) = newRow;
                    Rzero = mod(NVals(1,1).b2d,3200);
                    R(1) = Rzero;
                    R(m1,s) = 752 + R(1);

                case 1
                    term1 = 4001*R(1);
                    tidx = mod(m1,2)+1;
                    [latSttmp,lonSttmp, trash, ct]= posGenWrapper(lat,lon,deltaLat,deltaLon,ct,trash,radius);
                    rData(1,m1,s)= latSttmp.val;
                    rData(2,m1,s)= lonSttmp.val;
%                     plotm(latSttmp.val,lonSttmp.val,'r.');
                    newRow = [latSttmp;lonSttmp]';
                    NVals(3:4,s) = newRow;
                    term2 = NVals(tidx,s).b2d;
%                     fprintf('m = %g\n',m);
%                     fprintf('Term1: %g\n',term1);
%                     fprintf('Term2: %g\n',term2);
                    R(m1,s) = mod(term1+term2,3200);
                otherwise
                    % anything other than m=0 or m=1
                    term1 = 4001*R(m1-1);
                    [latSttmp,lonSttmp, trash, ct]= posGenWrapper(lat,lon,deltaLat,deltaLon,ct,trash,radius);
                    rData(1,m1,s)= latSttmp.val;
                    rData(2,m1,s)= lonSttmp.val;                    
%                     plotm(latSttmp.val,lonSttmp.val,'r.');
                    newRow = [latSttmp;lonSttmp]';
                    NVals(m*2+1:(m*2)+2,s) = newRow;
                    tidx = mod(m,2)+1;
                    term2 = NVals(tidx,s).b2d;
%                     term1 = 4001*randi([0,4095],1,1);
%                     term2 = randi([0,4095],1,1);
%                     fprintf('m = %g\n',m);
%                     fprintf('Term1: %g\n',term1);
%                     fprintf('Term2: %g\n',term2);                    
                    R(m1,s) = mod(term1+term2,3200);
            end
                        
    %         R(0+1)=rpn(0,R,rNOne);
    %         R(1+1)=rpn(1,R,rNOne);
%             R(m+1,s)      =   rpn(m,lastR,NOne);
            MSO(m1,s)    =   752+R(m+1,s);
            Ttx(m1,s)    =   (6000+ (250*MSO(m+1,s)))*1e-6;%convert to µs
            mtime(m1)=toc(mtic(m1));
        end
    sjtime(s)= toc(sjtic(s));
    fprintf('S = %g\n',s);
    fprintf('SJ time: %6.3f\n',sjtime(s));
%     vStructMSO(:,:,s) = validateCapacity(MSO(2:end,:));
    end
%%    
       distUnit = earthRadius('nm');   
 [latc, lonc] = scircle1(lat,lon,radius,[],distUnit);
 
    
    for x=1:50
        clf;
        sqlat= squeeze(rData(1,x,1:600));
        sqlon= squeeze(rData(2,x,1:600));
        axesm(pStruct);
        
        plotm(lat,lon,'o'); %plot the origin
        plotm(latc,lonc,'g');
        plotm(sqlat,sqlon,'.');
        pause(.1);
    end
%     vStructTtx = validateCapacity(Ttx(2:end,:));

        %%
% figure;
% plot(MSO,'+');

% 
    
    %     figure;
%     subplot(411);
%     plot(MSO,'+');
%     subplot(412);
%     plot(Ttx,'o');
%     subplot(413);
%     plot(term1,'.');
%     subplot(414);
%     plot(term2,'.');
%     figure;
%     plot(Ttx,'+');
    
    
    
