function [] = kpp1()
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
    lat = 39.7054758;
    lon = -75.0330031;
    
    LSB = 360/(2.^24);
    
    latq = lat/LSB;
    lonq = lon/LSB;
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
    
    switch m
        case 0 
            mso = 752 + Rzero;
        case 1
            mso = mod((4001*Rzero + N(mod(m,2))),3200);
        otherwise
            mso = mod((4001*R(m-1) + N(mod(m,2))),3200);
    end
    
    Ttx = (6000+(250*mso))*1e-6;
    
    
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
    
end
