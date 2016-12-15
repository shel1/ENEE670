function [ latTmp, lonTmp ] = posconv( tLat,tLon )
%POSCONV Convert DD to the 12 LSBs for MSO generation
%   Detailed explanation goes here

    LSB = 360/(2.^24);

    latStruct.val = tLat;
    lonStruct.val = tLon;

    % quantize
    templatq = tLat/LSB;
    templonq = tLon/LSB;

    % assign quantized values
    latStruct.qval = templatq;
    lonStruct.qval =  templonq;

    % convert to binary string
    templatbin = dec2bin(abs(templatq));
    templonbin = dec2bin(abs(templonq));

    % snip out the 12 LSBs
    templatbinshort = templatbin(:,end-11:end);
    templonbinshort = templonbin(:,end-11:end);

    % assign them
    latStruct.bin = templatbinshort; 
    lonStruct.bin = templonbinshort;

    % end at the same place, as if random numbers were generated
    % from the range [0 2^12]
    latStruct.b2d = bin2dec(templatbinshort);
    lonStruct.b2d = bin2dec(templonbinshort);
    for x = 1:length(latStruct.val)
        latTmp(x).val = latStruct.val(x);
        latTmp(x).qval = latStruct.qval(x);
        latTmp(x).bin = latStruct.bin(x,:);
        latTmp(x).b2d = latStruct.b2d(x);
        lonTmp(x).val = lonStruct.val(x);
        lonTmp(x).qval = lonStruct.qval(x);
        lonTmp(x).bin = lonStruct.bin(x,:);
        lonTmp(x).b2d = lonStruct.b2d(x);     
    end
    latTmp = latTmp';
    lonTmp = lonTmp';
end

