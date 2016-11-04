function [ num ] = rpn(m,R,rN)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
            
            Rzero = mod(rN(1),3200); %matlab index starts at 1, not zero

            switch m
                case 0 
%                     fprintf('m = %g\n',m);
                    num = 752 + Rzero;
%                     num
%                     term1 = 0;
%                     term2 = 0;
                case 1
                    term1 = 4001*Rzero;
                    term2 = rN(mod(m,2)+1);
%                     fprintf('m = %g\n',m);
%                     fprintf('Term1: %g\n',term1);
%                     fprintf('Term2: %g\n',term2);
                    num = mod(term1+term2,3200);
                otherwise
                    % anything other than m=0 or m=1
%                     term1 = 4001*R(m-1+1);
%                     term2 = rN(mod(m,2)+1);
                    term1 = 4001*randi([0,4095],1,1);
                    term2 = randi([0,4095],1,1);
%                     fprintf('m = %g\n',m);
%                     fprintf('Term1: %g\n',term1);
%                     fprintf('Term2: %g\n',term2);                    
                    num = mod(term1+term2,3200);
            end

end

