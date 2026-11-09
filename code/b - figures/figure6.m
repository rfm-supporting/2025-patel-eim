% figure6.m  Plot orientation matching results for individual participants

clear; clc;

% load trial-by-trial data in orientation matching task
data = readtable('../data/data_orientation.csv');

% select experiment, condition, and participant
data = data(data.experiment==1,:);
data = data(strcmp(data.apparatus,'physical'),:);
data = data(strcmp(data.cues,'all-cue'),:);
data = data(strcmp(data.lightdir,'right'),:);
data = data(strcmp(data.subject,'aa'),:);

% find linear regression
data.match_slant = -90 + mod(data.match_slant+90,180);
b = polyfit(data.reference_slant, data.match_slant, 1);

% plot data and fit
xlim = [ -55 55 ];
ylim = [ -90 90 ];
plot(xlim,b(1)*xlim+b(2),'k-');
hold on
plot(data.reference_slant,data.match_slant,'ro','MarkerSize',10,'MarkerFaceColor','r');
hold off
axis([ xlim ylim ]);
set(gca,'FontSize',18);
xlabel 'reference orientation (deg)'
ylabel 'match orientation (deg)'

% report fitted parameters
fprintf('y = %.2f * x + (%.2f)\n',b);
