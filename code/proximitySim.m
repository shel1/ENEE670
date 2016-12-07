function [ outStruct ] = proximitySim(in, j1,j2 )
%PROXIMITYSIM Summary of this function goes here
%   [ outStruct ] = proximitySim(in, j1,j2 )
%   in is a struct of output from fimport.m
%   j1 and j2 are the indicies to compare during the simulation
%   The simulation co registers the aircraft exits and plays them back in
%   increments of the recorded data. The output struct contains 
%       fD = estimated future distance
%       gD = calculated geometric difference
%       lm = link margin at each processed time step
%       ebno = Eb/No at each processed time step
%       alarmstruct = PVT data and relative distance when a proximity alarm
%       is thrown
%       pf = plot images are saved in this struct
%           use imshow(outStruct.pf(x).cdata) to display
% 
    % condition input data
  
    
    plotflag=1;
    frameflag = 0;
    safeRadius = 100; %meters
    h = 0.20; %flysight sample rate
    t = seconds(h);
    %location of the airfield (and Rx antenna)
    olat = 39.7054758;
    olon = -75.0330031;
    oalt = 49; %meters
    %convert degrees to meters for our AOI
    [m2deglat,m2deglon] = findLocDelta(olat,olon,(1/1852));
    mcv = [m2deglat m2deglon 1];
    % filter constants
    alpha = 0.6;
    beta = 0.02;
    numh = 32; %length of extrapolation (change from 16 to 32)
    
    
    %reset the flux capacitor
    tClock = seconds(0);
    
    %define the alarm output struct
    alarmskel.v1 = [];
    alarmskel.v2 = [];
    alarmskel.dist = [];
    alarmskel.actdist = [];
    alarmskel.j1 = [];
    alarmskel.j2 = [];  
    alarmskel.t = [];
    alarmstruct = alarmskel;
    
    %define the plot output struct
    plotskel.cdata=[];
    plotskel.colormap=[];
   
    fprintf('Starting %g\n',j1);
    
    %find the exit and landing points during each jump
    [exitIdx1,lndIdx1] = getExit(in(j1));
    [exitIdx2,lndIdx2] = getExit(in(j2));
    exErr = 200;
    try
        if j1 ~= j2 %add a little validation, in case a loop is used outside of the function
            data1 = in(j1);
            data2 = in(j2);

            if plotflag
                
                figure(100);
                plot(data1.jump.hMSL(exitIdx1-200:end));
                hold;
                plot(data2.jump.hMSL(exitIdx2-200:end));
                plot(lndIdx1-exitIdx1+100,data1.jump.hMSL(lndIdx1),'o');
                plot(lndIdx2-exitIdx2+100,data2.jump.hMSL(lndIdx2),'v');
                
                hold off;
            end
            fprintf('Starting %g\n',j2);                

            % snip out the struct for each dataset

            [vv1] = extractFlysightData( data1);
            [vv2] = extractFlysightData( data2);

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

            %determine how much to preallocate
%             v1len = height(vv1);
%             v2len = height(vv2);
            
            len1 = (lndIdx1-exitIdx1+exErr);
            len2 = (lndIdx2-exitIdx2+exErr);
            minlen = max(len1,len2);

            gD = zeros(1,minlen);
            fD = zeros(1,minlen);
            Lm = zeros(minlen,3);
            ebno = zeros(minlen,3);
%             R = zeros(minlen,2);
%             MSO = zeros(minlen,2);
            if frameflag
                plotframes = repmat(plotskel,1,minlen);
            end

            xkj1stack = zeros(minlen,3);
            vkj1stack = zeros(minlen,3);
            rkj1stack = zeros(minlen,3);
            xkj2stack = zeros(minlen,3);
            vkj2stack = zeros(minlen,3);
            rkj2stack = zeros(minlen,3);

            % stop at the shortest duration
            for i = 1:minlen
                %we're counting simulation time, different from the length of the
                %dataset

                tClock = tClock+t;
%                 idx1 = exitIdx1 + i;
%                 idx2 = exitIdx2 + i;
                idx1 = lndIdx1-minlen + i;
                idx2 = lndIdx2-minlen + i;

                %snip out one row of PV values
                try
                    vv1t = table2array(vv1(idx1,2:7));
                    vv2t = table2array(vv2(idx2,2:7));
                catch vv1err
                    getReport(vv1err)
                end

                % set up inputs for the next alphabeta fit
                xk1 = vv1t(:,1:3); %pos data
                vk1 = vv1t(:,4:6); %vel data
                xm = table2array(vv1(idx1-1,2:4)); %previous value

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
%                 xk2conv = posconv(xk2(1),xk2(2));
                [xkj2t,vkj2t,rkj2t] = abfilter(xk2,vk2,xm2,h,numh,mcv,alpha,beta );

                xkj2stack(i,:) = xkj2t;
                vkj2stack(i,:) = vkj2t;
                rkj2stack(i,:) = rkj2t;        

                [latconv(1),lonconv(1)] = posconv(xk1(1),xk1(2));
                [latconv(2),lonconv(2)] = posconv(xk2(1),xk2(2));
%                 tPos(:,:,i) = [latconv;lonconv];
%                 if i == 1
%                     [MSO(i,1),R(i,1),Ttx(i,1)] = msoGenerator(tPos(:,1,i),i-1,[]);
%                     [MSO(i,2),R(i,2),Ttx(i,2)] = msoGenerator(tPos(:,2,i),i-1,[]);
%                 else
%                     [MSO(i,1),R(i,1),Ttx(i,1)] = msoGenerator(tPos(:,1,i),i-1,R(i,1));
%                     [MSO(i,2),R(i,2),Ttx(i,2)] = msoGenerator(tPos(:,2,i),i-1,R(i,2));
%                     
%                 end
                %find current actual range difference
                gD(i) = geoDiff(vv1.lat(idx1),vv1.lon(idx1),vv1.hMSL(idx1),vv2.lat(idx2),vv2.lon(idx2),vv2.hMSL(idx2));
                %evaluate the link budget for the location and for that point in
                %time relative to the other jumper
                [~,Lm(i,1),ebno(i,1)] = LinkBudget(vv1.lat(idx1),vv1.lon(idx1),vv1.hMSL(idx1),vv2.lat(idx2),vv2.lon(idx2),vv2.hMSL(idx2));
                [~,Lm(i,2),ebno(i,2)] = LinkBudget(vv1.lat(idx1),vv1.lon(idx1),vv1.hMSL(idx1),olat,olon,oalt);
                [~,Lm(i,3),ebno(i,3)] = LinkBudget(vv2.lat(idx2),vv2.lon(idx2),vv2.hMSL(idx2),olat,olon,oalt);
                fD(i)= geoDiff(xkj1t(1),xkj1t(2),xkj1t(3),xkj2t(1),xkj2t(2),xkj2t(3)); 

               if plotflag
                   % first plot the history 
                   plot3(ax1,vv1.lat(idx1),vv1.lon(idx1),vv1.hMSL(idx1),'m-.+',vv2.lat(idx2),vv2.lon(idx2),vv2.hMSL(idx2),'m-.+');
                   % then plot the future
                    if i > 2
                        plot3(ax1,xkj1t(1),xkj1t(2),xkj1t(3),'k-.+');
                        plot3(ax1,xkj2t(1),xkj2t(2),xkj2t(3),'b-.o');
                    end
                    if exist('texHandle1','var')
                        delete(texHandle1);
                        delete(texHandle2);
                        delete(texHandle3);
                    end
                    timestr = ['$$ \Delta T = '         sprintf('%3.2f',seconds(tClock))  '\textrm{ s}$$'];
                    rangestr = ['$$ \Delta R = '        sprintf('%5.1f',gD(i))            '\textrm{ m}$$'];
                    lmStr = ['$$ \frac{E_b}{N_o} = '    sprintf('%4.2f',Lm(i))            '\textrm{ dB}$$'];
                    texHandle1 = text(ax2,1,4,timestr,'Interpreter','latex');
                    texHandle2 = text(ax2,1,3,rangestr,'Interpreter','latex');
                    texHandle3 = text(ax2,1,2,lmStr, 'Interpreter','latex');
                    if frameflag
                        plotframes(i) = getframe(fig);
                    end
               end
                
               %heres the safe zone check. Only need one check. If this
               %were real, we would also need to track all the assets that
               %could possibly enter the safe zone in the near future, and
               %be ready to evaluate the distances to each of them
               if fD(i)<safeRadius
                   las = length(alarmstruct) + 1;
                   alarmstruct(las).t = seconds(tClock);
                   alarmstruct(las).v1 = vv1t;
                   alarmstruct(las).v2 = vv2t;
                   alarmstruct(las).dist = fD(i);
                   alarmstruct(las).actdist = gD(i);
                   alarmstruct(las).j1 = j1;
                   alarmstruct(las).j2 = j2;
                   fprintf('Time: %6.3f\n',seconds(tClock));
                   fprintf('Proximity Alert %2.3f\n',gD(i));
                   fprintf('Alt: %4.3f\n',vv1.hMSL(idx1));
               end
            end
            if plotflag
                xvals = h:h:seconds(tClock);
                figure;plot(xvals,rkj1stack(:,1),'.');
                title('Jumper 1 X Axis Residuals');
                hold on;
                xlabel('Time (s)');
                ylabel('Residual Difference (m)');
                figure;plot(xvals,rkj1stack(:,2),'.');
                hold on;
                title('Jumper 1 Y Axis Residuals');
                xlabel('Time (s)');
                ylabel('Residual Difference (m)');                
                figure;plot(xvals,rkj1stack(:,3),'.');
                hold on;
                xlabel('Time (s)');
                ylabel('Residual Difference (m)');                
                title('Jumper 1 Z Axis Residuals');
                figure;plot(xvals,rkj2stack(:,1),'.');
                hold on;
                xlabel('Time (s)');
                ylabel('Residual Difference (m)');                
                title('Jumper 2 X Axis Residuals');
                figure;plot(xvals,rkj2stack(:,2),'.');
                hold on;
                xlabel('Time (s)');
                ylabel('Residual Difference (m)');                
                title('Jumper 2 Y Axis Residuals');
                figure;plot(xvals,rkj2stack(:,3),'.');
                hold on;
                xlabel('Time (s)');
                ylabel('Residual Difference (m)');                
                title('Jumper 2 Z Axis Residuals');
                
                
                % fun with floating point math
                [~,jj]=find((abs(xvals-[alarmstruct.t]')<0.001));
                figure;plot(xvals,gD,'b');
                hold;
                plot(xvals,fD,'m');
                plot(xvals(jj),fD(jj),'ro');
                legend('Actual Distance',[num2str(numh) '*h Future Estimated Distance'],'Proximity Alarm Condition');
                ylabel('Distance (m)');
                xlabel('Time (s)');
                title('Relative Distance');
                grid on;
                hold off;
                figure;
                semilogy(xvals,Lm(:,1),'r');
                hold;
                semilogy(xvals,Lm(:,2),'m');
                semilogy(xvals,Lm(:,3),'b');
                grid on;
                leg=legend('$$\textrm{Link Margin A-A}$$',...
                    '$$\textrm{Link Margin A1-G}$$',...
                    '$$\textrm{Link Margin A2-G}$$');
                leg.Interpreter = 'latex';
                leg.Location = 'Southeast';
                xlabel('Time (s)');
                ylabel('dB');
                title('Link Margin');
                hold off;
            end
        else
            fprintf('J1 and J2 = %g\n',j1);
        end
    catch errtmp
        %end of the plot can run long, so heres a way to catch the Ctrl-C 
        %and still dump the buffers and exit clean
        fprintf('Uh oh, something went sideways\n');
        why;
        getReport(errtmp)
    end
    fprintf('Time to dump the buffers\nand get out.\n');
    outStruct.fD = fD;
    outStruct.gD = gD;
    outStruct.lm = Lm;
    outStruct.ebno = ebno;
%     outStruct.MSO = MSO;
%     outStruct.Ttx = Ttx;
%     outStruct.R = R;
%     outStruct.tpos = tPos;
    outStruct.alarmstruct = alarmstruct;
    if frameflag
        outStruct.pf = plotframes;
    end
end