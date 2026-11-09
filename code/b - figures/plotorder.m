function k = plotorder(experiment, apparatus, cues, lightdir)

% PLOTORDER  Assign an integer to each combination of experiment and
%            condition, to use in maintaining a consistent order
%            for data in plots

k = NaN(size(experiment));

for i = 1:numel(experiment)

    if experiment(i)==1

        if strcmp(apparatus(i),'physical')
            k(i) = 1;
        elseif strcmp(cues(i),'all-cue')
            k(i) = 2;
        elseif strcmp(cues(i),'reduced-render')
            k(i) = 3;
        elseif strcmp(cues(i),'reduced-depth')
            k(i) = 4;
        else
            k(i) = 5;
        end

    else

        if strcmp(cues,'allcue')
            k(i) = 6;
        elseif strcmp(lightdir,'left')
            k(i) = 7;
        else
            k(i) = 8;
        end

    end

end

end
