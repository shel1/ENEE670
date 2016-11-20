function [ d, theta ] = geoDiff(lat,lon,alt,lat2,lon2,alt2)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


            % law of haversines
            % https://en.wikipedia.org/wiki/Haversine_formula
            hav = @(x) sin(x/2)^2;
            
            earthRadius = 6371e3; % mean radius of earth (meters)
            
%             % sample points
%             phi1    =  39.707145;
%             lambda1 = -75.036073;
%             alt1    = 100; %meters
%             phi2    =  39.706640;
%             lambda2 = -75.033629;
%             alt2    = 300;
            % assign inputs
            phi1    =  lat;
            lambda1 = lon;
            alt1    = alt;
            phi2    =  lat2;
            lambda2 = lon2;
%             alt2    = alt2;           %already assigned
            
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
            d = sqrt((xyDistance.^2)+(deltaAlt.^2));
            theta = atan2(xyDistance, deltaAlt);
            ang = (180/pi)*theta;

end



