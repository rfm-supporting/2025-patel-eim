% figure8.m  Show effect of taking orientation matching slope into account in EIM fits

clear; clc;

% load EIM fits for experiment 1
data = readtable('../data/eimfit.csv');
data = data(data.experiment==1,:);

% get ICE values and orientation matching slopes
ice0 = data(isnan(data.oslope),:).ice;  % get ICE values calculated from fits that do not correct for orientation matching slope
ice1 = data(~isnan(data.oslope),:).ice; % get ICE values calculated from fits that do correct for orientation matching slope
oslope = data(~isnan(data.oslope),:).oslope;  % get orientation matching slopes used to correct ICE values in ice1

% plot ICE values without (left) and with (right) correction for orientation matching slope
clf;
hold on
xlim = [ 0.7 2.3 ];
plot(xlim,[ 1.29 1.29 ],'k-','LineWidth',2);
plot(xlim,[ 0.55 0.55 ],'k--','LineWidth',2);
for i = 1:numel(ice0)

    h = plot([ 1 2 ],[ ice0(i) ice1(i) ],'o-','MarkerSize',10,'LineWidth',1);

    % use different plot colours for different categories of trials
    if ice1(i)>1.2
        % ICE value near maximum (1.29); green data points
        c = [ 0 0.9 0 ];
        hh(1) = h;
    elseif oslope(i)>1
        % orientation matching slope greater than one; red data points
        c = [ 1 0 0 ];
        hh(2) = h;
    else
        % all others; grey data points
        c = 0.5*[ 1 1 1 ];
        hh(3) = h;
    end

    h.Color = c;
    h.MarkerFaceColor = h.Color;

end

hold off
axis([ xlim 0 1.4 ]);
set(gca,'XTick',[ 1 2 ],'XTickLabel',{'true azimuth','perceived azimuth'});
set(gca,'FontSize',18);
ylabel ICE
box on
h = legend(hh,'corrected ICE > 1.2','orientation matching slope > 1','other','Location','NorthWest','box','off');
p = h.Position;
h.Position = p + [ 0 -0.06 0 0 ];
