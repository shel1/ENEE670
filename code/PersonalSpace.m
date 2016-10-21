classdef PersonalSpace
    %PERSONALSPACE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        parentUID = nan;
        radius = 100;   %default to 100m
        N = 10;         %how many readings to cache for each unique airborne asset
        pSpace = struct('time',[],'uid',[],'lat',[],'lon',[],'hMSL',[],'vN',[],'vE',[],'vD',[]);    % initialize with it empty
        uidStack = struct('uid',char(java.util.UUID.randomUUID),'count',2);  %initialize with nobody in the personal space
    end
    
    methods 
        function [obj] = PersonalSpace(obj,varargin)
            if nargin == 1
                obj.parentUID = varargin;
            else
                % mostly using for testing
                obj.parentUID = char(java.util.UUID.randomUUID);
            end
        end
        
        function [ret] = includes(obj,u)
            % see if the uid matches any of the uid's currently in the
            % stack
            ret = any(strcmp({obj.uidStack.uid},u));
        end
        function [ret] = update(obj)
            % compare known assets against a new location. 
            % delete stale assets
            
        end
        function [ret] = addAsset(obj)
            % add a new skydiver to the personal space
        end
        function [ret] = delAsset(obj)
            % add a new skydiver to the personal space
        end            
                 
    end
    
end

