function flysightPlot( varargin )
%FLYSIGHTPLOT Plot flysight output data
% The preferred input is a vector of records created from fimport.m
%%
% FLYSIGHTPLOT(LoganData(x:y),ptype);
% options for ptype
% 1 formatted PVT plot, position and velocity
% 2 3 D position only
% 3 Location Derivative
% 4 Down velocity with exit finder
% 5 broken
%

    dat = varargin{1};
    [r c] = size(dat);
    
    
    p = varargin{2};
    eT = 1.5;
    eTHigh = 10;    
    switch p
        case 1
            %% plot quiver3
            f=figure;
            hold all;
            grid on;
            for i = 1:c
                [exitIdx,landIdx] = getExit(dat(i));
                q3(dat(i).jump.lon(exitIdx:landIdx),dat(i).jump.lat(exitIdx:landIdx),dat(i).jump.hMSL(exitIdx:landIdx),dat(i).jump.velE(exitIdx:landIdx),dat(i).jump.velN(exitIdx:landIdx),(-1).*(dat(i).jump.velD(exitIdx:landIdx)));
                title('Position & velocity');
            end
        case 2
            %% plot position only
            
            figure;
            hold all;
            grid on;
                        
            for i = 1:c
                plot3(dat(i).jump.lat,dat(i).jump.lon,dat(i).jump.hMSL);
                title('Position only');
            end
        case 3
            %% plot location derivative
            figure;
            hold all;
            for i = 1:c
                plot(dat(i).locDerivative,'.');
                title({'LLA Derivative';'\DeltaT=.002s'});
            end
        case 4
            %% plot down velocity with exit finder
            w = 10;
            b = (1/w)*ones(1,w);
            a = 1;

            f = figure;
            ax1 = subplot(211);
            ax2 = subplot(212);
            hold all;
            for i = 1:c
                d = dat(i).jump.velD;
                exitIdx = getExit(dat(i));
                plot(ax2,d(exitIdx:end),'+');
                hold all;
%                 title({'Down Velocity'});
            end            
        case 5
            %coregistered exits
            %TODO add exitfinder
            f2 = figure;
            hold all;
            grid on;
            for i = 1:c
                velDprime = diff(dat(i).jump.velD);
                exitIdx = find((velDprime>eT)&(velDprime<eTHigh),1);
                plot3(dat(i).lat(exitIdx:end),dat(i).lon(exitIdx:end),dat(i).hMSL(exitIdx:end));
                title('Position only');
            end            
        otherwise
            msg = ['I''m a failure because: ' why];
            error(msg);
    end
end

