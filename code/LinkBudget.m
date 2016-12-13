function [ z, Lm, EbNo ] = LinkBudget(varargin)
%LINKBUDGET Summary of this function goes here
%   [ outStruct ] = linkBudget(varargin)
% Link Budget 
%   Function accepts range values as input and calculate the
%   the link margin with free space path loss, antenna plorization loss,
%   and elevation angle loss.
%   z = Free Space Path Loss
%   Lm = Link Margin

switch nargin 
    case 6
        lat = varargin{1};
        lon = varargin{2};
        alt = varargin{3};
        lat2 = varargin{4};
        lon2 = varargin{5};
        alt2 = varargin{6};
        [R, theta] = geoDiff(lat,lon,alt,lat2,lon2,alt2);
    case 2
        theta = varargin{1};
        R = varargin{2};
    otherwise
        fprintf('something went sideways\n');
        why;
end
    
%% Units

MHz = 1e6;
c = 299792458; % speed of light
freq = 978*MHz; % frequency
lambda =c/freq; % Wavelength

% fb = 10^-6; % bit rate 
PTx = 20; % Transmit power at the Antenna in dBm
AG_tx = 10*log10(abs(sin((pi/2)-theta).^3)); %allowance for angle relative to gnd rx antenna
pl = 3; %Polarization loss
z = 20*log10((4*pi*R/lambda)); % Free space loss calculation
% AG_rx = 10; % Recieve Antenna gain
Pr = PTx + AG_tx + pl - z; % Recieved power
Rs = -93; % Receive Antenna sensitivity for 90% message success rate in dBm
Lm = Pr - Rs; % Link Margin
EbNo = 0;

end
