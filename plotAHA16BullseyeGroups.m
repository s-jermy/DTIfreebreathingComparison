function h = plotAHA16BullseyeGroups(vals, segGroup, clim, cmapName, plotTitle, cbLabel, valueFormat)
% plotAHA16BullseyeGroups
% Plot 16-segment AHA-style bullseye with:
%   - metric values as fill colour
%   - metric values as text
%   - segment group as border colour/thickness
%   - central apical cap left as a hole
%   - apical 4-segment ring rotated clockwise by 45 degrees
%
% vals:     16 x 1 metric values
% segGroup: 16 x 1 group labels
%           1 = Normal
%           2 = WT+
%           3 = LGE+
%
% Example:
%   plotAHA16BullseyeGroups(patientData(:,1), patientData(:,5), ...
%       [1.2 2.2], "parula", "Patient 1 MD", "MD (\mum^2/ms)", "%.2f");

    vals = vals(:);
    segGroup = segGroup(:);

    if numel(vals) ~= 16
        error('vals must contain 16 values.');
    end

    if numel(segGroup) ~= 16
        error('segGroup must contain 16 values.');
    end

    if nargin < 3 || isempty(clim)
        clim = [min(vals, [], 'omitnan'), max(vals, [], 'omitnan')];
    end

    if nargin < 4 || isempty(cmapName)
        cmapName = "parula";
    end

    if nargin < 5
        plotTitle = "";
    end

    if nargin < 6
        cbLabel = "";
    end

    if nargin < 7 || isempty(valueFormat)
        valueFormat = "%.2f";
    end

    % Create axes
    h = axes;
    hold(h, 'on');
    axis(h, 'equal');
    axis(h, 'off');

    % Radii for three concentric rings plus central hole
    rOuter      = 1.00;
    rBasalInner = 5/7;
    rMidInner   = 3/7;
    rApexInner  = 1/7;   % central hole radius

    % Colormap
    colormap(h, cmapName);
    caxis(h, clim);
    cmap = colormap(h);
    nCol = size(cmap, 1);

    % Draw rings
    drawRing(1:6,   rBasalInner, rOuter,      6, 60); % basal
    drawRing(7:12,  rMidInner,   rBasalInner, 6, 60); % mid
    drawRing(13:16, rApexInner,  rMidInner,   4, 45); % apical rotated clockwise 45 deg

    % Draw central white hole explicitly
    theta = linspace(0, 2*pi, 200);
    patch( ...
        rApexInner*cos(theta), ...
        rApexInner*sin(theta), ...
        'w', ...
        'EdgeColor', 'w', ...
        'LineWidth', 0.5, ...
        'Parent', h);

    % Anterior insertion point indicator
    % Boundary between anterior and anteroseptal segments in this orientation.
    thetaAIP = deg2rad(120);

    rTickOuter = rOuter + 0.055;
    rTickInner = rOuter - 0.075;

    plot( ...
        [rTickInner rTickOuter] * cos(thetaAIP), ...
        [rTickInner rTickOuter] * sin(thetaAIP), ...
        'k-', ...
        'LineWidth', 5.0, ...
        'Parent', h);

    plot( ...
        rTickOuter * cos(thetaAIP), ...
        rTickOuter * sin(thetaAIP), ...
        'ko', ...
        'MarkerFaceColor', 'k', ...
        'MarkerSize', 10, ...
        'Parent', h);

    % Colourbar
    cb = colorbar(h, 'FontSize', 18);

    if strlength(string(cbLabel)) > 0
        ylabel(cb, cbLabel, 'Interpreter', 'tex', 'FontSize', 18);
    end

    title(h, plotTitle, 'Interpreter', 'tex', 'FontSize', 24);

    % Add group legend
    addGroupLegend();

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

            faceColour = val2colour(vals(seg));

            % Base segment patch: metric value is encoded by fill colour.
            % Use a thin light boundary for all segments.
            patch( ...
                'XData', x, ...
                'YData', y, ...
                'FaceColor', faceColour, ...
                'EdgeColor', [0.92 0.92 0.92], ...
                'LineWidth', 3.0, ...
                'Parent', h);
            
            % Overlay group-specific outline using high-contrast monochrome styles.
            drawGroupOutline(x, y, segGroup(seg));

            % Segment value label
            thetaText = deg2rad((theta1 + theta2)/2);
            rText = (r0 + r1)/2;

            if isnan(vals(seg))
                labelStr = "NA";
                txtColour = [0.2 0.2 0.2];
            else
                labelStr = sprintf(valueFormat, vals(seg));
                txtColour = chooseTextColour(faceColour);
            end

            text( ...
                rText*cos(thetaText), ...
                rText*sin(thetaText), ...
                labelStr, ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'middle', ...
                'Color', txtColour, ...
                'FontSize', 18, ...
                'FontWeight', 'bold', ...
                'Parent', h);
        end
    end

    function c = val2colour(v)

        if isnan(v)
            c = [0.85 0.85 0.85]; % grey for missing metric values
        else
            t = (v - clim(1)) / (clim(2) - clim(1));
            t = max(0, min(1, t));
            idx = 1 + round(t * (nCol - 1));
            c = cmap(idx, :);
        end
    end

    function drawGroupOutline(x, y, g)
    % drawGroupOutline
    % Adds a high-contrast outline for segment group.
    %
    % Group coding:
    %   1 = Normal: no extra outline
    %   2 = WT+:    white halo + black dashed outline
    %   3 = LGE+:   white halo + black solid outline
    %
    % The white halo improves visibility on dark turbo colours.
    % The black line improves visibility on bright turbo colours.
    
        xClosed = [x, x(1)];
        yClosed = [y, y(1)];
    
        switch g
    
            case 1
                % Normal: no additional outline.
                return;
    
            case 2
                % WT+: white halo + black dashed outline.
                plot( ...
                    xClosed, yClosed, ...
                    '-', ...
                    'Color', [1 1 1], ...
                    'LineWidth', 6.0, ...
                    'Parent', h);
    
                plot( ...
                    xClosed, yClosed, ...
                    '--', ...
                    'Color', [0 0 0], ...
                    'LineWidth', 3.0, ...
                    'Parent', h);
    
            case 3
                % LGE+: white halo + black solid outline.
                plot( ...
                    xClosed, yClosed, ...
                    '-', ...
                    'Color', [1 1 1], ...
                    'LineWidth', 6.0, ...
                    'Parent', h);
    
                plot( ...
                    xClosed, yClosed, ...
                    '-', ...
                    'Color', [0 0 0], ...
                    'LineWidth', 3.0, ...
                    'Parent', h);
    
            otherwise
                % Unknown/missing group: grey dotted outline.
                plot( ...
                    xClosed, yClosed, ...
                    ':', ...
                    'Color', [0.2 0.2 0.2], ...
                    'LineWidth', 2.0, ...
                    'Parent', h);
        end
    end

    function txtColour = chooseTextColour(faceColour)

        luminance = 0.299*faceColour(1) + 0.587*faceColour(2) + 0.114*faceColour(3);

        if luminance > 0.55
            txtColour = [0 0 0];
        else
            txtColour = [1 1 1];
        end
    end

    function addGroupLegend()
    
        hold(h, 'on');
    
        p1 = plot(nan, nan, '-', ...
            'Color', [0.65 0.65 0.65], ...
            'LineWidth', 3.0);
    
        p2 = plot(nan, nan, '--', ...
            'Color', [0 0 0], ...
            'LineWidth', 3.0);
    
        p3 = plot(nan, nan, '-', ...
            'Color', [0 0 0], ...
            'LineWidth', 3.0);
    
        lgd = legend([p1 p2 p3], ...
            {'Normal', 'WT+', 'LGE+'}, ...
            'Location', 'southoutside', ...
            'Orientation', 'horizontal', ...
            'FontSize', 18);
    
        lgd.Box = 'off';
    end
end