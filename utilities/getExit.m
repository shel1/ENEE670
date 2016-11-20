function [ varargout ] = getExit( dat )
%GETEXIT return the exit index from input vector
%   Best estimate based on the delta velocity signature
%   [ exitIdx ] = getExit( dat )
%   [ exitIdx,landIdx ] = getExit( dat )
%
%   11/19/16 Add landing finder and varargout.

    eT = 1.5;   % exit threshold
    lT = 0.3;   % landing threshold
    h = .2;     % hardware defined deltaT
     
    ground = find(dat.jump.hMSL<1500,1); %zero out before 1500m (realistic limit)
    dat.jump.velD(1:ground) = 0;
    badAcc = find(dat.jump.hAcc<2,1,'last');
    dat.jump.velD(badAcc:end) = 0;
    % get the derivative before zeroing out stuff
    velDprime = diff(dat.jump.velD)/h;
    %moving average
    velDprime = SMA(velDprime,25);
    
    velDprime2 = SMA(diff(dat.jump.velD)/h,50); %more noisy at the end of the data
    exitIdx = find((velDprime>eT),1); %2151
    landIdxtmp = find((abs(velDprime2(end:-1:exitIdx))>lT),1,'first');
    landIdx = length(velDprime)- landIdxtmp; %make it relative to the original dataset length
    landIdx = landIdx + 50; %add a little margin
    varargout{1} = exitIdx;
    varargout{2} = landIdx;
end

