
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
    clear all;
    close all;
    lat = 39.7054758;
    lon = -75.0330031;
    Num(1,1) = lat;
    Num(1,2) = 0;
    Num(2,1) = lon;
    Num(2,2) = 1;
    % no need to store the char vector of binary numbers
    
    LSB = 360/(2.^24);
    
    latq = lat/LSB;
    lonq = lon/LSB;
%%
    m=0; % start with first frame, always;
    R = 0; % random number stack
    % so if the USA wasn't the center of the universe,we would care about
    % the rest here, and deal with the negative DD/DMS conversions 
    
    latbinfull = dec2bin(abs(latq)); %quadrant 1
    lonbinfull = dec2bin(abs(lonq)); %quadrant 4
    
    Nzero = latbinfull(end-11:end); %12 LSBs
    None = lonbinfull(end-11:end);  %12 LSBs
    
    % deal with the m=0 case
    Rzero = mod(bin2dec(Nzero),3200); %convert back to an int, take modulus
    
    N   =100; %number of trials
    sj = 600; %simultaneous messages
    
    % starting with integer representation of the 12 LSBs
    % TODO: back out the lat/lon calc that leads to this
    
    rNOne  = [randi([0,4095],N,1) ]; %12 bytes each 2^12=4096
    
%     term1 = [];
%     term2 = [];
     
    %shuffle the deck
    rng('shuffle');
    %set up the loop to make unique samples for 'simultaneous messages'
    for s = 1:sj
        % N number of trials for each sj
        for m = 0:N
            
    %         R(0+1)=rpn(0,R,rNOne);
    %         R(1+1)=rpn(1,R,rNOne);
            R(m+1,s)      =   rpn(m,R,rNOne);
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
    

