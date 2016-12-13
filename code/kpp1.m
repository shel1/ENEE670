function [out] = kpp1(varargin)
%KPP1 Capacity simulation for HawkEye
% [ outStruct ] = KPP1() 
%         lat = 39.7054758;
%         lon = -75.0330031;
%         radius = 10; %nautical miles
%         N   =50; %number of trials
%         sj = 600; %simultaneous messages
% [ outStruct ] = KPP1(N,sj)
% [ outStruct ] = KPP1(N,sj,radius)
% [ outStruct ] = KPP1(N,sj,radius,oLat,oLon)

    %m is the current UAT frame 
    %R(m-1) is a randomly generated number that will be put into N(0) and N(1)
    
    %N(0) = 12 LSBs of latitude
    %N(1) = 12 LSBs of longitude
    
    
    %%
    % Set up the first frame. Assume center of CK airport
    
    %% 
    % Reference value for testing
    %39.7054758 / -75.0330031 %http://www.airnav.com/airport/17n
    %%
    % No charge number, so we're ignoring the full globe, assume quadrant 1
    % for latitude and quadrant 4 for longitude, per Table 2-14 DO-282B
    
%% Condition Inputs
    close all;
    if nargin < 2
        lat = 39.7054758;
        lon = -75.0330031;
        radius = 10; %nautical miles
        N   =50; %number of trials
        sj = 600; %simultaneous messages
    end
    
    switch nargin
        case 2
            %% 
            % N and sj only
            fprintf('N and sj entered\n');
            lat = 39.7054758;
            lon = -75.0330031;
            radius = 10; %nautical miles
            %N and sj passed in
        case 3
            %% 
            % N and sj and radius passed
            lat = 39.7054758;
            lon = -75.0330031;
            N = varargin{1};
            sj = varargin{2};
            radius = varargin{3};            
        case 4
            error(why);
        case 5
            %% 
            % Everything Manually Entered
            fprintf('All constants entered\n');
            N = varargin{1};
            sj = varargin{2};
            radius = varargin{3};
            lat = varargin{4};
            lon = varargin{5};
    end
    
    LSB = 360/(2.^24);
    m2nm = 1852; %conversion
    
    %% 
    % Determine deltaLat and deltaLon for range to origin checking
    [deltaLat,deltaLon] = findLocDelta(lat,lon,radius);
    
    %% 
    % Initialize empty structs for random lat and random lon results
    skel.val=[];
    skel.qval=[];
    skel.bin=[];
    skel.b2d=[];
    

    %% 
    % Load presets for the the Mapping Toolbox    
    load('pStruct.mat');
  
    % so if the USA wasn't the center of the universe,we would care about
    % the rest here, and deal with the negative DD/DMS conversions 

    %% 
    % Generate struct skeletons to save time
    ct = 0;
    trash = 0;
    tskel.t=[];
    tskel.trash=[];
    tskel.ct=[];
    plotskel.cdata=[];
    plotskel.colormap=[];
    skel100 = repmat(skel,2*N,1);
    NVals = repmat(skel100,1,sj);
    rData = zeros(2,N*2,sj);
    vStructskel.dr=zeros(1,sj);
    vStructskel.zeroidx=zeros(1,sj);
    MSO = zeros(N,sj);
    Ttx = zeros(N,sj);
    R = zeros(N,sj); % random number stack
    sjtime = zeros(1,sj);
    mtime = repmat(tskel,N,sj);
    plotstack = repmat(plotskel,1,sj);
    %% 
    % Set up the random number stream
    rStream = RandStream('mlfg6331_64');
    RandStream.setGlobalStream(rStream);
    rowStack = skel100;%stacking up the lat/lon values
    %% 
    % Iterate through simultaneous jumpers
    for s = 1:sj
        %% 
        % Iterate N times for each simultaneous jumper
        sjtic = tic;
        for m = 0:N
            m1 = m+1;
            mtic = tic;
            %% 
            % Generate a new random point within the given point radius
            [latSttmp,lonSttmp, trash, ct]= posGenWrapper(lat,lon,deltaLat,deltaLon,ct,trash,radius);            
            % do all the math in advance
            rData(1,m1,s)= latSttmp.val;
            rData(2,m1,s)= lonSttmp.val;
            newRow = [latSttmp;lonSttmp];
            rowStack = [newRow; rowStack(1:end-2)];
            %% Generate an MSO for the new point
            if m == 0
                [MSO(m1,s),R(m1,s), Ttx(m1,s)] = msoGenerator(newRow,m,[]);
            else
                [MSO(m1,s),R(m1,s), Ttx(m1,s)] = msoGenerator(newRow,m,R(m1-1));
            end
            mtime(m1,s).t=toc(mtic);
            mtime(m1,s).trash = trash;
            mtime(m1,s).ct = ct;
        end
        
        %% 
        % Add the entire row to the stack
        NVals = [rowStack NVals(:,(1:end-1))];
        sjtime(s)= toc(sjtic);

    end
    %% Generate some pretty pictures
    distUnit = earthRadius('nm');   
    [latc, lonc] = scircle1(lat,lon,radius,[],distUnit);
    
    for x = 1:N
        axesm(pStruct);
        titlestr = ['Points for trial ' num2str(x)];
        plotm(lat,lon,'o'); %plot the origin
        plotm(latc,lonc,'g'); % plot the range
        plotm(squeeze(rData(1,x,:)),squeeze(rData(2,x,:)),'r.');
        title(titlestr);
        F = getframe;
        plotstack(x) = F;
        clf;
    end
    
    %% Run the validator
    vStructMSO = [validateCapacity(MSO)]';
    
    %% Populate the output struct
    out.rData = rData;
    out.MSO = MSO;
    out.R = R;
    out.Ttx = Ttx;
    out.NVals = NVals;
    out.mtime = mtime;
    out.sjtime = sjtime;
    out.vStructMSO = vStructMSO;
    out.plotframes = plotstack;
    %% Plot the results of the validation
    figure;
    histogram([vStructMSO.dupeCount]);
    hold all;
    title({'Distrbution of duplicate MSOs';'across 600 simultaneous messages. N=50'});

end