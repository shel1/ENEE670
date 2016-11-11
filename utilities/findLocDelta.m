function [ deltaLat, deltaLon ] = findLocDelta( oLat,oLon,rad )
%FINDLOCDELTA Iterates over the geoDiff2d function to find lat/lon deltas
%  Output from this goes into checking/rejecting simulated lat/lon values
%  if they are outside the expected range.
     
    if nargin < 3
        rad = 10;
        oLat = 39.7054758;
        oLon = -75.0330031; 
    end
    
    %step size
    h=1e-5; % gets within 1m

    %conversion
    m2nm = 1852;
    
    %prime the loops
    tempLat=oLat;
    tempLon=oLon;
    latdist = 0;
    londist = 0;
    count = 0;
    %find lat delta
    while (latdist < (rad*m2nm)) 
        tempLat = tempLat+h;
        latdist=geoDiff2d(oLat,oLon,tempLat,oLon);
        londist=geoDiff2d(oLat,oLon,oLat,tempLon);
        count = count+1;
    end

    %find lon delta    
    while londist < (rad*m2nm)
        tempLon = tempLon+h;
        londist=geoDiff2d(oLat,oLon,oLat,tempLon);
        count = count+1;
    end
    
    %delta works in either direction +/-
    deltaLat = abs(oLat - tempLat);
    deltaLon = abs(oLon - tempLon);

end

