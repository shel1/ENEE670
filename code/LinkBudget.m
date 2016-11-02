function [ z ] = LinkBudget( r )
% Link Budget 
%   Function accepts range values as input and calculate the
%   Signal-to-Noise or Energy bit per unit noise

f = 978; % frequency
PTx = 20; %Transmit power 
AG_tx = 0; % Transmit Antenna gain  
pl = 3; %Polarization loss
z = 10*log10(0.3.^2./(4*pi()*r.^2)); % Free space loss calculation
AG_rx = 10; % Recieve Antenna gain
Pr = PTx + AG_tx + pl + z; % Recieved power
Rs = -93; % Receive Antenna sensitivity
Lm = Pr - Rs; % Link Margin
EbNo = 10.^(Lm/10)
% EbNo = Lm + 10*log10(bandwidth/rate);

end

