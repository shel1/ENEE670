classdef Skydiver
    %SKYDIVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        uid = nan;
        cTime = 0;
        cLat = 0;
        cLon = 0;
        cAlt = 0;
        cvN  = 0;
        cvE  = 0;
        cvD  = 0;
    end
    
    methods
        function [obj] = Skydiver(obj, varargin)
            obj.uid = char(java.util.UUID.randomUUID);
            
        end
        function [obj] = proximityCheck(obj)
        %%
%             x = obj.cLat;
%             y = obj.cLon;
%             z = obj.cAlt;
            x = 0;
            y = x;
            z = x;
            % start with one additional asset
            uniqueAssets = 2;
            
            x2 = 4;
            y2 = 3;
            z2 = 3.0;
            
            
            dx = x - x2;
            dy = y - y2;
            dz = z - z2;
                       
            % distance in single plane
            dxy = sqrt((dx.^2)+(dy.^2));
            
            % 3 D range
            range = sqrt((dxy.^2)+(dz.^2));
            
        end
    end
    
end

