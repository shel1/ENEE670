function [ latStruct,lonStruct, trash, ctL ] = posGenWrapper( lat,lon,deltaLat,deltaLon,varargin )
%POSGENWRAPPER Iterates recursively until a value within bounds is returned
%   Detailed explanation goes here
    m2nm = 1852;
    LSB = 360/(2.^24);
    
    if nargin <5
        trash = 0; % start from zero
        ctL = 0;
    end
    if nargin == 7
        ctL = varargin{1};
        trash = varargin{2};
        radius = varargin{3};
    end
    
    [tempLat, tempLon] = posGenerator(lat,lon,deltaLat,deltaLon);
    locdiff = geoDiff2d(lat,lon,tempLat,tempLon);
    if locdiff > (radius*m2nm)
        %throw away and try again
        trash = trash+1;
        [latStruct,lonStruct, trash, ctL] = posGenWrapper(lat,lon,deltaLat,deltaLon, ctL,trash,radius);
    else
        ctL = ctL+1;
        % increment counter and assign values
        latStruct.val = tempLat;
        lonStruct.val = tempLon;

        % quantize
        templatq = tempLat/LSB;
        templonq = tempLon/LSB;

        % assign quantized values
        latStruct.qval = templatq;
        lonStruct.qval =  templonq;

        % convert to binary string
        templatbin = dec2bin(abs(templatq));
        templonbin = dec2bin(abs(templonq));

        % snip out the 12 LSBs
        templatbinshort = templatbin(end-11:end);
        templonbinshort = templonbin(end-11:end);

        % assign them
        latStruct.bin = templatbinshort; 
        lonStruct.bin = templonbinshort;

        % end at the same place, as if random numbers were generated
        % from the range [0 2^12]
        latStruct.b2d = bin2dec(templatbinshort);
        lonStruct.b2d = bin2dec(templonbinshort);

    end    

end

