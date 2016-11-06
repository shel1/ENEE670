function [fitresult, gof] = posFit(samp, truth)
%CREATEFIT(LATSAMP,LATVSAMP)
%  Create a fit.
%
%  Data for 'latFit' fit:
%      Y Output: latSamp
%      Validation Y: latVSamp
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 01-Nov-2016 21:53:09


%% Fit: 'latFit'.
[xData, yData] = prepareCurveData( [], samp );

% Set up fittype and options.
ft = 'pchipinterp';

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, 'Normalize', 'on' );

% Compare against validation data.
[xValidation, yValidation] = prepareCurveData( [], truth );
residual = yValidation - fitresult( xValidation );
nNaN = nnz( isnan( residual ) );
residual(isnan( residual )) = [];
sse = norm( residual )^2;
rmse = sqrt( sse/length( residual ) );
% fprintf( 'Goodness-of-validation for ''%s'' fit:\n', 'latFit' );
% fprintf( '    SSE : %f\n', sse );
% fprintf( '    RMSE : %f\n', rmse );
% fprintf( '    %i points outside domain of data.\n', nNaN );

% % Plot fit with data.
% figure( 'Name', 'latFit' );
% h = plot( fitresult, xData, yData);
% % Add validation data to plot.
% hold on
% h(end+1) = plot( xValidation, yValidation, 'bo', 'MarkerFaceColor', 'w' );
% hold off
% legend( h, 'latSamp', 'latFit', 'latVSamp', 'Location', 'NorthEast' );
% % Label axes
% ylabel latSamp
% grid on
