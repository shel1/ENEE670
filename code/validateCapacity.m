function [ odat ] = validateCapacity( dat )
%VALIDATECAPACITY take the difference between columns in DAT
%   This tool runs on simulated simultaneous MSO's generated.
%   The difference equals an overlapping message, and in this rev, will
%   signify both messages being dropped.
%   Both MSO data and Ttx data should work with this, DIFF does not care if
%   the data are integers or floats. They're stored the same.
    [r c] = size(dat);
    odat = struct();
    % dake difference between columns
    for i=1:c
        for j=1:c
            tempdiff= diff([dat(:,i) dat(:,j)],1,2);
            if sum(tempdiff)==0 %help identify when its doing a diff against itself
                tempdiff(:,1)=nan; 
            end
            dr(:,j)=tempdiff;
            odat(i).dr(:,j) = dr(:,j);
        end
        % find and report the run and message that collided.
        % its a 2D array, since its only relative to that 'jumper'
        [zr, zc]=find(odat(i).dr==0);
        odat(i).zeroidx= [zr zc];
    end
end

