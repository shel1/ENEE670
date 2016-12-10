function [ newMSO, Rm, Ttx ] = msoGenerator( varargin )
%MSOGENERATOR Generate ADS-B Message Start Opportunities


    switch nargin
        case {1,2}
            % one input = one flysight record
            if ~varargin{2}
                tdat = extractFlysightData(varargin{1});
            else
                tdat = varargin{1};
            end
            
                
            tdat1 = table2array(tdat(:,2:3));%snip out the lat and lon
            [tdatlat,tdatlon] = posconv(tdat1(:,1),tdat1(:,2));
            
            N = [tdatlat';tdatlon'];
            len = length(tdatlat);
            R = zeros(len,1);
            
            for m = 0:len-1
                m1 = m+1;
                tidx = mod(m1,2)+1;
                switch m
                    case 0 
                        R(m1) = mod(N(1,m1).b2d,3200);
                        fprintf('Case 0, R(0)= %g\n',R(m1));

                    case 1
                        term1 = 4001*R(m1-1);
                        term2 = N(tidx,m1).b2d;
                        R(m1) = mod(term1+term2,3200);
                        fprintf('Case 1, R(1)= %g\n',R(m1));
                    otherwise
                        % anything other than m=0 or m=1
                        term1 = 4001*R(m1-1);
                        term2 = N(tidx,m1).b2d;
                        R(m1) = mod(term1+term2,3200);
                end
            
            end
            newMSO = 752+R;
            Rm = R;
            Ttx = (6000 + (250.*newMSO))*1e-6;                
        case 3
            % three inputs, part of the capacity sim. N, m and R dealt with
            % outside of this function.
            N = varargin{1};
            m = varargin{2};
            lastR = varargin{3};
            m1 = m+1;
            tidx = mod(m1,2)+1;

            switch m
                case 0 
                    Rm = mod(N(1).b2d,3200);

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
            Ttx = (6000 + (250*newMSO))*1e-6;
    
    end
        
    
end

