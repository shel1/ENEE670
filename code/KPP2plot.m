%Link Budget and EbNo for lat lon and alt for a given alt 0 , and 10756
% [ z, Lm, EbNo ] = LinkBudget(0,0,0,39.7716, -74.9285, 10756)
% This function will compute the angles for a given lat lon and alt from rData


[ d, varargout ] = geoDiff(0,0,0,39.7716, -74.9285, 10756)
%This function calculates the distance, and angles of each of the skydivers
%by taking a slice of rData and computing it at each iteration. 
    
    [g, h] = findLocDelta(0,0,1);
varargout= 0;% assigning a variable to varargout
% data = zeros([ ]);
al = 0; %assigning a variable to altitude
rg = 0; % assigning a variable to range
dat =zeros(35,11); %allocate the values of the altitude
figure;
for b_range = 1:11 % Linspace for ranges
    al = 0;
     
    for alt_1 = 0:35 % allocate altitude values
        al = al+1000; % altitude increaments of 1000
        [~,dat(alt_1+1,b_range),~] = LinkBudget(0,0,0,0,rg,al);
    end
    j = b_range*ones(1,11); %assigns and stores the value range values from 1-11
    plot(j,dat(b_range,:),'-+'); %Plotting the range against the data
    hold all
    rg = rg +h; %calculates the ranges in increments of 1
end
title('Plot of Range against altitude')
xlabel('Range/nm') % x-axis
ylabel('altitude/*1000ft') % y-axis
grid on
figure
      for x= 1:10
          plot(dat(:,x),'-+');
          hold all
      end
    legend('0','1','2','3','4','5','6','7','8','9')
    title ('Plot of the Link Margin against Range') %Title of plot
    xlabel('Altitude/*1000 ft') % x- axis
    ylabel('Link Margin') % y- axis
    grid on
    %surf(j,dat(b_range))
 

           
       
    


