function [ T, lat, lon, hMSL, velN, velE, velD, hAcc, vAcc, sAcc ] = extractFlysightData( data, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    if nargin == 2
        idx = varargin{1};
    end
    if nargin == 1
        idx = 1;
    end
    T   = data(idx).time; 
    lat = data(idx).lat;
    lon = data(idx).lon;
    hMSL = data(idx).hMSL;
    velN = data(idx).velN;
    velE = data(idx).velE;
    velD = data(idx).velD;
    hAcc = data(idx).hAcc;
    vAcc = data(idx).vAcc;
    sAcc = data(idx).sAcc;
end

