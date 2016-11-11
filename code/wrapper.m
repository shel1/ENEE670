%wrapper
%blank placeholder for now

CurrentTime = [0];
TimeElapsed = [0];
TimeInterval = 1e-6; % TBR based on largest quanta
EndTime = [5]; % TBR whatever the length of the simulation is



for CurrentTime = 0:TimeInterval:EndTime
    disp('do some magic');
    K1Outputs = KPP1Class(CurrentTime,TimeElapsed);
    K2Outputs = KPP2Class(CurrentTime,TimeElapsed);
    K3Outputs = KPP3Class(CurrentTime,TimeElapsed);
    K4Outputs = KPP4Class(CurrentTime,TimeElapsed);
    TimeElapsed = TimeElapsed +TimeInterval;
end

