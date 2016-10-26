function [ output_args ] = proximitySim( in )
%PROXIMITYSIM Summary of this function goes here
%   Detailed explanation goes here
    %%
    % condition input data
    
    data1 = in(1);
    data2 = in(4);
    safeRadius = 150; %meters
    Fs = 0.20; %flysight sample rate
    t = seconds(Fs);
    tClock = seconds(0);
    exitIdx1 = getExit(data1)
    
    exitIdx2 = getExit(data2)
    
    %update for exit point
%     data1= data1(exitIdx1:end);
%     data2 =data2(exitIdx2:end);
    
    lat1 = data1.lat(exitIdx1:end);
    lon1 = data1.lon(exitIdx1:end);
    alt1 = data1.hMSL(exitIdx1:end);
    lat2 = data2.lat(exitIdx2:end);
    lon2 = data2.lon(exitIdx2:end);
    alt2 = data2.hMSL(exitIdx2:end);
    
    v1 = [lat1 lon1 alt1];
    v2 = [lat2 lon2 alt2];
    figure;
    hold all;
    grid on;
    len = min(size(v1,1),size(v2,1))
    for i = 1:len
        tClock = tClock+t;
        
       gD(i) = geoDiff(lat1(i),lon1(i),alt1(i),lat2(i),lon2(i),alt2(i));
        plot3(lat1(i),lon1(i),alt1(i),'ro',lat2(i),lon2(i),alt2(i),'b+');
        pause(.01);       
       if gD(i)<safeRadius
           
           fprintf('Time: %6.3f\n',seconds(tClock));
           fprintf('Proximity Alert %2.3f\n',gD(i));
           fprintf('Alt: %4.3f\n',alt1(i));
       end
    end
%     figure;
%     hold all;
%     grid on;
%     for i = 1:len
%         plot3(lat1(i),lon1(i),alt1(i),'ro',lat2(i),lon2(i),alt2(i),'b+');
%         pause(.01);
%     end
    
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
    s2 = RandStream('mlfg6331_64','Seed',2);
    for i = 1:600
        s(i) = Skydiver();
    end
    q = [];
    c = [];
    
    for i = 1:600
        q = [q rand(stream)];
    end
    q'
    c = [q ;last]';
    c
%     reset(stream);
end

