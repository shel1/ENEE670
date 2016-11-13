% function [ output_args ] = proximitySim( in )
%PROXIMITYSIM Summary of this function goes here
%   Detailed explanation goes here
    %%
    % condition input data
    close all;
    clear all;
    if ~exist('LoganData','var');
        load('LoganData.mat');
    end
    in = LoganData;
    data1 = in(44);
    data2 = in(46);
    safeRadius = 150; %meters
    Fs = 0.20; %flysight sample rate
    t = seconds(Fs);
    sz = 15; % length of curve fit
    samp = 50; % length of fit sample
    tClock = seconds(0);
    
    % get the exit indices from each dataset
    exitIdx1 = getExit(data1);
    
    exitIdx2 = getExit(data2);
    
    % snip out the struct for each dataset
    [ T1, lat1, lon1, alt1, velN1, velE1, velD1, hAcc1, vAcc1, sAcc1 ] = extractFlysightData( data1);
    [ T2, lat2, lon2, alt2, velN2, velE2, velD2, hAcc2, vAcc2, sAcc2 ] = extractFlysightData( data2);
    
    v1 = [lat1 lon1 alt1]; % jumper 1
    v2 = [lat2 lon2 alt2]; % jumper 2
    % set up the verification plot
    fig = figure;
    ax1 = axes('Parent',fig,'Position',...
        [0.05 0.11 0.9 0.815]); % plot the data here
    grid on;
    hold(ax1);
    ax2 = axes('Parent',fig, 'Position',...
        [0.7 0.175 0.177 0.255],'NextPlot','replace'); % plot the info here
    ax2.XLim = [0 4];
    ax2.YLim = [0 4];
    axis off; % turn off the axis lines
    
    % iterate for as long as the shortest dataset
    len = min(size(v1,1),size(v2,1));
    % pre allocate 
    v1fitBuffer = zeros(samp,3);
    v2fitBuffer = zeros(samp,3);
    lat1fd = zeros(1,50);
    lon1fd = zeros(1,50);
    alt1fd = zeros(1,50);
    lat2fd = zeros(1,50);
    lon2fd = zeros(1,50);
    alt2fd = zeros(1,50);    
    gD = zeros(1,len);
    fD = zeros(1,len);
    Lm = zeros(1,len);
    ebno = zeros(1,len);
    
    
    for i = 1:len
        %we're counting simulation time, different from the length of the
        %dataset
        tClock = tClock+t;
        
        idx1 = exitIdx1 + i;
        idx2 = exitIdx2 + i;
        %find range difference
        gD(i) = geoDiff(lat1(idx1),lon1(idx1),alt1(idx1),lat2(idx2),lon2(idx2),alt2(idx2));
        %evaluate the link budget for the location and for that point in
        %time relative to the other jumper
        [~,Lm(i),ebno(i)] = LinkBudget(lat1(idx1),lon1(idx1),alt1(idx1),lat2(idx2),lon2(idx2),alt2(idx2));
        
        buffStart1 = max(exitIdx1,(idx1-samp)); %deal with i < sz
        buffStart2 = max(exitIdx2,(idx2-samp)); %deal with i < sz
        v1fitBuffer = v1((buffStart1:idx1),:);
        v1valBuffer = v1((buffStart1:idx1),:);
        v2valBuffer = v2((buffStart2:idx2),:);
        
        v2fitBuffer = v2((buffStart2:idx2),:);
        
        %don't fit until the buffer is full
        validBuffer = (length(v1fitBuffer)>50);
        if validBuffer
            [lat1Func , ~] = posFit(v1fitBuffer(:,1),v1valBuffer(:,1));
            [lon1Func , ~] = posFit(v1fitBuffer(:,2),v1valBuffer(:,2));
            [alt1Func , ~] = posFit(v1fitBuffer(:,3),v1valBuffer(:,3));

            xvals = linspace(samp+1,samp+sz,10);

            lat1fd = feval(lat1Func,xvals);
            lon1fd = feval(lon1Func,xvals);
            alt1fd = feval(alt1Func,xvals);

            [lat2Func , ~] = posFit(v2fitBuffer(:,1),v2valBuffer(:,1));
            [lon2Func , ~] = posFit(v2fitBuffer(:,2),v2valBuffer(:,2));
            [alt2Func , ~] = posFit(v2fitBuffer(:,3),v2valBuffer(:,3));        

            lat2fd = feval(lat2Func,xvals);
            lon2fd = feval(lon2Func,xvals);
            alt2fd = feval(alt2Func,xvals);
        else
            fprintf('Buffer isn''t full yet\n');
        end
        
        
       % first plot the history 
       plot3(ax1,lat1(idx1),lon1(idx1),alt1(idx1),'ro',lat2(idx2),lon2(idx2),alt2(idx2),'b+');
       % then plot the future
       if validBuffer
        plot3(ax1,lat1fd,lon1fd,alt1fd,'g-.',lat2fd,lon2fd,alt2fd,'m-.');
       end
       
%        %debug
%        figure(100);
%        plot3(lat1(idx1),lon1(idx1),alt1(idx1),'ro');%,lat2(idx2),lon2(idx2),alt2(idx2),'b+');
%         hold;
%        % then plot the future
%        plot3(lat1fd,lon1fd,alt1fd,'g-.');%,lat2fd,lon2fd,alt2fd,'g-.');

       

       if exist('texHandle','var')
            delete(texHandle);
        end
        timestr = ['$$ \Delta T = '         sprintf('%3.2f',seconds(tClock))  '\textrm{ s}$$'];
        rangestr = ['$$ \Delta R = '        sprintf('%5.1f',gD(i))            '\textrm{ m}$$'];
        lmStr = ['$$ \frac{E_b}{N_o} = '    sprintf('%4.2f',Lm(i))            '\textrm{ dB}$$'];
        texHandle(1) = text(ax2,1,4,timestr,'Interpreter','latex');
        texHandle(2) = text(ax2,1,3,rangestr,'Interpreter','latex');
        texHandle(3) = text(ax2,1,2,lmStr, 'Interpreter','latex');
       
        %gD vs fit distance
        
        if validBuffer
            fD(i)= geoDiff(lat1fd(end),lon1fd(end),alt1fd(end),lat2fd(end),lon2fd(end),alt2fd(end));
            fprintf('Current Distance: %6.2f\n',gD(i));
            fprintf('Fitted Distance:  %6.2f\n',fD(i));
           if fD(i)<safeRadius

               fprintf('Time: %6.3f\n',seconds(tClock));
               fprintf('Proximity Alert %2.3f\n',gD(i));
               fprintf('Alt: %4.3f\n',alt1(idx1));
           end
        end
%         pause(.001);       

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


