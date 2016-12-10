%% Antenna.m
close all 

%%Units
MHz = 1e6;
f1 = 978*MHz;
f2 = 979*MHz;
thetaEl = [0 30 45 80 90];
elem = phased.ShortDipoleAntennaElement('FrequencyRange',[f1 f2]);
elem2 = phased.CrossedDipoleAntennaElement('FrequencyRange', [f1 f2]);
figure;
elem.patternAzimuth(f1,thetaEl);
figure;
elem2.patternAzimuth(f1,thetaEl);
figure;
elem.patternElevation(f1,thetaEl);
figure;
elem2.patternElevation(f1,thetaEl);


