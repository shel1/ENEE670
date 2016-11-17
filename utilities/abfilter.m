function [ xk,vk,rk ] = abfilter( xk1,vk1,xm,h,numh,mcv,alpha,beta )
%ABFILTER Apply alpha beta filter to given position and velocity
%   ALPHABETA(posvec,velvec,prevpos,step,stepMultiplier,unitconversion,alpha,beta)
            
        xk = xk1 + (vk1.*(h*numh*mcv)); 
        vk = vk1;
        rk = xm -xk;
        xk = xk + (alpha.*rk);
        vk = vk + (beta.*rk)/h;
        %return rk in meters
        rk = rk/mcv;

end

