%% P1
%{
P1vals = [
1.67	0.41	-0.85	53.0	2
1.72	0.30	-0.83	44.9	3
1.79	0.43	-0.72	41.4	3
2.08	0.53	-0.82	53.3	1
1.69	0.36	-1.02	44.7	1
1.65	0.34	-1.44	50.1	2
1.58	0.41	-0.65	69.1	3
1.54	0.35	-1.10	48.5	3
1.52	0.35	-1.45	42.2	3
1.51	0.34	-1.51	56.9	3
1.57	0.31	-1.04	44.7	3
1.61	0.32	-0.54	60.6	3
1.73	0.22	-0.85	50.9	3
1.81	0.22	-0.89	56.6	3
1.86	0.23	-0.75	43.1	3
1.98	0.21	-1.21	40.6	3
];
%}

figure('Color','w');
plotAHA16BullseyeGroups(P1vals(:,1), P1vals(:,5), [0 2.5], "turbo", ...
    "MD", "MD (\mum^2/ms)", "%.1f");
hgexport(gcf, 'MD_P1_bullseye.svg', hgexport('factorystyle'), 'Format', 'svg');

figure('Color','w');
plotAHA16BullseyeGroups(P1vals(:,2), P1vals(:,5), [0 1], "turbo", ...
    "FA", "FA", "%.2f");
hgexport(gcf, 'FA_P1_bullseye.svg', hgexport('factorystyle'), 'Format', 'svg');

figure('Color','w');
plotAHA16BullseyeGroups(P1vals(:,3), P1vals(:,5), [-1.6 0], "turbo", ...
    "HAg", "HAg (\circ/%_d)", "%.1f");
hgexport(gcf, 'HAg_P1_bullseye.svg', hgexport('factorystyle'), 'Format', 'svg');

figure('Color','w');
plotAHA16BullseyeGroups(P1vals(:,4), P1vals(:,5), [0 90], brewermap([],"-RdBu"), ...
    "|E2A|", "|E2A| (\circ)", "%.1f");
hgexport(gcf, 'E2A_P1_bullseye.svg', hgexport('factorystyle'), 'Format', 'svg');

%% P3
%{
P3vals = [
1.87	0.33	-0.87	54.1	1
1.81	0.37	-0.52	39.7	3
1.74	0.40	-1.09	59.7	1
2.12	0.40	-1.03	47.5	1
2.44	0.35	-1.08	45.2	1
2.46	0.32	-0.64	37.7	1
1.85	0.31	-1.15	51.6	1
1.93	0.26	-0.66	58.3	3
1.56	0.30	-0.83	58.8	3
1.78	0.39	-1.07	47.3	1
2.12	0.48	-1.04	42.6	1
1.92	0.43	-0.76	33.0	1
2.27	0.48	-0.78	46.9	3
2.44	0.43	-1.39	57.9	3
2.33	0.44	-1.04	39.4	1
2.45	0.41	-0.55	32.0	1
];
%}

figure('Color','w');
plotAHA16BullseyeGroups(P3vals(:,1), P3vals(:,5), [0 2.5], "turbo", ...
    "MD", "MD (\mum^2/ms)", "%.1f");
hgexport(gcf, 'MD_P3_bullseye.svg', hgexport('factorystyle'), 'Format', 'svg');

figure('Color','w');
plotAHA16BullseyeGroups(P3vals(:,2), P3vals(:,5), [0 1], "turbo", ...
    "FA", "FA", "%.2f");
hgexport(gcf, 'FA_P3_bullseye.svg', hgexport('factorystyle'), 'Format', 'svg');

figure('Color','w');
plotAHA16BullseyeGroups(P3vals(:,3), P3vals(:,5), [-1.6 0], "turbo", ...
    "HAg", "HAg (\circ/%_d)", "%.1f");
hgexport(gcf, 'HAg_P3_bullseye.svg', hgexport('factorystyle'), 'Format', 'svg');

figure('Color','w');
plotAHA16BullseyeGroups(P3vals(:,4), P3vals(:,5), [0 90], brewermap([],"-RdBu"), ...
    "|E2A|", "|E2A| (\circ)", "%.1f");
hgexport(gcf, 'E2A_P3_bullseye.svg', hgexport('factorystyle'), 'Format', 'svg');

%% P4
%{
P4vals = [
1.91	0.39	-1.20	40.8	2
1.85	0.42	-1.52	41.0	1
2.00	0.41	-1.04	44.1	1
2.05	0.43	-0.92	46.9	1
2.12	0.40	-0.99	43.1	3
1.74	0.44	-1.20	39.2	3
1.86	0.46	-0.89	32.5	2
2.32	0.52	-1.10	34.5	2
2.53	0.55	-0.96	37.1	2
2.06	0.64	-1.14	39.8	2
1.80	0.59	-1.01	30.6	2
1.90	0.52	-1.46	36.8	3
1.90	0.41	-0.95	40.8	1
2.40	0.42	-0.90	45.7	1
1.61	0.57	-0.99	45.4	1
1.99	0.49	-1.04	36.1	1
];
%}

figure('Color','w');
plotAHA16BullseyeGroups(P4vals(:,1), P4vals(:,5), [0 2.5], "turbo", ...
    "MD", "MD (\mum^2/ms)", "%.1f");
hgexport(gcf, 'MD_P4_bullseye.svg', hgexport('factorystyle'), 'Format', 'svg');

figure('Color','w');
plotAHA16BullseyeGroups(P4vals(:,2), P4vals(:,5), [0 1], "turbo", ...
    "FA", "FA", "%.2f");
hgexport(gcf, 'FA_P4_bullseye.svg', hgexport('factorystyle'), 'Format', 'svg');

figure('Color','w');
plotAHA16BullseyeGroups(P4vals(:,3), P4vals(:,5), [-1.6 0], "turbo", ...
    "HAg", "HAg (\circ/%_d)", "%.1f");
hgexport(gcf, 'HAg_P4_bullseye.svg', hgexport('factorystyle'), 'Format', 'svg');

figure('Color','w');
plotAHA16BullseyeGroups(P4vals(:,4), P4vals(:,5), [0 90], brewermap([],"-RdBu"), ...
    "|E2A|", "|E2A| (\circ)", "%.1f");
hgexport(gcf, 'E2A_P4_bullseye.svg', hgexport('factorystyle'), 'Format', 'svg');

%% P6
%{
P6vals = [
1.84	0.45	-1.09	41.0	3
1.80	0.36	-1.22	53.3	3
2.01	0.48	-1.34	49.0	1
2.64	0.53	-0.88	37.4	1
2.05	0.62	-0.92	43.5	1
2.06	0.55	-1.14	41.6	1
1.93	0.30	-0.86	36.2	3
1.64	0.34	-0.79	42.1	3
1.77	0.47	-0.74	48.7	1
2.09	0.52	-1.08	41.7	1
1.76	0.57	-0.95	40.6	1
1.72	0.47	-1.28	37.7	1
1.67	0.32	-0.88	54.1	1
1.76	0.32	-0.84	56.0	1
1.51	0.46	-1.35	45.6	1
1.71	0.32	-1.00	39.3	1
];
%}

figure('Color','w');
plotAHA16BullseyeGroups(P6vals(:,1), P6vals(:,5), [0 2.5], "turbo", ...
    "MD", "MD (\mum^2/ms)", "%.1f");
hgexport(gcf, 'MD_P6_bullseye.svg', hgexport('factorystyle'), 'Format', 'svg');

figure('Color','w');
plotAHA16BullseyeGroups(P6vals(:,2), P6vals(:,5), [0 1], "turbo", ...
    "FA", "FA", "%.2f");
hgexport(gcf, 'FA_P6_bullseye.svg', hgexport('factorystyle'), 'Format', 'svg');

figure('Color','w');
plotAHA16BullseyeGroups(P6vals(:,3), P6vals(:,5), [-1.6 0], "turbo", ...
    "HAg", "HAg (\circ/%_d)", "%.2f");
hgexport(gcf, 'HAg_P6_bullseye.svg', hgexport('factorystyle'), 'Format', 'svg');

figure('Color','w');
plotAHA16BullseyeGroups(P6vals(:,4), P6vals(:,5), [0 90], brewermap([],"-RdBu"), ...
    "|E2A|", "|E2A| (\circ)", "%.1f");
hgexport(gcf, 'E2A_P6_bullseye.svg', hgexport('factorystyle'), 'Format', 'svg');