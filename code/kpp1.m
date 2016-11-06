
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
    lat = 39.7054758;
    lon = -75.0330031;
    radius = 10; %nautical miles
    N   =100; %number of trials
    sj = 600; %simultaneous messages
    LSB = 360/(2.^24);
    
    m2nm = 1852; %conversion
    [deltaLat,deltaLon] = findLocDelta(lat,lon,radius);
    rLatN0=struct;
    rLonN1=struct;
    count = 0;
    trash = 0;
    while count < 500
        [tempLat, tempLon] = posGenerator(lat,lon,deltaLat,deltaLon);
        locdiff = geoDiff2d(lat,lon,tempLat,tempLon);
        if locdiff > (radius*m2nm)
            %throw away and try again
            trash = trash+1;
        else
            count = count+1;
            rLatN0(count).val = tempLat;
            rLonN1(count).val = tempLon;

            templatq = tempLat/LSB;
            templonq = tempLon/LSB;

            rLatN0(count).qval = templatq;
            rLonN1(count).qval =  templonq;

            templatbin = dec2bin(abs(templatq));
            templonbin = dec2bin(abs(templonq));

            templatbinshort = templatbin(end-11:end);
            templonbinshort = templonbin(end-11:end);
            rLatN0(count).bin = templatbinshort; 
            rLonN1(count).bin = templonbinshort;
            rLatN0(count).b2d = bin2dec(templatbinshort);
            rLonN1(count).b2d = bin2dec(templonbinshort);
    
        end
    end
    % dont forget to put pStruct somewhere
    NVals = [rLatN0;rLonN1]';
 axesm(pStruct);
 distUnit = earthRadius('nm');   
 [latc, lonc] = scircle1(lat,lon,radius,[],distUnit);
 plotm(lat,lon,'o'); %plot the origin
 plotm(latc,lonc,'g'); % plot the range
 plotm([rLatN0.val],[rLonN1.val],'r.'); % plot the values
 title('Random Locations');
 hold off;

%%
    m=0; % start with first frame, always;
    R = 0; % random number stack
    % so if the USA wasn't the center of the universe,we would care about
    % the rest here, and deal with the negative DD/DMS conversions 

%%    
    % deal with the m=0 case
%     Rzero = mod(bin2dec(Nzero),3200); %convert back to an int, take modulus
%     rNOne  = [randi([0,4095],N,1) ]; %12 bytes each 2^12=4096    
    Rzero = mod(NVals(1,1).b2d,3200);
    %set up the loop to make unique samples for 'simultaneous messages'
    R = Rzero; %prime the loop
    for s = 1:sj
        % N number of trials for each sj
        for m = 0:N
  
            switch m
                case 0 
%                     fprintf('m = %g\n',m);
                    R(m+1,s) = 752 + R(1);
%                     num
%                     term1 = 0;
%                     term2 = 0;
                case 1
                    term1 = 4001*R(1);
                    tidx = mod(m,2)+1;
                    term2 = NVals(m+1,tidx).b2d;
%                     fprintf('m = %g\n',m);
%                     fprintf('Term1: %g\n',term1);
%                     fprintf('Term2: %g\n',term2);
                    R(m+1,s) = mod(term1+term2,3200);
                otherwise
                    % anything other than m=0 or m=1
                    term1 = 4001*R(m-1+1);
                    tidx = mod(m,2)+1;
                    term2 = NVals(m+1,tidx).b2d;
%                     term1 = 4001*randi([0,4095],1,1);
%                     term2 = randi([0,4095],1,1);
%                     fprintf('m = %g\n',m);
%                     fprintf('Term1: %g\n',term1);
%                     fprintf('Term2: %g\n',term2);                    
                    R(m+1,s) = mod(term1+term2,3200);
            end
                        
    %         R(0+1)=rpn(0,R,rNOne);
    %         R(1+1)=rpn(1,R,rNOne);
%             R(m+1,s)      =   rpn(m,lastR,NOne);
            MSO(m+1,s)    =   752+R(m+1,s);
            Ttx(m+1,s)    =   (6000+ (250*MSO(m+1,s)))*1e-6;%convert to µs
            
        end
    end
    vStruct = validateCapacity(MSO(3:end,:,:)); %take out the first 2 entries
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
    
    
    
    %%
%     lat = R(n);
%     long = R(n+1);
%     N = [lat, long];
%     %N(0) = latitude; 
%     %N(1) = longitude; 
% 
%     %when m = 0, R(0) = N(0) mod3200
%     %when m>=1, R(m) = {4001 R(m-1) + N(m mod 2)} mod 3200
%     %modulated start times for transmission simulation 
% 
%     MSO = 752 + N; %when airborne
%     msecs = 6000 + (250 * MSO); 
    

