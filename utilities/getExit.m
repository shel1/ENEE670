function [ exitIdx ] = getExit( dat )
%GETEXIT return the exit index from input vector
%   Best estimate based on the delta velocity signature

    eT = 5;
    h = .2;

    
     
    ground = find(dat.jump.hMSL<1500,1); %zero out before 1000m
    dat.jump.velD(1:ground) = 0;
%                 d2(1:ground) = 0;
    % get the derivative before zeroing out stuff
    velDprime = diff(dat.jump.velD)/h;
    %moving average
    velDprime = SMA(velDprime,25);
%     hA = data.hAcc;
    % zero out entries with poor accuracy
%     meanhAcc = mean(hA);
%     datahAcc = hA - meanhAcc;
%     data.velD(datahAcc>4) = 0;
%     data.hMSL(datahAcc>4) = 0;


%     velDprime(velDprime<1) = 0; %noise threshold
%     velDprime(velDprime>10) = 0;
    exitIdx = find((velDprime>eT),1);                    
end

