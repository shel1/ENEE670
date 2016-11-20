function [ z ] = LinkBudget(lat,lon,alt,lat2,lon2,alt2)
% Link Budget 
%   Function accepts range values as input and calculate the
%   Signal-to-Noise or Energy bit per unit noise

%% Units
Hz = 1.0;
KHz = 1.0e3;
MHz = 1e6; 

[d, theta] = geoDiff(lat,lon,alt,lat2,lon2,alt2);

c = 299792458; % speed of light
freq = 978*MHz; % frequency
lambda =c/freq; % Wavelength

fb = 10^6; % bit rate 
PTx = 20; % Transmit power at the Antenna in dBm
AG_tx = log10(sin(theta).^3);
%AG_tx = 0; % Transmit Antenna gain  
pl = 3; %Polarization loss
z = 10*log10(lambda/(4*pi()*d.^2)); % Free space loss calculation
AG_rx = 10; % Recieve Antenna gain
Pr = PTx + AG_tx + pl + z; % Recieved power
Rs = -93; % Receive Antenna sensitivity for 90% message success rate in dBm
Lm = Pr - Rs; % Link Margin
EbNo = 10*log10(Lm)

end

