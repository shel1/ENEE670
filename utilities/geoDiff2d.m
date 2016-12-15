function [ d ] = geoDiff2d(lat,lon,lat2,lon2)
%GEODIFF2D Find the slant range distance between two points in 2-D space.
%   This function uses the law of haversines to approximate the distance
%   between two points relative to the WGS84 ellipsoid.
%   12/11/16 Shelton    Code cleanup
%             % sample points
%             phi1    =  39.707145;
%             lambda1 = -75.036073;
%             phi2    =  39.706640;
%             lambda2 = -75.033629;

            %% Define a Haversine
            % https://en.wikipedia.org/wiki/Haversine_formula
            hav = @(x) sin(x/2)^2;
            
            earthRadius = 6371e3; % mean radius of earth (meters)
            
            %% Assign inputs
            phi1    =  lat;
            lambda1 = lon;
            phi2    =  lat2;
            lambda2 = lon2;
            %% Unit Conversions
            % convert degrees to radians
            phi1    = phi1*(pi/180);
            lambda1 = lambda1*(pi/180);
            phi2    = phi2*(pi/180);
            lambda2 = lambda2*(pi/180);
            %% Compute $\Delta$
            deltaPhi = phi2-phi1;
            deltaLambda = lambda2-lambda1;

            %% Compute 2 dimensional distance
            d= 2*earthRadius*asin(sqrt(hav(deltaPhi)+cos(phi1)*cos(phi2)*hav(deltaLambda)));

end

