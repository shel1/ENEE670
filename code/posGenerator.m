function [ rLat, rLon ] = posGenerator( oLat,oLon,deltaLat,deltaLon )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
   
   maxLat = oLat+deltaLat;
   minLat = oLat-deltaLat;
   maxLon = oLon+deltaLon;
   minLon = oLon-deltaLon;
   
   rLat = minLat + (maxLat-minLat).*rand;
   rLon = minLon + (maxLon-minLon).*rand;
    
    %determine deltaPhi (lat)
%     maxPhi =
%     
%     distUnit = earthRadius('nm');
%     
% %     [latc, lonc] = scircle1(oLat,oLon,rad,distUnit);
%     [latc, lonc] = scircle1(oLat,oLon,rad,[],distUnit);
%     plotm(oLat,oLon,'o'); %plot the origin
%     plotm(latc,lonc,'g');
%     

end

