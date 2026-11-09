% figure10.m  Illustrate mapping from ICE diffuseness measure to Thouless ratio

clear; clc;

% Figure 10a. Plot match reflectance as a function of reference illuminance
% for an EIM model observer

% Choose the orientations at which we will show the simulated reference
% patch. Here we use the spherical coordinate system introduced in the paper.
phiR = 0;         % elevation
psiR = -45:5:45;  % azimuths
nR = [ cosd(phiR)*cosd(psiR)' cosd(phiR)*sind(psiR)' repmat(sind(phiR),size(psiR))' ];  % unit surface normals

% Choose the simulated lighting direction, again using the coordinate
% system from the paper.
phiS = 22;  % elevation
psiS = 22;  % azimuth
nS = [ cosd(phiS)*cosd(psiS) cosd(phiS)*sind(psiS) sind(phiS) ];  % unit lighting direction vector

% Set the simulated lighting diffuseness, using the ICE diffuseness
% measure. The real and simulated lighting in our experiments
% had an ICE value of 0.55, so here we set ice_true = 0.55. To redo
% the analysis below for different experimental settings (for example,
% for the previous studies listed in Table 1), simply set ice_true to
% the ICE value for the lighting in that setting.
ice_true = 0.55;

% We will examine model observers who estimate reflectance following
% the EIM described in the paper. Here we set the ICE values that each
% model observer believes to describe the lighting in the scene.
ice_observer_list  = [ 1e-3 0.1:0.1:ice_true ice_true ];

% initialize array of Thouless ratios, one for each model observer
thouless = NaN(size(ice_observer_list));

figure(1); clf; subplot(1,2,1); hold on;

% step through model observers
for i = 1:numel(ice_observer_list)

    % convert ICE values to ratios A/D of ambient and directional illuminances
    % - formula from Morgenstern et al. (2014)
    AD_true = (sqrt(5/48)/ice_true) - 0.25;
    AD_observer = (sqrt(5/48)/ice_observer_list(i)) - 0.25;

    % find illuminance at each reference patch orientation
    % - assume directional illuminance is 1, and find corresponding ambient illuminance
    D_true = 1;
    A_true = D_true * AD_true;
    % - rescale ambient and direct intensities so that maximum illuminance is 1.0
    k = 1 / ( D_true*cosd(phiS) + A_true );
    D_true = D_true * k;
    A_true = A_true * k;
    % - find illuminance at each orientation, using Lambertian shading model
    illum_true = ( D_true * max(nR*nS',0) ) + A_true;

    % find what the model observer believes to be the illuminance at
    % each reference patch orientation
    % - assume directional illuminance is 1, and find corresponding ambient illuminance
    D_observer = 1;
    A_observer = D_observer * AD_observer;
    % - rescale perceptual ambient and direct intensities so that maximum perceptual illuminance is 1.0
    k = 1 / ( D_observer*cosd(phiS) + A_observer );
    D_observer = D_observer * k;
    A_observer = A_observer * k;
    % - find expected illuminance at each orientation
    illum_observer = ( D_observer * max(nR*nS',0) ) + A_observer;

    % assume true reference reflectance is 0.5, and find the model
    % observer's match reflectance
    rho_true = 0.5;
    rho_match = rho_true * (illum_true ./ illum_observer);

    % plot log match reflectance vs log true illuminance
    plot( illum_true, rho_match, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r' );

    % fit and plot linear regression
    b = regress( log(rho_match), [ log(illum_true) ones(size(illum_true)) ] );
    xlim = [ 0.52 1.04 ];
    plot( xlim, exp(b(1)*log(xlim) + b(2)), 'r-' );

    % find Thouless ratio from regression slope; see Appendix B
    thouless(i) = 1 - b(1);
    
    % label regression line with ICE value
    xx = min(illum_true)*1.05;
    yy = exp(b(1)*log(xx) + b(2));
    h = text(xx,yy,sprintf('%.02f',ice_observer_list(i)));
    h.FontSize = 16;
    h.HorizontalAlignment = 'center';

end

xlabel 'reference illuminance'
ylabel 'match reflectance'
axis square
set(gca,'FontSize',18);
set(gca,'XScale','log','YScale','log');
set(gca,'XLim',xlim,'YLim',[ 0.25 0.58 ]);
set(gca,'YTick',0.3:0.1:0.5);
set(gca,'Box','on');
h = text(0.565,0.538,'ICE');
set(h,'FontSize',16);

% Figure 10b. Show power function approximation to the mapping from ICE to Thouless ratio

% fit power function to mapping from model observers' ICE parameters
% to model observers' Thouless ratios
fitfn = @(x, p) power( x/ice_true, p );
errfn = @(p) sum( ( fitfn(ice_observer_list, p) - thouless ).^2 );
gamma = fminbnd(errfn, 0.5, 1.5 );

subplot(1,2,2);
h = fplot( @(x) fitfn(x, gamma), [ 0 0.6 ], 'b-' );
set(h,'LineWidth',2);
hold on
plot(ice_observer_list, thouless, 'ro', 'MarkerSize', 15, 'MarkerFaceColor', 'r');
hold off
axis square
xlabel 'ICE parameter'
ylabel 'Thouless ratio'
axis([ 0 0.6 0 1.05 ]);
set(gca,'FontSize',18);
h = text(0.05,0.12, sprintf('\\tau \\approx ( ICE / %.2f )^{%.2f}',ice_true,gamma));
set(h,'FontSize',18);
