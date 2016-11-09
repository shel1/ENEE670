function [ datnew ] = SMA(dat,k)
%SMA Simple Moving Average with windows size K
%   Detailed explanation goes here
    [r,c] = size(dat);
    datnew = zeros(size(dat));
    for n=1:k:(r-k)
        datnew(n:n+k) = sum(dat(n:n+k))/k;
    end
end

