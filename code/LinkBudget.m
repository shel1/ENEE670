function [ z, Lm, EbNo ] = LinkBudget(varargin)
% Link Budget 
%   Function accepts range values as input and calculate the
%   Signal-to-Noise or Energy bit per unit noise

switch nargin 
    case 6
        lat = varargin{1};
        lon = varargin{2};
        alt = varargin{3};
        lat2 = varargin{4};
        lon2 = varargin{5};
        alt2 = varargin{6};
        [d, theta] = geoDiff(lat,lon,alt,lat2,lon2,alt2);
    case 2
        theta = varargin{1};
        d = varargin{2};
    otherwise
        fprint('something went sideways\n');
        why;
end
    
%% Units
Hz = 1.0;
KHz = 1.0e3;
MHz = 1e6;



c = 299792458; % speed of light
freq = 978*MHz; % frequency
lambda =c/freq; % Wavelength

% fb = 10^6; % bit rate 
PTx = 20; % Transmit power at the Antenna in dBm
AG_tx = log10(abs(sin(theta).^3)); %allowance for angle relative to gnd rx antenna
pl = 3; %Polarization loss
z = 10*log10(abs(lambda/(4*pi*d.^2))); % Free space loss calculation
% AG_rx = 10; % Recieve Antenna gain
Pr = PTx + AG_tx + pl + z; % Recieved power
Rs = -93; % Receive Antenna sensitivity for 90% message success rate in dBm
Lm = Pr - Rs; % Link Margin
EbNo = 10*log10(Lm);

end

