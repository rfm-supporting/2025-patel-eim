% figure12.m  Show how behaviour that is superficially similar to lightness
%             matching can emerge from a simple pointwise nonlinearity

clear; clc;

addpath('../tools');

% load trial-by-trial data for a single participant, with a single
% reference patch reflectance, in the physical condition in experiment 1
data = readtable('../data/data_lightness.csv');
data = data(strcmp(data.apparatus,'physical'),:);
data = data(strcmp(data.subject,'aa'),:);
data = data(data.reference_ref == 0.41,:);

% replace this participant's reflectance match settings with those of
% a model observer, whose match settings are simply a noisy, nonlinear
% transformation of the reference patch luminance
match = data.reference_lum;
match = match/max(match);
match = log(match);
match = 0.5 + 0.25*(match-max(match));
data.match_ref = match + normrnd(0,0.05,size(match));

% fit EIM to the model observer's data
eim = EIM(slants=data.reference_slant, luminances=data.reference_lum, rmatches=data.match_ref);
eim.elevation = 22;
eim.fit(20);

% plot the results
eim.plot;
