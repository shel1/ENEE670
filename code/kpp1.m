function [output] = kpp1(N,cap)
%kpp1 Capacity simulation for HawkEye

    %m is the current UAT frame 
    %R(m-1) is a randomly generated number that will be put into N(0) and N(1)
    lat = R(n);
    long = R(n+1);
    N = [lat, long];
    %N(0) = latitude; 
    %N(1) = longitude; 

    %when m = 0, R(0) = N(0) mod3200
    %when m>=1, R(m) = {4001 R(m-1) + N(m mod 2)} mod 3200
    %modulated start times for transmission simulation 

    MSO = 752 + N; %when airborne
    msecs = 6000 + (250 * MSO); 
    
end
