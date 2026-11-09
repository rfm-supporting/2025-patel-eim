% figure11.m  Plot mean Thouless ratio by condition for experiments 1 and 2

clear; clc;

% load EIM fits, and select fits that did not correct for orientation matching slope
data = readtable('../data/eimfit.csv');
data = data(isnan(data.oslope),:);

% convert ICE values to Thouless ratios
data.tr = (data.ice/0.55).^0.71;

% find mean and standard error by condition
datag = data(:,{'experiment','apparatus','cues','lightdir'});
[g, datafit] = findgroups(datag);
datafit.mu_tr = splitapply(@mean,data.tr,g);
datafit.sigma_tr = splitapply(@stderr,data.tr,g);

% reorder rows to determine order of bars in bar plot
datafit.plotorder = plotorder(datafit.experiment,datafit.apparatus,datafit.cues,datafit.lightdir);
datafit = sortrows(datafit,'plotorder');
datafit = removevars(datafit,'plotorder');

% plot mean Thouless ratio by condition
bar(datafit.mu_tr);
hold on
h = errorbar(datafit.mu_tr,datafit.sigma_tr,'k','LineWidth',2,'LineStyle','none');
plot([ 5.5 5.5 ],[ 0 1 ],'k-');
hold off
ylabel 'Thouless ratio'
set(gca,'XTickLabel',{'physical','all-cue','shadowless','reduced-depth','reduced-context','all-cue','reduced-context-left','reduced-context-right'});
set(gca,'YLim',[ 0 1 ],'YTick',0:0.1:1);
set(gca,'FontSize',18);
