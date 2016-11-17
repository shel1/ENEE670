% function [ output_args ] = proximitySim( in )
%PROXIMITYSIM Summary of this function goes here
%   Detailed explanation goes here
    %%
    % condition input data
    close all;
    clear all;
    if ~exist('LoganData','var')
        load('LoganData.mat');
    end
    % get the exit indices from each dataset
    exit = zeros(1,length(LoganData));
    for x = 1:length(LoganData)
        x
        exittmp = getExit(LoganData(x));
        if isempty(exittmp)
            exittmp = nan;
        end
        exit(x) = exittmp;
    end
    %zero out the bad recordings
    exit(exit==1) = nan;
    in = LoganData;
    data1 = in(44);
    data2 = in(50);
    
    plotflag=0;
    safeRadius = 150; %meters
    h = 0.20; %flysight sample rate
    t = seconds(h);
    %location of the airfield
    olat = 39.7054758;
    olon = -75.0330031;
    %convert degrees to meters for our AOI
    [m2deglat,m2deglon] = findLocDelta(olat,olon,(1/1852));
    mcv = [m2deglat m2deglon 1];
    tClock = seconds(0);
   alarmskel.v1 = [];
   alarmskel.v2 = [];
   alarmskel.dist = [];
   alarmskel.actdist = [];
   alarmskel.j1 = [];
   alarmskel.j2 = [];   
   alarm = alarmskel;
    for j1 = 1:length(in)
        for j2 = 1:length(in)
            data1 = in(j1);
            data2 = in(j2);
            
            exitIdx1 = exit(j1);
            exitIdx2 = exit(j2);
    
            % snip out the struct for each dataset
            [ T1, lat1, lon1, alt1, velN1, velE1, velD1, hAcc1, vAcc1, sAcc1 ] = extractFlysightData( data1);
            [ T2, lat2, lon2, alt2, velN2, velE2, velD2, hAcc2, vAcc2, sAcc2 ] = extractFlysightData( data2);

            [vv1] = extractFlysightData( data1);
            [vv2] = extractFlysightData( data2);
    
    
            v1 = [lat1 lon1 alt1]; % jumper 1
            v2 = [lat2 lon2 alt2]; % jumper 2
    
            % set up the verification plot
            if plotflag

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
            end
    
            % iterate for as long as the shortest dataset
            % spelled out for readability
            len = min(size(v1,1),size(v2,1));
            v1len = length(v1(:,1));
            v2len = length(v2(:,1));
            len1 = v1len-exitIdx1;
            len2 = v2len-exitIdx2;
            minlen = min(len1,len2);

            gD = zeros(1,minlen);
            fD = zeros(1,minlen);
            Lm = zeros(1,minlen);
            ebno = zeros(1,minlen);

            xkj1stack = zeros(minlen,3);
            vkj1stack = zeros(minlen,3);
            rkj1stack = zeros(minlen,3);
            xkj2stack = zeros(minlen,3);
            vkj2stack = zeros(minlen,3);
            rkj2stack = zeros(minlen,3);

            % filter constants
            alpha = 0.6;
            beta = 0.02;

            % stop at the shortest duration
            for i = 1:minlen
                %we're counting simulation time, different from the length of the
                %dataset
                tClock = tClock+t;
                idx1 = exitIdx1 + i;
                idx2 = exitIdx2 + i;
                %snip out one row of PV values
                vv1t = table2array(vv1(idx1,2:7));
                vv2t = table2array(vv2(idx2,2:7));
        
                % set up inputs for the next alphabeta fit
                xk1 = vv1t(:,1:3); %pos data
                vk1 = vv1t(:,4:6); %vel data
                xm = table2array(vv1(idx1-1,2:4)); %previous value
                numh = 16; %length of extrapolation

                %special sauce
                [xkj1t,vkj1t,rkj1t] = abfilter(xk1,vk1,xm,h,numh,mcv,alpha,beta );

                %add everything to the stack
                xkj1stack(i,:) = xkj1t;
                vkj1stack(i,:) = vkj1t;
                rkj1stack(i,:) = rkj1t;

                %rinse, repeat with the 2nd jump
                xk2 = vv2t(:,1:3);
                vk2 = vv2t(:,4:6);
                xm2 = table2array(vv2(idx2-1,2:4));
        
                [xkj2t,vkj2t,rkj2t] = abfilter(xk2,vk2,xm2,h,numh,mcv,alpha,beta );

                xkj2stack(i,:) = xkj2t;
                vkj2stack(i,:) = vkj2t;
                rkj2stack(i,:) = rkj2t;        

                %find current actual range difference
                gD(i) = geoDiff(lat1(idx1),lon1(idx1),alt1(idx1),lat2(idx2),lon2(idx2),alt2(idx2));
                %evaluate the link budget for the location and for that point in
                %time relative to the other jumper
                [~,Lm(i),ebno(i)] = LinkBudget(lat1(idx1),lon1(idx1),alt1(idx1),lat2(idx2),lon2(idx2),alt2(idx2));
               fD(i)= geoDiff(xkj1t(1),xkj1t(2),xkj1t(3),xkj2t(1),xkj2t(2),xkj2t(3)); 
               if plotflag
                   % first plot the history 
                   plot3(ax1,lat1(idx1),lon1(idx1),alt1(idx1),'m-.+',lat2(idx2),lon2(idx2),alt2(idx2),'m-.+');
                   % then plot the future
                    if i > 2
                        plot3(ax1,xkj1t(1),xkj1t(2),xkj1t(3),'k-.+');
                        plot3(ax1,xkj2t(1),xkj2t(2),xkj2t(3),'b-.o');
                    end
                    if exist('texHandle','var')
                        delete(texHandle);
                    end
                    timestr = ['$$ \Delta T = '         sprintf('%3.2f',seconds(tClock))  '\textrm{ s}$$'];
                    rangestr = ['$$ \Delta R = '        sprintf('%5.1f',gD(i))            '\textrm{ m}$$'];
                    lmStr = ['$$ \frac{E_b}{N_o} = '    sprintf('%4.2f',Lm(i))            '\textrm{ dB}$$'];
                    texHandle(1) = text(ax2,1,4,timestr,'Interpreter','latex');
                    texHandle(2) = text(ax2,1,3,rangestr,'Interpreter','latex');
                    texHandle(3) = text(ax2,1,2,lmStr, 'Interpreter','latex');
               end
               if fD(i)<safeRadius
                   alarmstruct.v1 = vv1t;
                   alarmstruct.v2 = vv2t;
                   alarmstruct.dist = fD(i);
                   alarmstruct.actdist = gD(i);
                   alarmstruct.j1 = j1;
                   alarmstruct.j2 = j2;
                   alarm(j1,j2) = alarmstruct;
%                    fprintf('Time: %6.3f\n',seconds(tClock));
%                    fprintf('Proximity Alert %2.3f\n',gD(i));
%                    fprintf('Alt: %4.3f\n',alt1(idx1));
               end

            end
            if plotflag

                figure;plot(rkj1stack(:,1),'.');
                figure;plot(rkj1stack(:,2),'.');
                figure;plot(rkj1stack(:,3),'.');
                figure;plot(rkj2stack(:,1),'.');
                figure;plot(rkj2stack(:,2),'.');
                figure;plot(rkj2stack(:,3),'.');
            end

%             figure;plot(Lm);
%             hold;
%             grid on;
%             plot(ebno);
%             hold off;
        end
    end