function [ SNR ] = InitialKPP2( range, power, AGTx)
 %% Since Francis has this part all but covered, i will leave it alone for now 
f = 978e6; % Frequency

%PTx = 20;   

PTx = power;  % Transmit power

%AGTx = 0;

AGTx = 0; % Antenna gain for transmission

%Free Space loss

FSL1 = 10*log10(((0.3.^2)/(4*pi*(range).^2))); 

PL  = 3; % Polirization loss

AGRx = 10; % Receiver antenna gain

%Pr   =-79.08;

Pr = PTx + AGTx + FSL1 + PL; % Power Received

Rs   = -90; % Receiver sensitivity

SNR = Pr - Rs % Link margin

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ x,y,z] = latlon_xyz( latitude, longitude, height_AGL)
% latlon_xyz converts the jumpers postion from lat lon to the x,y,z plane
%Summary of this function goes here

% This converts lat long to x,y,z cordinates (3-D)
%   Detailed explanation goes here
    Radius = 6371e3 + height_AGL; % Radius of the earth in meters
    %% Reference :http://astro.uchicago.edu/cosmus/tech/latlong.html
    LAT = latitude * pi/180;
    LON = longitude * pi/180;
    x = -Radius * cos(LAT) * cos(LON);
    y =  Radius * sin(LAT) ;
    z =  Radius * cos(LAT) * sin(LON);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function [ delta_d ] = latlongtoxyz_diff( lat1, lon1, alt1, lat2, lon2, alt2 )
%latlongto xyz converts the jumpers position from the
% lat lon to x,y,z cordinates. 
%   Detailed explanation goes here
% This function will collect position data from KPP1 and calculate the 
% range of each skydiver 
% in order to find the range for each skyidver (delta_d)
    [x1,y1,z1] = latlon_xyz( lat1, lon1, alt1);
    [x2,y2,z2] = latlon_xyz( lat2, lon2, alt2);
    delta_d = sqrt( (x1-x2).^2+(y1-y2).^2+(z1-z2).^2);




