function [ xk,vk,rk ] = abfilter( xk1,vk1,xm,h,numh,mcv,alpha,beta )
%ABFILTER Apply alpha beta filter to given position and velocity
%   ABFILTER(posvec,velvec,prevpos,step,stepMultiplier,unitconversion,alpha,beta)
%   11/29/2016 Update line 12 for ./ instead of /
            
        xk = xk1 + (vk1.*(h*numh*mcv)); 
        vk = vk1;
        rk = xm -xk;
        xk = xk + (alpha.*rk);
        vk = vk + (beta.*rk)/h;
        %return rk in meters
        rk = rk./mcv;

end

