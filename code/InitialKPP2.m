function [ SNR ] = InitialKPP2( height, power, AGTx)
 
f = 978e6; % Frequency

%PTx = 20;   

PTx = power;  % Transmit power

%AGTx = 0;

AGTx = 0; % Antenna gain for transmission

%Free Space loss

FSL1 = 10*log10(((0.3.^2)/(4*pi*(height).^2))); 

PL  = 3; % Polirization loss

AGRx = 10; % Receiver antenna gain

%Pr   =-79.08;

Pr = PTx + AGTx + FSL1 + PL; % Power Received

Rs   = -90; % Receiver sensitivity

SNR = Pr - Rs % Link margin

end

