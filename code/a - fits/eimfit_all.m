% eimfit_all.m

clear; clc;

addpath('../tools');

% load trial-by-trial data in lightness matching task
data = readtable('../data/data_lightness.csv');

% load linear regression fits in orientation matching task
otable = readtable('../data/oslope.csv');

% add regression slope to trial-by-trial data as another column
data.oslope = lookup_oslope(data.experiment, data.apparatus, data.cues, data.lightdir, data.subject, otable);

% fit EIM, taking into account regression slope in orientation matching task
datag = data(:,{'experiment','apparatus','cues','lightdir','reference_ref','subject'});
[g, datafit1] = findgroups(datag);
[datafit1.oslope, datafit1.alpha, datafit1.beta, datafit1.psi_s, datafit1.pa, datafit1.ice] = ...
    splitapply(@eimfit,data.reference_slant,data.reference_lum,data.match_ref,data.oslope,g);

% fit EIM, not taking into account regression slope in orientation matching task
data.oslope = NaN(size(data.oslope));
[g, datafit0] = findgroups(datag);
[datafit0.oslope, datafit0.alpha, datafit0.beta, datafit0.psi_s, datafit0.pa, datafit0.ice] = ...
    splitapply(@eimfit,data.reference_slant,data.reference_lum,data.match_ref,data.oslope,g);

% merge and save fits
datafit = sortrows([ datafit0 ; datafit1 ])
writetable(datafit,'eimfit.csv');
! mv eimfit.csv ../data


function [oslope_out, alpha, beta, psi_s, pa, ice] = eimfit(slants, luminances, rmatches, oslope)

% fit EIM to behavioural data; see EIM class in code/tools/@EIM
eim = EIM(slants=slants, luminances=luminances, rmatches=rmatches);
oslope_out = oslope(1);
eim.oslope = oslope_out;
eim.elevation = 22;
eim.fit(20);  % make 20 fits and keep best one

% return fitted parameters
alpha = eim.alpha;
beta = eim.beta;
psi_s = eim.psi_s;
pa = eim.point_to_ambient;
ice = eim.ice;

end


function oslope = lookup_oslope(experiment, apparatus, cues, lightdir, subject, otable)

% Loop up orientation matching slope for a given experiment, condition, and participant

oslope = NaN(size(experiment));

for i = 1:numel(experiment)
    b1 = otable.experiment == experiment(i);
    b2 = strcmp(otable.apparatus, apparatus(i));
    b3 = strcmp(otable.cues, cues(i));
    b4 = strcmp(otable.lightdir, lightdir(i));
    b5 = strcmp(otable.subject, subject(i));
    b6 = otable.prepost == 2;
    b = b1 & b2 & b3 & b4 & b5 & b6;
    oslope(i) = otable(b,:).oslope;
end

end
