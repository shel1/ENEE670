function msoAnalysis(dat)
%MSOANALYSIS(Y1, Y2, Y3, Y4, Y5)
%  Y1:  MSOs
%  Y2:  velN
%  Y3:  velE
%  Y4:  velD
%  Y5:  hMSL
    [jdat] = extractFlysightData(dat);
    
    Y1 = jdat.MSO;
    Y2 = jdat.velN;
    Y3 = jdat.velE;
    Y4 = jdat.velD;
    Y5 = jdat.hMSL;

%  Auto-generated by MATLAB on 26-Nov-2016 16:37:40

% Create figure
figure1 = figure;
figure1.Position = [100 100 1750 875];

% Create axes
axes1 = axes('Parent',figure1);
set(axes1,'OuterPosition',[-0.04 0.53 0.626728110599078 0.45]);
hold(axes1,'on');

% Create plot
plot(Y1,'Parent',axes1,'Marker','.','LineStyle','none');

% Create title
title('Message Start Opportunities');

box(axes1,'on');
% Create axes
axes2 = axes('Parent',figure1,...
    'Position',[0.569 0.6 0.395 0.259]);
set(axes2,'OuterPosition',[0.5 0.68 0.5 0.3],'XGrid','on','YGrid','on');
hold(axes2,'on');
% Create plot
plot(Y2,'Parent',axes2);
% Create title
title('velN');
box(axes2,'on');
% Set the remaining axes properties

% Create title

axes3 = axes('Parent',figure1);
% Create plot
plot(Y3,'Parent',axes3);
title('velE');
hold(axes3,'on');
box(axes3,'on');
% Set the remaining axes properties
set(axes3,'OuterPosition',[0.5 0.363216880874118 0.5 0.3],'XGrid','on',...
    'YGrid','on');
% Create axes
axes4 = axes('Parent',figure1);
set(axes4,'OuterPosition',[-0.04 0.03 0.62 0.5],'XGrid','on','YGrid','on');
hold(axes4,'on');

% Create plot
plot(Y5);

% Create title
title('Altitude MSL');

box(axes4,'on');
% Set the remaining axes properties
set(axes4,'XGrid','on','YGrid','on');
% Create axes
axes5 = axes('Parent',figure1,...
    'Position',[0.574 0.030 0.398 0.260]);
hold(axes5,'on');

% Create plot
plot(Y4);

% Create title
title('velD');

box(axes5,'on');
% Set the remaining axes properties
set(axes5,'OuterPosition',[0.5 0.034342335471388 0.5 0.3],'XGrid','on',...
    'YGrid','on');
