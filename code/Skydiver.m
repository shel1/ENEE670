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
        function [obj] = Skydiver(obj,varargin)
            obj.uid = java.util.UUID.randomUUID;
            
        end
    end
    
end

