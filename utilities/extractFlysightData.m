function [ varargout ] = extractFlysightData( data, varargin )
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
    
    if nargout == 1
%         out.T   = T;
%         out.lat = lat;
%         out.lon = lon;
%         out.hMSL = hMSL;
%         out.velN = velN;
%         out.velE = velE;
%         out.velD = velD;
%         out.hAcc = hAcc;
%         out.vAcc = vAcc;
%         out.sAcc = sAcc;
        varargout = {data(idx).jump};
    else
        varargout{1} = T;
        varargout{2} = lat;
        varargout{3} = lon;
        varargout{4} = hMSL;
        varargout{5} = velN;
        varargout{6} = velE;
        varargout{7} = velD;
        varargout{8} = hAcc;
        varargout{9} = vAcc;
        varargout{10} = sAcc;
    end
end

