for i = 1:length(allpos)

diaphragm = allpos(i).pos;

figure(1);
plot(diaphragm)
xlabel('Time (samples)')
ylabel('Diaphragm Position')
title('Diaphragm Motion Signal')

diaphragm_smooth = movmean(diaphragm, 10); % Smooth over 5 samples

%% breathing rate
peaks = findpeaks(diaphragm_smooth, 'MinPeakDistance', 18); % Find peaks (expiration)
num_breaths = length(peaks);
duration_minutes = length(diaphragm_smooth) * 0.1 / 60; % Sampling rate is 100ms = 0.1s
breathing_rate(i) = num_breaths / duration_minutes;

%% find peaks end-inspiration / end-expiration
% Find peaks (end-expiration)
[EE_values, EE_locs] = findpeaks(diaphragm_smooth, 'MinPeakDistance', 18); 

% Find troughs (end-inspiration)
[EI_values, EI_locs] = findpeaks(-diaphragm_smooth, 'MinPeakDistance', 18);
EI_values = -EI_values; % Convert back to positive values

% Plot results
figure(2);
plot(diaphragm_smooth);
hold on;
plot(EI_locs, EI_values, 'ro', 'MarkerFaceColor', 'r'); % Red circles for EI
plot(EE_locs, EE_values, 'bo', 'MarkerFaceColor', 'b'); % Blue circles for EE
xlabel('Time (samples)');
ylabel('Diaphragm Position');
title('Breathing Signal with End-Inspiration and End-Expiration');
legend('Smoothed Signal', 'End-Inspiration', 'End-Expiration');
hold off;

%% time spent in insp/exp
window_size = 35;  % Define window size for local threshold computation

% Compute moving baselines
baseline_high = movmax(diaphragm_smooth, window_size); % Moving max as local peak reference
baseline_low = movmin(diaphragm_smooth, window_size);  % Moving min as local trough reference

% Define adaptive threshold as a fraction of local range
threshold_factor = 0.1;  % Adjust sensitivity (10% of local range)
local_threshold = threshold_factor * (baseline_high - baseline_low);

% Identify end-inspiration periods (diaphragm near local max)
EE_mask = abs(diaphragm_smooth - baseline_high) < local_threshold;

% Identify end-expiration periods (diaphragm near local min)
EI_mask = abs(diaphragm_smooth - baseline_low) < local_threshold;

% Compute total time spent in each phase
EI_duration(i) = sum(EI_mask) * 0.1; % Convert samples to seconds
EE_duration(i) = sum(EE_mask) * 0.1; % Convert samples to seconds

fprintf('Time spent in End-Inspiration: %.2f seconds\n', EI_duration(i));
fprintf('Time spent in End-Expiration: %.2f seconds\n', EE_duration(i));

figure(3);
x = 1:length(diaphragm_smooth);

% Plot the original signal
plot(x, diaphragm_smooth, 'k', 'LineWidth', 1.2);

hold on;

% Overlay local threshold range (light shading)
fill([x, fliplr(x)], [baseline_high + local_threshold; flipud(baseline_high - local_threshold)], ...
     [1, 0.8, 0.8], 'FaceAlpha', 0.3, 'EdgeColor', 'none'); % Light red for EI threshold

fill([x, fliplr(x)], [baseline_low + local_threshold; flipud(baseline_low - local_threshold)], ...
     [0.8, 0.8, 1], 'FaceAlpha', 0.3, 'EdgeColor', 'none'); % Light blue for EE threshold


% Shade EI regions
EI_regions = find(EI_mask);
for j = 1:length(EI_regions)
    fill([EI_regions(j), EI_regions(j), EI_regions(j)+1, EI_regions(j)+1], ...
         [min(diaphragm_smooth), max(diaphragm_smooth), max(diaphragm_smooth), min(diaphragm_smooth)], ...
         'r', 'FaceAlpha', 0.2, 'EdgeColor', 'none'); % Transparent red for EI
end

% Shade EE regions
EE_regions = find(EE_mask);
for j = 1:length(EE_regions)
    fill([EE_regions(j), EE_regions(j), EE_regions(j)+1, EE_regions(j)+1], ...
         [min(diaphragm_smooth), max(diaphragm_smooth), max(diaphragm_smooth), min(diaphragm_smooth)], ...
         'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none'); % Transparent blue for EE
end

% Labels and legend
xlabel('Time (samples)');
ylabel('Diaphragm Position');
title('End-Inspiration & End-Expiration Detection with Adaptive Threshold');
legend('Diaphragm Signal', 'End-Inspiration Threshold', 'End-Expiration Threshold');
hold off;

%% mean insp/exp time
% Define adaptive threshold as a fraction of local range
threshold_factor = 0.5;  % Adjust sensitivity (10% of local range)
local_threshold = threshold_factor * (baseline_high - baseline_low);

% Identify end-inspiration periods (diaphragm near local max)
EE_halfmask = abs(diaphragm_smooth - baseline_high) < local_threshold;

% Identify end-expiration periods (diaphragm near local min)
EI_halfmask = abs(diaphragm_smooth - baseline_low) < local_threshold;

insp_temp = diff([0;EI_halfmask;0]);
exp_temp = diff([0;EE_halfmask;0]);

s = find(insp_temp==1);
f = find(insp_temp==-1);
insp_durations = (f-s)*0.1;
s = find(exp_temp==1);
f = find(exp_temp==-1);
exp_durations = (f-s)*0.1;

mean_insp_time(i) = mean(insp_durations);
mean_exp_time(i) = mean(exp_durations);

fprintf('Mean Inspiratory Time: %.2f seconds\n', mean_insp_time(i));
fprintf('Mean Expiratory Time: %.2f seconds\n', mean_exp_time(i));

%% insp/exp ratio
IE_ratio(i) = mean_insp_time(i) / mean_exp_time(i);
fprintf('Inspiratory-Expiratory Ratio (I:E): %.2f\n', IE_ratio(i));

%% breathing-variability
insp_variability(i) = std(insp_durations);
exp_variability(i) = std(exp_durations);

fprintf('Inspiratory Variability (SD): %.2f seconds\n', insp_variability(i));
fprintf('Expiratory Variability (SD): %.2f seconds\n', exp_variability(i));

end

for i = [3 5 7 9 11 13 15 17]
    insp_variability(i) = mean(insp_variability(i:i+1));
    exp_variability(i) = mean(exp_variability(i:i+1));
    IE_ratio(i) = mean(IE_ratio(i:i+1));
    mean_insp_time(i) = mean(mean_insp_time(i:i+1));
    mean_exp_time(i) = mean(mean_exp_time(i:i+1));
    EI_duration(i) = mean(EI_duration(i:i+1));
    EE_duration(i) = mean(EE_duration(i:i+1));
    breathing_rate(i) = mean(breathing_rate(i:i+1));
end
insp_variability([4 6 8 10 12 14 16 18]) = [];
exp_variability([4 6 8 10 12 14 16 18]) = [];
IE_ratio([4 6 8 10 12 14 16 18]) = [];
mean_insp_time([4 6 8 10 12 14 16 18]) = [];
mean_exp_time([4 6 8 10 12 14 16 18]) = [];
EI_duration([4 6 8 10 12 14 16 18]) = [];
EE_duration([4 6 8 10 12 14 16 18]) = [];
breathing_rate([4 6 8 10 12 14 16 18]) = [];