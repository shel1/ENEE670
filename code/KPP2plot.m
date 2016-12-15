%% KPP2 Output
close all;
[ d, varargout ] = geoDiff(0,0,0,39.7716, -74.9285, 1001);
%This function calculates the distance, and angles of each of the skydivers
%by taking a slice of data in dat array and computing it at each iteration. 
    
[g, h] = findLocDelta(0,0,1);
%FINDLOCDELTA Iterates over the geoDiff2d function to find lat/lon deltas
%  Output from this goes into checking/rejecting simulated lat/lon values
%  if they are outside the expected range.

%Assigning Initial variables
varargout= 0;
al = 0; 
rg = 0; 

dat =zeros(35,11); 
% figure;
%Loop for the altitude and range and link budget
for b_range = 1:11 
    al = 0; 
     
    for alt_1 = 0:35 
        al = al+1000; 
        [~,dat(alt_1+1,b_range),~] = LinkBudget(0,0,0,0,rg,al);
    end
    j = b_range*ones(1,11); 
%     plot(j,dat(b_range,:),'-+'); 
%     hold all
    rg = rg +h; 
end
%Title
% title('Plot of Range against Altitude')
% xlabel('Range (nm)') 
% ylabel('Altitude (ft*1000)') 
% grid on
figure
      for x= 1:10
          semilogy(dat(:,x),'-+');
          hold all
      end
    legend('0 -nm','1 -nm','2 -nm','3 -nm','4 -nm','5 -nm','6 -nm','7 -nm','8 -nm','9 -nm')
    title ('Plot of the Link Margin against Range') 
    xlabel('Altitude (ft*1000)') 
    ylabel('Link Margin (dB)') 
    grid on;
    %% Shelton 
    % Update 12/14/2016
    xlim([0 7]);
    hold off;
   %% 
   % Plot reveals $\Delta SNR$ required to close link
    figure;
    
    for x= 1:10
        plot(dat(:,x));
        hold all;
    end
    grid on;
    title('Linear Plot of Link Margin');
    ylabel('Link Margin (dB)');
    xlabel('Altitude (x 1000)');
    hold off;

    

           
       
    


