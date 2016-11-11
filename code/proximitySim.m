% function [ output_args ] = proximitySim( in )
%PROXIMITYSIM Summary of this function goes here
%   Detailed explanation goes here
    %%
    % condition input data
    close all;
    in = LoganData;
    data1 = in(44);
    data2 = in(43);
    safeRadius = 150; %meters
    Fs = 0.20; %flysight sample rate
    t = seconds(Fs);
    tClock = seconds(0);
    exitIdx1 = getExit(data1)
    
    exitIdx2 = getExit(data2)
    
    %update for exit point
%     data1= data1(exitIdx1:end);
%     data2 =data2(exitIdx2:end);
    
    [ T1, lat1, lon1, alt1, velN1, velE1, velD1, hAcc1, vAcc1, sAcc1 ] = extractFlysightData( data1);
    [ T2, lat2, lon2, alt2, velN2, velE2, velD2, hAcc2, vAcc2, sAcc2 ] = extractFlysightData( data2);
    
    v1 = [lat1 lon1 alt1];
    v2 = [lat2 lon2 alt2];
    figure;
    hold all;
    grid on;
    len = min(size(v1,1),size(v2,1))
    for i = 1:len
        tClock = tClock+t;
        idx1 = exitIdx1 + i;
        idx2 = exitIdx2 + i;
       gD(i) = geoDiff(lat1(idx1),lon1(idx1),alt1(idx1),lat2(idx2),lon2(idx2),alt2(idx2));
       [~,Lm(i),ebno(i)] = LinkBudget(lat1(idx1),lon1(idx1),alt1(idx1),lat2(idx2),lon2(idx2),alt2(idx2));
        plot3(lat1(idx1),lon1(idx1),alt1(idx1),'ro',lat2(idx2),lon2(idx2),alt2(idx2),'b+');
        pause(.01);       
       if gD(i)<safeRadius
           
           fprintf('Time: %6.3f\n',seconds(tClock));
           fprintf('Proximity Alert %2.3f\n',gD(i));
           fprintf('Alt: %4.3f\n',alt1(idx1));
       end
    end
figure;plot(Lm);
hold;
grid on;
plot(ebno);
hold off;
    
    %     flysightPlot([data1 data2],4);
%     figure;plot(gD);
    %exit threshold velocity
%     eT = 1.5;
%     velDprime1 = diff(data1.velD);
%     velDprime2 = diff(data2.velD);
%     exitIdx1 = find(velDprime1>eT,1);
%     exitIdx2 = find(velDprime2>eT,1);
    
%     figure;
%     plot(data1.velD(exitIdx1:end));
%     hold all;
%     plot(data2.velD(exitIdx2:end));
%     flysightPlot([data1 data2],1);
    
    %%
%     s2 = RandStream('mlfg6331_64','Seed',2);
%     for i = 1:600
%         s(i) = Skydiver();
%     end
%     q = [];
%     c = [];
%     
%     for i = 1:600
%         q = [q rand(stream)];
%     end
%     q'
%     c = [q ;last]';
%     c
% %     reset(stream);


