clear
close all

%% load data
valueset = (1:4); catnames = {'BH','Gated','1-Nav','Multi-Nav'};
valueset2 = (1:6); catnames2 = {'A','AS','IS','I','IL','AL'};
dataxlsx = 'dti_20220810.xlsx';

bAll = readtable(dataxlsx,'Sheet','Sheet2');
bAll.ID = categorical(bAll.ID);
bAll.tech = categorical(bAll.tech,valueset,catnames);
bAll.lowB = categorical(bAll.lowB);
bAll.highB = categorical(bAll.highB);
bAll.segment = categorical(bAll.segment,valueset2,catnames2);
bAll.MD = bAll.MD * 1e3;
bAll.MDstd = bAll.MDstd * 1e3;
bAll.AD = bAll.AD * 1e3;
bAll.ADstd = bAll.ADstd * 1e3;
bAll.RD = bAll.RD * 1e3;
bAll.RDstd = bAll.RDstd * 1e3;

%% change lowB from categorical to continuous
ind = find(bAll.lowB == "b015");
bAll.lowB1(ind) = repmat(15,size(ind));
ind = find(bAll.lowB == "b050");
bAll.lowB1(ind) = repmat(50,size(ind));
ind = find(bAll.lowB == "b350");
bAll.lowB1(ind) = repmat(350,size(ind));

bAll.lowB15 = (bAll.lowB1 - 15)/10; %shift so zero at lowB = 15

%% change highB from categorical to continuous
ind = find(bAll.highB == "b350");
bAll.highB1(ind) = repmat(350,size(ind));
ind = find(bAll.highB == "b450");
bAll.highB1(ind) = repmat(450,size(ind));
ind = find(bAll.highB == "b550");
bAll.highB1(ind) = repmat(550,size(ind));
ind = find(bAll.highB == "b650");
bAll.highB1(ind) = repmat(650,size(ind));

bAll.highB350 = (bAll.highB1 - 350)/100; %shift so zero at highB = 350

%%
fprintf('********* all ref b-value 15,50,350 s/mm^2 *******\n');

%% find outliers for all
tbl = bAll;
Z = zscore(tbl.MD);
outliers = find(abs(Z)>4);
tbl.MD(outliers) = nan;

Z = zscore(tbl.FA);
outliers = find(abs(Z)>4);
tbl.FA(outliers) = nan;

Z = zscore(tbl.AD);
outliers = find(abs(Z)>4);
tbl.AD(outliers) = nan;

Z = zscore(tbl.RD);
outliers = find(abs(Z)>4);
tbl.RA(outliers) = nan;

Z = zscore(tbl.HAg);
outliers = find(abs(Z)>4);
tbl.HAg(outliers) = nan;

%% this makes a box and scatter plot of MD, AD, RD, FA, and HAg values
jamount = 40/3;
jitter = jamount*(rand(size(tbl.highB1))-0.5); %add jitter so that the points aren't on top of one another
highb_scatter = tbl.highB1+jitter+25;

tech_num = ones(size(tbl,1),1);
tech_num(tbl.tech == 'Gated') = 2; tech_num(tbl.tech == '1-Nav') = 3; tech_num(tbl.tech == 'Multi-Nav') = 4; %this is to get around the fact that gscatter can't properly handle categorical variables
highb_box = tbl.highB1 + 9*(2/3*(tech_num-1)-1);

c = 1/255*[[68 114 196];[165 165 165];[255 192 0];[237 125 49]];

%% MD
%{
m = min(tbl.MD);M = max(tbl.MD);
buffer = 0.01*(M-m);
m = m-buffer;M = M+buffer;
figure
ind = find(bAll.lowB=='b015');
tbl2 = tbl(ind,:);
subplot(1,3,1); %first we print the MD results
gscatter(highb_scatter(ind),tbl2.MD,{tbl2.tech},c,{},15,'off','','');
hold on
boxplot(tbl2.MD,{tbl2.highB1 tbl2.tech},'Positions',highb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[],'Whisker',1);
set(gca,'XTick',350:100:650);set(gca,'XTickLabel',{'350';'450';'550';'650'});
hold off
h=gca;h.FontSize = 8; h.Box = false;
h.Title.String = sprintf('b_{ref} = 15 s/mm^2');
h.XLabel.String = sprintf('b_{high} (s/mm^2)');h.YLabel.String = sprintf('MD (\x03bcm^2/ms)');
h.YLim = [m M];h.XLim = [300 700];

ind = find(bAll.lowB=='b050');
tbl2 = tbl(ind,:);
subplot(1,3,2);
gscatter(highb_scatter(ind),tbl2.MD,{tbl2.tech},c,{},15,'off','','');
hold on
boxplot(tbl2.MD,{tbl2.highB1 tbl2.tech},'Positions',highb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[],'Whisker',1);
set(gca,'XTick',350:100:650);set(gca,'XTickLabel',{'350';'450';'550';'650'});
hold off
h=gca;h.FontSize = 8; h.Box = false;
h.Title.String = sprintf('b_{ref} = 50 s/mm^2');
h.XLabel.String = sprintf('b_{high} (s/mm^2)');
h.YLim = [m M];h.XLim = [300 700];

ind = find(bAll.lowB=='b350');
tbl2 = tbl(ind,:);
subplot(1,3,3);
gscatter(highb_scatter(ind),tbl2.MD,{tbl2.tech},c,{},15,'off','','');
hold on
boxplot(tbl2.MD,{tbl2.highB1 tbl2.tech},'Positions',highb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[],'Whisker',1);
set(gca,'XTick',550:100:650);set(gca,'XTickLabel',{'550';'650'});
hold off
h=gca;h.FontSize = 8; h.Box = false;
h.Title.String = sprintf('b_{ref} = 350 s/mm^2');
h.XLabel.String = sprintf('b_{high} (s/mm^2)');
h.YLim = [m M];h.XLim = [500 700];
%}

%% FA
%{
m = min(tbl.FA);M = max(tbl.FA);
buffer = 0.01*(M-m);
m = m-buffer;M = M+buffer;
figure
ind = find(bAll.lowB=='b015');
tbl2 = tbl(ind,:);
subplot(1,3,1);
gscatter(highb_scatter(ind),tbl2.FA,{tbl2.tech},c,{},15,'off','','');
hold on
boxplot(tbl2.FA,{tbl2.highB1 tbl2.tech},'Positions',highb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[],'Whisker',1);
set(gca,'XTick',350:100:650);set(gca,'XTickLabel',{'350';'450';'550';'650'});
hold off
h=gca;h.FontSize = 8; h.Box = false;
h.Title.String = sprintf('b_{ref} = 15 s/mm^2');
h.XLabel.String = sprintf('b_{high} (s/mm^2)');h.YLabel.String = sprintf('FA');
h.YLim = [m M];h.XLim = [300 700];

ind = find(bAll.lowB=='b050');
tbl2 = tbl(ind,:);
subplot(1,3,2);
gscatter(highb_scatter(ind),tbl2.FA,{tbl2.tech},c,{},15,'off','','');
hold on
boxplot(tbl2.FA,{tbl2.highB1 tbl2.tech},'Positions',highb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[],'Whisker',1);
set(gca,'XTick',350:100:650);set(gca,'XTickLabel',{'350';'450';'550';'650'});
hold off
h=gca;h.FontSize = 8; h.Box = false;
h.Title.String = sprintf('b_{ref} = 50 s/mm^2');
h.XLabel.String = sprintf('b_{high} (s/mm^2)');
h.YLim = [m M];h.XLim = [300 700];

ind = find(bAll.lowB=='b350');
tbl2 = tbl(ind,:);
subplot(1,3,3);
gscatter(highb_scatter(ind),tbl2.FA,{tbl2.tech},c,{},15,'off','','');
hold on
boxplot(tbl2.FA,{tbl2.highB1 tbl2.tech},'Positions',highb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[],'Whisker',1);
set(gca,'XTick',550:100:650);set(gca,'XTickLabel',{'550';'650'});
hold off
h=gca;h.FontSize = 8; h.Box = false;
h.Title.String = sprintf('b_{ref} = 350 s/mm^2');
h.XLabel.String = sprintf('b_{high} (s/mm^2)');
h.YLim = [m M];h.XLim = [500 700];
%}

%% AD
%{
m = min(tbl.AD);M = max(tbl.AD);
buffer = 0.01*(M-m);
m = m-buffer;M = M+buffer;
figure
ind = find(bAll.lowB=='b015');
tbl2 = tbl(ind,:);
subplot(1,3,1);
gscatter(highb_scatter(ind),tbl2.AD,{tbl2.tech},c,{},15,'off','','');
hold on
boxplot(tbl2.AD,{tbl2.highB1 tbl2.tech},'Positions',highb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[],'Whisker',1);
set(gca,'XTick',350:100:650);set(gca,'XTickLabel',{'350';'450';'550';'650'});
hold off
h=gca;h.FontSize = 8; h.Box = false;
h.Title.String = sprintf('b_{ref} = 15 s/mm^2');
h.XLabel.String = sprintf('b_{high} (s/mm^2)');h.YLabel.String = sprintf('MD (\x03bcm^2/ms)');
h.YLim = [m M];h.XLim = [300 700];

ind = find(bAll.lowB=='b050');
tbl2 = tbl(ind,:);
subplot(1,3,2);
gscatter(highb_scatter(ind),tbl2.AD,{tbl2.tech},c,{},15,'off','','');
hold on
boxplot(tbl2.AD,{tbl2.highB1 tbl2.tech},'Positions',highb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[],'Whisker',1);
set(gca,'XTick',350:100:650);set(gca,'XTickLabel',{'350';'450';'550';'650'});
hold off
h=gca;h.FontSize = 8; h.Box = false;
h.Title.String = sprintf('b_{ref} = 50 s/mm^2');
h.XLabel.String = sprintf('b_{high} (s/mm^2)');
h.YLim = [m M];h.XLim = [300 700];

ind = find(bAll.lowB=='b350');
tbl2 = tbl(ind,:);
subplot(1,3,3);
gscatter(highb_scatter(ind),tbl2.AD,{tbl2.tech},c,{},15,'off','','');
hold on
boxplot(tbl2.AD,{tbl2.highB1 tbl2.tech},'Positions',highb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[],'Whisker',1);
set(gca,'XTick',550:100:650);set(gca,'XTickLabel',{'550';'650'});
hold off
h=gca;h.FontSize = 8; h.Box = false;
h.Title.String = sprintf('b_{ref} = 350 s/mm^2');
h.XLabel.String = sprintf('b_{high} (s/mm^2)');
h.YLim = [m M];h.XLim = [500 700];
%}

%% RD
%{
m = min(tbl.RD);M = max(tbl.RD);
buffer = 0.01*(M-m);
m = m-buffer;M = M+buffer;
figure
ind = find(bAll.lowB=='b015');
tbl2 = tbl(ind,:);
subplot(1,3,1);
gscatter(highb_scatter(ind),tbl2.RD,{tbl2.tech},c,{},15,'off','','');
hold on
boxplot(tbl2.RD,{tbl2.highB1 tbl2.tech},'Positions',highb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[],'Whisker',1);
set(gca,'XTick',350:100:650);set(gca,'XTickLabel',{'350';'450';'550';'650'});
hold off
h=gca;h.FontSize = 8; h.Box = false;
h.Title.String = sprintf('b_{ref} = 15 s/mm^2');
h.XLabel.String = sprintf('b_{high} (s/mm^2)');h.YLabel.String = sprintf('MD (\x03bcm^2/ms)');
h.YLim = [m M];h.XLim = [300 700];

ind = find(bAll.lowB=='b050');
tbl2 = tbl(ind,:);
subplot(1,3,2);
gscatter(highb_scatter(ind),tbl2.RD,{tbl2.tech},c,{},15,'off','','');
hold on
boxplot(tbl2.RD,{tbl2.highB1 tbl2.tech},'Positions',highb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[],'Whisker',1);
set(gca,'XTick',350:100:650);set(gca,'XTickLabel',{'350';'450';'550';'650'});
hold off
h=gca;h.FontSize = 8; h.Box = false;
h.Title.String = sprintf('b_{ref} = 50 s/mm^2');
h.XLabel.String = sprintf('b_{high} (s/mm^2)');
h.YLim = [m M];h.XLim = [300 700];

ind = find(bAll.lowB=='b350');
tbl2 = tbl(ind,:);
subplot(1,3,3);
gscatter(highb_scatter(ind),tbl2.RD,{tbl2.tech},c,{},15,'off','','');
hold on
boxplot(tbl2.RD,{tbl2.highB1 tbl2.tech},'Positions',highb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[],'Whisker',1);
set(gca,'XTick',550:100:650);set(gca,'XTickLabel',{'550';'650'});
hold off
h=gca;h.FontSize = 8; h.Box = false;
h.Title.String = sprintf('b_{ref} = 350 s/mm^2');
h.XLabel.String = sprintf('b_{high} (s/mm^2)');
h.YLim = [m M];h.XLim = [500 700];
%}

%% HAg
%{
m = min(tbl.HAg);M = max(tbl.HAg);
buffer = 0.01*(M-m);
m = m-buffer;M = M+buffer;
figure
ind = find(bAll.lowB=='b015');
tbl2 = tbl(ind,:);
subplot(1,3,1);
gscatter(highb_scatter(ind),tbl2.HAg,{tbl2.tech},c,{},15,'off','','');
hold on
boxplot(tbl2.HAg,{tbl2.highB1 tbl2.tech},'Positions',highb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[],'Whisker',1);
set(gca,'XTick',350:100:650);set(gca,'XTickLabel',{'350';'450';'550';'650'});
hold off
h=gca;h.FontSize = 8; h.Box = false;
h.Title.String = sprintf('b_{ref} = 15 s/mm^2');
h.XLabel.String = sprintf('b_{high} (s/mm^2)');h.YLabel.String = sprintf('HAg (\x00b0/%%)');
h.YLim = [m M];h.XLim = [300 700];

ind = find(bAll.lowB=='b050');
tbl2 = tbl(ind,:);
subplot(1,3,2);
gscatter(highb_scatter(ind),tbl2.HAg,{tbl2.tech},c,{},15,'off','','');
hold on
boxplot(tbl2.HAg,{tbl2.highB1 tbl2.tech},'Positions',highb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[],'Whisker',1);
set(gca,'XTick',350:100:650);set(gca,'XTickLabel',{'350';'450';'550';'650'});
hold off
h=gca;h.FontSize = 8; h.Box = false;
h.Title.String = sprintf('b_{ref} = 50 s/mm^2');
h.XLabel.String = sprintf('b_{high} (s/mm^2)');
h.YLim = [m M];h.XLim = [300 700];

ind = find(bAll.lowB=='b350');
tbl2 = tbl(ind,:);
subplot(1,3,3);
gscatter(highb_scatter(ind),tbl2.HAg,{tbl2.tech},c,{},15,'off','','');
hold on
boxplot(tbl2.HAg,{tbl2.highB1 tbl2.tech},'Positions',highb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[],'Whisker',1);
set(gca,'XTick',550:100:650);set(gca,'XTickLabel',{'550';'650'});
hold off
h=gca;h.FontSize = 8; h.Box = false;
h.Title.String = sprintf('b_{ref} = 350 s/mm^2');
h.XLabel.String = sprintf('b_{high} (s/mm^2)');
h.YLim = [m M];h.XLim = [500 700];
%}