function [ exitIdx ] = getExit( data )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    eT = 1.5;
    d = data.velD;
    
    ground = find(data.hMSL<1500,1); %zero out before 1000m
    data.velD(1:ground) = 0;
%                 d2(1:ground) = 0;
    % get the derivative before zeroing out stuff
    velDprime = diff(data.velD);
%     d2altprime = diff(data.hMSL);
    hA = data.hAcc;
    % zero out entries with poor accuracy
    meanhAcc = mean(hA);
    datahAcc = hA - meanhAcc;
    data.velD(datahAcc>4) = 0;
    data.hMSL(datahAcc>4) = 0;
%                 fdata = filter(b,a,d);

    velDprime(velDprime<1) = 0; %noise threshold
    velDprime(velDprime>4) = 0;
    
    
    exitIdx = find((velDprime>eT),1);                    

end

