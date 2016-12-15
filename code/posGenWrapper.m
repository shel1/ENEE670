function [ latStruct,lonStruct, trash, ctL ] = posGenWrapper( lat,lon,deltaLat,deltaLon,varargin )
%POSGENWRAPPER Iterates recursively until a value within bounds is returned
%   
%   Example:
%   [latSttmp,lonSttmp, trash, ct]= posGenWrapper(lat,lon,deltaLat,deltaLon,ct,trash,radius);


%% Set up constants
    m2nm = 1852;
    LSB = 360/(2.^24);

    %% Check current state
    if nargin <5 % first iteration
        trash = 0; % start from zero
        ctL = 0;
    end
    if nargin == 7 % sometime after the first, and before finding a valid value
        ctL = varargin{1};
        trash = varargin{2};
        radius = varargin{3};
    end
    
    %% Pop a new value from the random number genie
    [tempLat, tempLon] = posGenerator(lat,lon,deltaLat,deltaLon);
    %% Distance check
    locdiff = geoDiff2d(lat,lon,tempLat,tempLon);
    if locdiff > (radius*m2nm) 
    %% Distance check failed
    % continue recursion
        trash = trash+1;
        [latStruct,lonStruct, trash, ctL] = posGenWrapper(lat,lon,deltaLat,deltaLon, ctL,trash,radius);
    else
        %% Value is good
        % increment counter and assign values
        ctL = ctL+1;
        [latStruct, lonStruct] = posconv(tempLat,tempLon);
        
    end    

end

