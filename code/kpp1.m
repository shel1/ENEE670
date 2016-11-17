
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

    load('pStruct.mat');
    % dont forget to put pStruct somewhere

%%
   
    R = []; % random number stack
    % so if the USA wasn't the center of the universe,we would care about
    % the rest here, and deal with the negative DD/DMS conversions 

%%    

    % generate skeletons to save time
    ct = 0;
    trash = 0;
    skel50 = repmat(skel,N,1);
    skel100 = repmat(skel,2*N,1);
    NVals = repmat(skel100,1,sj);
    
    rData = zeros(2,N*2,sj);
    vStructskel.dr=zeros(1,sj);
    vStructskel.zeroidx=zeros(1,sj);
    vStructMSO = repmat(vStructskel,1,600,600);
    
    MSO = zeros(N,sj);
    Ttx = zeros(N,sj);
    
    rStream = RandStream('mlfg6331_64');
    RandStream.setGlobalStream(rStream);
    rowStack = [skel100];%stacking up the lat/lon values
    for s = 1:sj
        % N number of trials for each sj

        sjtic(s) = tic;
        if s == 103
            sj;
        end
%         rStream.Substream = s;
        for m = 0:N
            m1 = m+1;
            mtic(m1) = tic;

            [latSttmp,lonSttmp, trash, ct]= posGenWrapper(lat,lon,deltaLat,deltaLon,ct,trash,radius);            
            
            % do all the math in advance
            rData(1,m1,s)= latSttmp.val;
            rData(2,m1,s)= lonSttmp.val;
            
            newRow = [latSttmp;lonSttmp];
            rowStack = [newRow; rowStack(1:end-2)];

            % reset the term index and zero out the math, in case of a
            % hiccup
            tidx = mod(m1,2)+1;
            term1 = 0;
            term2 = 0;
            switch m
                case 0 
                    Rzero = mod(newRow(1).b2d,3200);
                    R(1,s) = Rzero;
                    R(m1,s) = 752 + R(1,s);
                case 1
                    term1 = 4001*R(m1-1,s);
                    term2 = newRow(tidx).b2d;
                    R(m1,s) = mod(term1+term2,3200);
                otherwise
                    % anything other than m=0 or m=1
                    term1 = 4001*R(m1-1);
                    term2 = newRow(tidx).b2d;
                    R(m1,s) = mod(term1+term2,3200);
            end
                        
            MSO(m1,s)    =   752+R(m1,s);
            Ttx(m1,s)    =   (6000+ (250*MSO(m1,s)))*1e-6;%convert to µs
            mtime(m1)=toc(mtic(m1));
        end
%         % add to map
%         plotm(rData(1,:,s),rData(2,:,s),'r.');
%         title('Points for single trial');
        
        % add the current stack of N trials to the output dataset
        NVals = [rowStack NVals(:,(1:end-1))];
        sjtime(s)= toc(sjtic(s));
        fprintf('S = %g\n',s);
        fprintf('SJ time: %6.3f\n',sjtime(s));

    end
    % generate the validation data
    vStructMSO = [validateCapacity(MSO)]';
    figure;
    histogram([vStructMSO.dupeCount]);
    hold all;
    title({'Distrbution of duplicate MSOs';'across 600 simultaneous messages. N=50'});
    %   axesm(pStruct);
%   distUnit = earthRadius('nm');   
%  [latc, lonc] = scircle1(lat,lon,radius,[],distUnit);
%  plotm(lat,lon,'o'); %plot the origin
%  plotm(latc,lonc,'g'); % plot the range
%  rd1 = squeeze(rData(:,1,:))';
%  plotm(rd1,'r.');
         