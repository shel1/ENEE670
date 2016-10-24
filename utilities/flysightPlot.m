function [ output_args ] = flysightPlot( varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    data = varargin{1};
    [r c] = size(data);
    
    
    p = varargin{2};
    eT = 1.5;
    eTHigh = 10;    
    switch p
        case 1
            f=figure;
            hold all;
            grid on;
            for i = 1:c
                exitIdx = getExit(data(i));
                q3(data(i).lat(exitIdx:end),data(i).lon(exitIdx:end),data(i).hMSL(exitIdx:end),data(i).velN(exitIdx:end),data(i).velE(exitIdx:end),data(i).velD(exitIdx:end));
                title('Position & velocity');
            end
        case 2
            f2 = figure;
            hold all;
            grid on;
            for i = 1:c
                plot3(data(i).lat,data(i).lon,data(i).hMSL);
                title('Position only');
            end
        case 3
            figure;
            hold all;
            for i = 1:c
                plot(data(i).locDerivative,'.');
                title({'LLA Derivative';'\DeltaT=.002s'});
            end
        case 4
            w = 10;
            b = (1/w)*ones(1,w);
            a = 1;

            f = figure;
            ax1 = subplot(211);
            ax2 = subplot(212);
            hold all;
            for i = 1:c
                d = data(i).velD;
                exitIdx = getExit(data(i));
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
                velDprime = diff(data(i).velD);
                exitIdx = find((velDprime>eT)&(velDprime<eTHigh),1);
                plot3(data(i).lat(exitIdx:end),data(i).lon(exitIdx:end),data(i).hMSL(exitIdx:end));
                title('Position only');
            end            
        otherwise
            msg = ['I''m a failure because: ' why];
            error(msg);
    end
end

