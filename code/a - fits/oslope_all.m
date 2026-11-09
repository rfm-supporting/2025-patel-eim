% oslope_all.m

clear; clc;

% load trial-by-trial data in orientation matching task
data = readtable('../data/data_orientation.csv');

% find regression slope for each experiment, condition, subject, and
% pre/post condition (i.e., was the orientation matching task run 
% before (prepost=1) or after (prepost=2) the lightness matching task)
datag = data(:,{'experiment','apparatus','cues','lightdir','subject','prepost'});
[g,summary] = findgroups(datag);
[summary.oslope, summary.oslope_mae] = splitapply(@oslopefit,data.reference_slant,data.match_slant,g);

% sort and save fits
summary = sortrows(summary)
writetable(summary,'oslope.csv');
! mv oslope.csv ../data


function [ oslope, oslope_mae ] = oslopefit(thetastim, thetamatch)

% find a linear regression fit to match angle vs. reference patch angle
thetamatch = -90 + mod(thetamatch+90,180);
b = polyfit(thetastim, thetamatch, 1);
oslope = b(1);

% find mean absolute error of fit
residuals = thetamatch - ( b(1)*thetastim + b(2) );
oslope_mae = mean(abs(residuals));

end
