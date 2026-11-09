% figure9.m  Plot mean ICE values by condition and participant in experiment 2

clear; clc;

% load EIM fits
data = readtable('../data/eimfit.csv');
data = data(data.experiment==2,:);  % select fits for experiment 2
data = data(isnan(data.oslope),:);  % select fits that did not incorporate orientation matching data

% find mean and standard error for each condition
datag = data(:,{'experiment','apparatus','cues','lightdir'});
[g, datafit] = findgroups(datag);
datafit.mu_ice = splitapply(@mean,data.ice,g);
datafit.sigma_ice = splitapply(@stderr,data.ice,g);

% reorder rows to determine order of bars in bar plot
datafit.plotorder = plotorder(datafit.experiment,datafit.apparatus,datafit.cues,datafit.lightdir);
datafit = sortrows(datafit,'plotorder');
datafit = removevars(datafit,'plotorder');

% plot mean ICE by condition
bar(datafit.mu_ice);
hold on
h = errorbar(datafit.mu_ice,datafit.sigma_ice,'k','LineWidth',2,'LineStyle','none');
plot(xlim,[ 0.55 0.55 ],'k--');
hold off
ylabel ICE
set(gca,'XTickLabel',{'all-cue','reduced-cue-left','reduced-cue-right'});
set(gca,'YLim',[ 0 0.6 ]);
set(gca,'FontSize',18);
