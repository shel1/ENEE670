function [ T, lat, lon, hMSL, velN, velE, velD, hAcc, vAcc, sAcc ] = extractFlysightData( data, varargin )
%EXTRACTFLYSIGHTDATA Return a single record
%   Detailed explanation goes here
    if nargin == 2
        idx = varargin{1};
    end
    if nargin == 1
        idx = 1;
    end
    T   = data(idx).jump.time; 
    lat = data(idx).jump.lat;
    lon = data(idx).jump.lon;
    hMSL = data(idx).jump.hMSL;
    velN = data(idx).jump.velN;
    velE = data(idx).jump.velE;
    velD = data(idx).jump.velD;
    hAcc = data(idx).jump.hAcc;
    vAcc = data(idx).jump.vAcc;
    sAcc = data(idx).jump.sAcc;
end

