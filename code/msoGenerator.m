function [ newMSO, Rm ] = msoGenerator( N,m,lastR )
%MSOGENERATOR Generate ADS-B Message Start Opportunities
%   Detailed explanation goes here
            m1 = m+1;
            tidx = mod(m1,2)+1;
            
            %Stopped here
            switch m
                case 0 
                    lastR = mod(N(1).b2d,3200);
                    
                    Rm = 752 + lastR;
                case 1
                    term1 = 4001*lastR;
                    term2 = N(tidx).b2d;
                    Rm = mod(term1+term2,3200);
                otherwise
                    % anything other than m=0 or m=1
                    term1 = 4001*lastR;
                    term2 = N(tidx).b2d;
                    Rm = mod(term1+term2,3200);
            end
                        
            newMSO = 752+Rm;    
end

