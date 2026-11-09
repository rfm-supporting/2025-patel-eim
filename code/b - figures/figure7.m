% figure7.m  Plot mean orientation matching slope by condition and participant

clear; clc;

% linear regression fits in orientation matching task for experiment 1
data = readtable('../data/oslope.csv');
data = data(data.experiment==1,:);

% Figure 7a. Mean slope by condition

% find mean and standard error for each condition
datag = data(:,{'experiment','apparatus','cues','lightdir'});
[g, datafit] = findgroups(datag);
datafit.mu_oslope = splitapply(@mean,data.oslope,g);
datafit.sigma_oslope = splitapply(@stderr,data.oslope,g);

% reorder rows to determine order of bars in bar plot
datafit.plotorder = plotorder(datafit.experiment,datafit.apparatus,datafit.cues,datafit.lightdir);
datafit = sortrows(datafit,'plotorder');
datafit = removevars(datafit,'plotorder');

% plot mean slope by condition
subplot(1,2,1);
bar(datafit.mu_oslope);
hold on
h = errorbar(datafit.mu_oslope,datafit.sigma_oslope,'k','LineWidth',2,'LineStyle','none');
plot(xlim,[ 1 1 ],'k--');
hold off
ylabel 'orientation matching slope'
set(gca,'XTickLabel',{'physical','all-cue','shadowless','reduced-depth','reduced-context'})
set(gca,'YLim',[ 0 1.1 ]);
set(gca,'FontSize',18);

% Figure 7b. Mean slope by participant

% find mean and standard error for each participant
datag = data(:,'subject');
[g, datafit] = findgroups(datag);
datafit.mu_oslope = splitapply(@mean,data.oslope,g);
datafit.sigma_oslope = splitapply(@stderr,data.oslope,g);

% plot mean slope by participant
subplot(1,2,2);
bar(datafit.mu_oslope);
hold on
h = errorbar(datafit.mu_oslope,datafit.sigma_oslope,'k','LineWidth',2,'LineStyle','none');
plot(xlim,[ 1 1 ],'k--');
hold off
ylabel 'orientation matching slope'
set(gca,'XTickLabel',datafit.subject);
set(gca,'YLim',[ 0 1.4 ]);
set(gca,'FontSize',18);
