function [ obj, exit_ok ] = fit(obj, nrepeat, display)
arguments
    obj
    nrepeat = 20    % number of fit attempts to make; keep best fit
    display = true  % flag whether to show intermediate results
end

% Fit EIM to behavioural data

% find mean reference patch luminance and reflectance match setting at each
% reference patch slant
[slants, luminances, rmatches] = obj.summary;

% define sum-of-squares error function
errfn = @(p) sum( ( rmatches - obj.predictfn(slants,luminances,p(1),p(2),p(3)) ).^2 );

% set whether to display intermediate results while optimizing
options = optimoptions('fmincon');
if display
    options = optimoptions(options,'Display','final');
else
    options = optimoptions(options,'Display','none');
end

% make several fit attempts and keep best fit
phat = [];
err_min = Inf;
exit_ok = false;
for i = 1:nrepeat

    pinit = [ mean(obj.luminances)+normrnd(0,std(luminances)) normrnd(1,0.3) normrnd(0,20) ];
    lb = [ 0   0   -Inf ];
    ub = [ Inf Inf  Inf ];
    [ phat_star, err_star, exit_star ] = fmincon(errfn, pinit, [], [], [], [], lb, ub, [], options);

    if exit_star
        exit_ok = true;
    end

    if err_star < err_min
        phat = phat_star;
        err_min = err_star;
    end

end

if ~exit_ok
    error('unable to find stable minimum of objective function; may simply indicate high equivalent lighting diffuseness');
end

% record best fit
obj.alpha = phat(1);
obj.beta = phat(2);
obj.psi_s = wrapTo180(phat(3));

end
