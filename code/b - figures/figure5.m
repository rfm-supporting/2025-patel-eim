% figure5.m  Plot mean ICE values by condition and participant in experiment 1

clear; clc;

% load EIM fits
data = readtable('../data/eimfit.csv');
data = data(data.experiment==1,:); % select fits for experiment 1
data = data(isnan(data.oslope),:); % select fits that did not incorporate orientation matching data

% Figure 5a. Mean ICE by condition

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
subplot(1,2,1);
bar(datafit.mu_ice);
hold on
h = errorbar(datafit.mu_ice,datafit.sigma_ice,'k','LineWidth',2,'LineStyle','none');
plot(xlim,[ 0.55 0.55 ],'k--');
hold off
ylabel ICE
set(gca,'XTickLabel',{'physical','all-cue','shadowless','reduced-depth','reduced-context'})
set(gca,'YLim',[ 0 0.6 ]);
set(gca,'FontSize',18);

% Figure 5b. Mean ICE by participant

% find mean and standard error for each participant
datag = data(:,'subject');
[g, datafit] = findgroups(datag);
datafit.mu_ice = splitapply(@mean,data.ice,g);
datafit.sigma_ice = splitapply(@stderr,data.ice,g);

% plot mean ICE by participant
subplot(1,2,2);
bar(datafit.mu_ice);
hold on
h = errorbar(datafit.mu_ice,datafit.sigma_ice,'k','LineWidth',2,'LineStyle','none');
plot(xlim,[ 0.55 0.55 ],'k--');
hold off
ylabel ICE
set(gca,'XTickLabel',datafit.subject);
set(gca,'YLim',[ 0 0.6 ]);
set(gca,'FontSize',18);
