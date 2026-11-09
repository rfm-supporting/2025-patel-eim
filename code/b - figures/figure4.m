% figure4.m  Plot reflectance matches and EIM fit for individual participants

clear; clc;

addpath('../tools');

% plot results for both reference reflectances
for ref = [ 0.41 0.58 ]

    % load trial-by-trial data in lightness matching task
    data = readtable('../data/data_lightness.csv');

    % select experiment, condition, and participant
    data = data(data.experiment==1,:);
    data = data(strcmp(data.apparatus,'physical'),:);
    data = data(strcmp(data.cues,'all-cue'),:);
    data = data(strcmp(data.lightdir,'right'),:);
    data = data(data.reference_ref==ref,:);
    data = data(strcmp(data.subject,'aa'),:);

    % fit EIM
    eim = EIM(slants=data.reference_slant, luminances=data.reference_lum, rmatches=data.match_ref);
    eim.elevation = 22;
    eim.fit(20, false);  % make 20 fits and keep the best one; don't show intermediate results
    eim.plot;
    hold on

    % report fitted parameters
    fprintf('alpha = %.2f\n',eim.alpha);
    fprintf('beta = %.2f\n',eim.beta);
    fprintf('psi_s = %.2f\n\n',eim.psi_s);

end

hold off
