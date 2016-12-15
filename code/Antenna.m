%% Antenna.m
% Bonus Investigation
close all 

%%Units
MHz = 1e6;
f1 = 978*MHz;
f2 = 979*MHz;
%%
% Specify Angles
thetaEl = [0 30 45 80 90];
%%
% Make antenna elements
elem = phased.ShortDipoleAntennaElement('FrequencyRange',[f1 f2]);
elem2 = phased.CrossedDipoleAntennaElement('FrequencyRange', [f1 f2]);
%% 
% Plots
figure;
elem.patternAzimuth(f1,thetaEl);
title('Dipole Az cut');
figure;
elem2.patternAzimuth(f1,thetaEl);
title('Crossed Dipole Az cut');
figure;
elem.patternElevation(f1,thetaEl);
title('Dipole El cut');
figure;
elem2.patternElevation(f1,thetaEl);
title('Crossed Dipole El cut');
figure;
elem.pattern(978*MHz);
figure;
elem2.pattern(978*MHz);


