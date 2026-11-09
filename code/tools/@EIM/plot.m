function plot(obj, args)
arguments
    obj
    args.reflectance = NaN
    args.legend = false
    args.xlim = [ -55 55 ];
    args.ylim = [ 0.25 0.75 ];
end

% Plot lightness matches and EIM fit

hold on

% find mean reference patch luminance and reflectance match setting at each
% reference patch slant
[slants, luminances, rmatches] = obj.summary;

% plot stimulus luminance, scaled to fit reflectance matches
k = mean(rmatches ./ luminances);
hlum = plot_smooth(slants,k*luminances,args.xlim,'b-');

% plot EIM fit
rmatches_hat = obj.predictfn(slants, luminances, obj.alpha, obj.beta, obj.psi_s);
hfit = plot_smooth(slants,rmatches_hat,args.xlim,'g-','LineWidth',2);

% plot reflectance matches
plot(obj.slants,obj.rmatches,'o','MarkerSize',2,'Color','r','MarkerFaceColor','r');
hmatch = plot(slants,rmatches,'o','MarkerSize',10,'Color','r','MarkerFaceColor','r');

% plot horizontal line showing reference reflectance
if ~isnan(args.reflectance)
    plot(args.xlim,args.reflectance*[ 1 1 ],'k-');
    h = text(-52,args.reflectance*1.07,sprintf('r = %.2f',args.reflectance));
    set(h,'FontSize',14);
end

hold off
set(gca,'XLim',args.xlim,'XTick',-75:25:75);
set(gca,'YLim',args.ylim,'YTick',0.1:0.1:0.9,'YScale','log');
set(gca,'FontSize',18);
xlabel 'probe slant (deg)'
ylabel 'reflectance match'
box on
axis square

if args.legend
    legend([ hmatch hfit hlum ],'reflectance matches','EIM fit','luminance fit','Location','southeast','Box','off');
end

end

function h = plot_smooth(x, y, xlim, varargin)
f = @(u) spline(x,y,u);
fplot(f,xlim,varargin{:});
h = get(gca,'Children');
h = h(1);
end
