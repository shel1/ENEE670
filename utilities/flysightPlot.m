function [ output_args ] = flysightPlot( varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    data = varargin{1};
    [r c] = size(data);
    ft = 3.28084;
    
    p = varargin{2};
    
    switch p
        case 1
            f=figure;
            hold all;
            grid on;

            for i = 1:c
                q3(data(i).lat,data(i).lon,data(i).hMSL,data(i).velN,data(i).velE,data(i).velD);
            end
        case 2
            f2 = figure;
            hold all;
            grid on;

            for i = 1:c
                plot3(data(i).lat,data(i).lon,data(i).hMSL);
            end
        case 3
            figure;
            hold all;
            for i = 1:c
                plot(data(i).locDerivative);
            end
    end
end

