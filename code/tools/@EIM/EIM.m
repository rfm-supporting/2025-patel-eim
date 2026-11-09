classdef EIM < handle

    % Equivalent illumination model (EIM) class

    properties

        slants      % reference patch slants
        luminances  % reference patch luminances
        rmatches    % match reflectance settings

        oslope      % regression slope in orientation matching task
        elevation   % lighting elevation

    end

    properties (SetAccess = protected)
        % fitted parameters
        alpha = NaN
        beta = NaN
        psi_s = NaN
    end

    methods

        function obj = EIM(args)
            arguments
                args.slants = []      % reference patch slants
                args.luminances = []  % reference patch luminances
                args.rmatches = []    % match reflectance settings
                args.oslope = NaN     % regression slope in orientation matching task
                args.elevation = NaN  % lighting elevation
            end
            % contructor; record input arguments
            obj.slants = args.slants(:);
            obj.luminances = args.luminances(:);
            obj.rmatches = args.rmatches(:);
            obj.oslope = args.oslope;
            obj.elevation = args.elevation;
        end

        function r = predictfn(obj, slants, luminances, alpha, beta, psi_s)
            % function to predict observer's match reflectance settings
            % from reference patch stimulus properties (slants, luminances)
            % and model parameters (alpha, beta, phi_s)
            if isnan(obj.oslope)
                % don't take bias in perceived orientation into account
                r = luminances ./ ( alpha * ( max(cosd(slants - psi_s),0) + beta) );
            else
                % take bias in perceived orientation into account
                r = luminances ./ ( alpha * ( max(cosd(slants*obj.oslope - psi_s),0) + beta) );
            end
        end

        function pa = point_to_ambient(obj)
            % calculate equivalent point-to-ambient illuminance ratio
            % from fitted beta parameter
            pa = 1/(obj.beta * cosd(obj.elevation));
        end

        function lambda = ice(obj)
            % convert point-to-ambient illuminance ratio to
            % illuminance contrast energy (ICE)
            lambda = sqrt(5/48) / ( 1/obj.point_to_ambient + 0.25 );
        end

        function [ slants, luminances, rmatches ] = summary(obj)
            % find mean reference patch luminance and match patch setting
            % at each reference patch slant
            slants = unique(obj.slants);
            luminances = NaN(size(slants));
            rmatches = NaN(size(slants));
            for i = 1:numel(slants)
                rmatches(i) = mean( obj.rmatches(obj.slants==slants(i)) );
                luminances(i) = mean( obj.luminances(obj.slants==slants(i)) );
            end
        end

    end

end
