function [ output_args ] = proximitySim( input_args )
%PROXIMITYSIM Summary of this function goes here
%   Detailed explanation goes here
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

