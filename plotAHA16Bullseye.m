function h = plotAHA16Bullseye(vals, clim, cmapName, plotTitle, cbLabel, valueFormat, sdvals)
% plotAHA16Bullseye  Plot 16-segment AHA-style bullseye with central hole.
%
% vals must be 16x1 or 1x16:
%   1-6   basal segments
%   7-12  mid segments
%   13-16 apical segments
%
% The 17th apical cap is intentionally left as a central hole.
%
% Example:
%   plotAHA16Bullseye(MDvals, [1.2 1.8], "parula", ...
%       "MD", "MD (\mum^2/ms)", "%.2f");

    vals = vals(:);

    if numel(vals) ~= 16
        error('vals must contain 16 values.');
    end

    if nargin < 2 || isempty(clim)
        clim = [min(vals, [], 'omitnan'), max(vals, [], 'omitnan')];
    end

    if nargin < 3 || isempty(cmapName)
        cmapName = "parula";
    end

    if nargin < 4
        plotTitle = "";
    end

    if nargin < 5
        cbLabel = "";
    end

    if nargin < 6 || isempty(valueFormat)
        valueFormat = "%.2f";
    end

    if nargin < 7
        sdvals = [];
    end

    sdvals = sdvals(:);

    % Create axes
    h = axes;
    hold(h, 'on');
    axis(h, 'equal');
    axis(h, 'off');

    % Radii for three concentric rings plus central hole
    rOuter = 1.00;
    rBasalInner = 5/7;
    rMidInner   = 3/7;
    rApexInner  = 1/7;   % central hole radius

    % Colormap
    colormap(h, cmapName);
    caxis(h, clim);
    cmap = colormap(h);
    nCol = size(cmap, 1);

    % Helper function for colour lookup
    function c = val2colour(v)
        if isnan(v)
            c = [0.85 0.85 0.85]; % grey for missing values
        else
            t = (v - clim(1)) / (clim(2) - clim(1));
            t = max(0, min(1, t));
            idx = 1 + round(t * (nCol - 1));
            c = cmap(idx, :);
        end
    end

    % Draw rings
    drawRing(1:6,   rBasalInner, rOuter,      6, 60); % basal
    drawRing(7:12,  rMidInner,   rBasalInner, 6, 60); % mid
    drawRing(13:16, rApexInner,  rMidInner,   4, 45); % apical, rotated clockwise 45 degrees

    % Draw central white hole explicitly
    theta = linspace(0, 2*pi, 200);
    patch( ...
        rApexInner*cos(theta), ...
        rApexInner*sin(theta), ...
        'w', ...
        'EdgeColor', 'w', ...
        'LineWidth', 1.5, ...
        'Parent', h);
    
    % Anterior insertion point indicator
    % With the current orientation, this is the boundary between
    % basal segment 1 and basal segment 2, i.e. 120 degrees.
    thetaAIP = deg2rad(120);
    
    rTickOuter = rOuter + 0.035;
    rTickInner = rOuter - 0.055;
    
    plot( ...
        [rTickInner rTickOuter] * cos(thetaAIP), ...
        [rTickInner rTickOuter] * sin(thetaAIP), ...
        'k-', ...
        'LineWidth', 2.0, ...
        'Parent', h);
    
    plot( ...
        rTickOuter * cos(thetaAIP), ...
        rTickOuter * sin(thetaAIP), ...
        'ko', ...
        'MarkerFaceColor', 'k', ...
        'MarkerSize', 4.5, ...
        'Parent', h);
    
    % Colourbar
    cb = colorbar(h);

    if strlength(string(cbLabel)) > 0
        ylabel(cb, cbLabel, 'Interpreter', 'tex');
    end

    title(h, plotTitle, 'Interpreter', 'tex');

    hold(h, 'off');

    
    function drawRing(segIdx, r0, r1, nSeg, startAngle)
    
        for ii = 1:nSeg
    
            seg = segIdx(ii);
    
            % Start at specified angle and go clockwise
            theta1 = startAngle + (ii-1) * 360/nSeg;
            theta2 = startAngle + ii     * 360/nSeg;

            theta = linspace(deg2rad(theta1), deg2rad(theta2), 80);

            xOuter = r1 * cos(theta);
            yOuter = r1 * sin(theta);

            xInner = r0 * cos(fliplr(theta));
            yInner = r0 * sin(fliplr(theta));

            x = [xOuter, xInner];
            y = [yOuter, yInner];

            patch( ...
                'XData', x, ...
                'YData', y, ...
                'FaceColor', val2colour(vals(seg)), ...
                'EdgeColor', 'w', ...
                'LineWidth', 1.5, ...
                'Parent', h);

            % Segment value label
            thetaText = deg2rad((theta1 + theta2)/2);
            rText = (r0 + r1)/2;

            if isnan(vals(seg))
                labelStr = "NA";
                txtColour = [0.2 0.2 0.2];
            else
                labelStr = sprintf(valueFormat, vals(seg));
                txtColour = chooseTextColour(val2colour(vals(seg)));
                if ~isempty(sdvals)
                    labelStr2 = sprintf(valueFormat, sdvals(seg));
                    labelStr = [labelStr '±' labelStr2];
                end
            end

            text( ...
                rText*cos(thetaText), ...
                rText*sin(thetaText), ...
                labelStr, ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'middle', ...
                'Color', txtColour, ...
                'FontSize', 7.5, ...
                'FontWeight', 'bold', ...
                'Parent', h);
        end
    end

    function txtColour = chooseTextColour(faceColour)
        % Choose black or white text based on approximate luminance.
        luminance = 0.299*faceColour(1) + 0.587*faceColour(2) + 0.114*faceColour(3);

        if luminance > 0.55
            txtColour = [0 0 0];
        else
            txtColour = [1 1 1];
        end
    end
end