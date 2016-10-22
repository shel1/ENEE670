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
        cheading = 0;
        pSpace = nan;
        radius = 100;   %default to 100m
        N = 10;         %how many readings to cache for each unique airborne asset
%         pSpace = struct('time',[],'uid',[],'lat',[],'lon',[],'hMSL',[],'vN',[],'vE',[],'vD',[]);    % initialize with it empty
        uidStack = struct('uid',char(java.util.UUID.randomUUID),'count',2);  %initialize with nobody in the personal space

        
    end
    
    methods
        function [obj] = Skydiver()
            % no need to keep the UIDs the same for now, just an identifier
            obj.uid = char(java.util.UUID.randomUUID);
            % initialize with some canned data for testing
            

        end
        function [obj] = proximityCheck(obj)
        %%
%             x = obj.cLat;
%             y = obj.cLon;
%             z = obj.cAlt;

            % law of haversines
            % https://en.wikipedia.org/wiki/Haversine_formula
            hav = @(x) sin(x/2)^2;
            hav2 = @(x) (1-cos(x))/2; %returns same result
            earthRadius = 6371e3; % mean radius of earth (meters)
            
            % sample points
            phi1    =  39.707145;
            lambda1 = -75.036073;
            alt1    = 100; %meters
            phi2    =  39.706640;
            lambda2 = -75.033629;
            alt2    = 300;
            
            % convert degrees to radians
            phi1    = phi1*(pi/180);
            lambda1 = lambda1*(pi/180);
            phi2    = phi2*(pi/180);
            lambda2 = lambda2*(pi/180);
            
            deltaPhi = phi2-phi1;
            deltaLambda = lambda2-lambda1;
            deltaAlt    = alt2-alt1;
            %compute distance
            % ignore the curve from here forward.
            xyDistance= 2*earthRadius*asin(sqrt(hav(deltaPhi)+cos(phi1)*cos(phi2)*hav(deltaLambda)));
            %relative slant range/proximity
            altDist = sqrt((xyDistance.^2)+(deltaAlt.^2));
            
            
           %%
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

