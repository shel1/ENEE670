function [ rLat, rLon ] = posGenerator( oLat,oLon,deltaLat,deltaLon )
%POSGENERATOR Generate one pair of random lat/lon coordinates within the
%values given.
%   EXAMPLE:
%   [rLat, rLon = posGenerator(39.7054758,-75.0330031,.012,.014)
%   A uniform distribution over a rectangular map area results. Additional
%   code is required to filter for a point radius.
   
   maxLat = oLat+deltaLat;
   minLat = oLat-deltaLat;
   maxLon = oLon+deltaLon;
   minLon = oLon-deltaLon;
   %%
   % No additional math required above examples explained in help for
   % *rand*
   
   rLat = minLat + (maxLat-minLat).*rand;
   rLon = minLon + (maxLon-minLon).*rand;

end

