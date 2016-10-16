%%
close all 
clear all
clc
%%Units

%Frequency 
F = 978;
%Distance
D = 10756;
%Pt = Transmission Power;
Pt = 20;
% Transmission antenna_gain;
AG_Tx = 0;
%Path loss  
Pl= 3;
%Free Space Loss/ Spreading loss  
L1 = 10*log10(((0.3.^2)/(4*pi*(D).^2)))
% Receiver antenna_gain
AG_Rx= 10;
% Power Received
Pr = Pt + AG_Tx + L1 + Pl;
% Antenna Sensitivity
Rs = -93;
%datarate
R = 1.041667*1.0e6;
%bandwith
B= 2*R;
%Bit Error Rate
BER = 3e-5;
theta = 0:0.1:pi;
plot (theta, 10*log10(sin(theta).^3));
%Signal to Noise Ratio 
SNR = Pr - Rs
Eb_No = SNR + 10*log10(B/R);


fprintf('Link Margin  = %6.2f\n', SNR);

xlabel('Eb/No');
ylabel('BER');
grid on;
[x,y] = ginput(1);
fprintf('Graph value = (%6.3f,  %6.3f)\n' ,x, y);
histogram (Pr, nbins)

%Noise power 
%%N = -228.6 + 10* log 10(
