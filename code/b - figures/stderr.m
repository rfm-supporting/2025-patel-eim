function s = stderr(x)

% STDERR Calculate standard error

s = std(x)/sqrt(numel(x));

end
