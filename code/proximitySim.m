function [ output_args ] = proximitySim( input_args )
%PROXIMITYSIM Summary of this function goes here
%   Detailed explanation goes here
    %%
    % condition input data
    
    data1 = LoganData(1);
    data2 = LoganData(3);
    
    
    %exit threshold velocity
    eT = 1.5;
    velDprime1 = diff(data1.velD);
    velDprime2 = diff(data2.velD);
    exitIdx1 = find(velDprime1>eT,1);
    exitIdx2 = find(velDprime2>eT,1);
    
    figure;
    plot(data1.velD(exitIdx1:end));
    hold all;
    plot(data2.velD(exitIdx2:end));
    
    
    %%
    s2 = RandStream('mlfg6331_64','Seed',2);
    for i = 1:600
        s(i) = Skydiver();
    end
    q = [];
    c = [];
    
    for i = 1:600
        q = [q rand(stream)];
    end
    q'
    c = [q ;last]';
    c
%     reset(stream);
end

