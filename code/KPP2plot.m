%Link Budget and EbNo for lat lon and alt for a given alt 0 , and 10756
% [ z, Lm, EbNo ] = LinkBudget(0,0,0,39.7716, -74.9285, 10756)
% This function will compute the angles for a given lat lon and alt from rData


[ d, varargout ] = geoDiff(0,0,0,39.7716, -74.9285, 10756)
%This function calculates the distance, and angles of each of the skydivers
%by taking a slice of rData and comouting it at each iteration. 
    
    [g, h] = findLocDelta(0,0,1);
varargout= 0;% assigning a variable to varargout
% data = zeros([ ]);
al = 0; %assigning a variable to altitude
rg = 0; % assigning a variable to range
dat =zeros(35,11); %allocate the values of the range
figure;
for b_range = 1:11 % Linspace for ranges
     rg = rg +h;
%     for r = 1:1:10 
%     [ z, Lm, EbNo ] = LinkBudget(0,0,0,39., -74.9285, al);
%     fprintf(' %5d  %5d %5d  %7.2f  %7.2f  % 7.2f  % 3.4f\n', z, Lm, EbNo, al)%the range of altitude from the highest point to the ground level
    for alt_1 = 0:35
        al = al+1000;
        [~,dat(alt_1+1,b_range),~] = LinkBudget(0,0,0,0,rg,al);
    end
    j = b_range*ones(1,11);
    plot(j,dat(b_range,:),'-+');
    hold all
end
figure
      for x= 1:10
          plot(dat(:,x),'-+');
          hold all
      end
    legend('Points for each altitude') % Showing which plot is which
    title ('Plot of the Range against altitude') %Title of plot
    xlabel('Range/ nm') % x- axis
    ylabel('Altitude/*1000') %y- axis
    grid on
     
       
    


