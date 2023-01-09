function boxplots(tbl,type,outl_sd,islme)

switch type
    case {'MD','AD','RD'}
        type2 = type;
        unit = sprintf('\x03bcm^2/ms');
        format = [type ' (' unit ')'];
    case 'FA'
        type2 = type;
        format = type;
    case 'HAg'
        type2 = type;
        unit = sprintf('\x00b0/%%');
        format = [type ' (' unit ')'];
    case 'HAd'
        type2 = type;
        unit = sprintf('\x00b0/mm');
        format = [type ' (' unit ')'];
end

%finding outliers
Z = zscore(tbl.(type));
outliers = find(abs(Z)>outl_sd);
% disp('Outliers');disp(tbl(outliers,:));

if islme
    type2 = ['lme' type];
    format = ['Fitted ' format];
    outliers = [];
end

c = 1/255*[[68 114 196];[165 165 165];[255 192 0];[237 125 49]];

%% boxplots
tbl.(type)(outliers) = nan;

tech_num = ones(size(tbl,1),1);
tech_num(tbl.tech == 'Gated') = 2; tech_num(tbl.tech == '1-Nav') = 3; tech_num(tbl.tech == 'Multi-Nav') = 4; %this is to get around the fact that gscatter can't properly handle categorical variables

m = min(tbl.(type));M = max(tbl.(type));
buffer = 0.0125*(M-m);
m = m-buffer;M = M+buffer;

%% tech
jamount = 1/4;
jitter = jamount*(rand(height(tbl),1)-0.5); %add jitter so that the points aren't on top of one another

figure;
tech_scatter = tech_num+jitter+1/4;
g = gscatter(tech_scatter,tbl.(type),{tbl.tech},c,'o',5,'off','','');
for i = 1:length(g)
    set(g(i),'MarkerEdgeColor','none','MarkerFaceColor',c(i,:));drawnow;
    set(g(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c(i,:)';0.5]));
end
hold on
boxplot(tbl.(type),{tbl.tech},'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[]);
hold off
h=gca;h.Title.String = sprintf('%s by tech',type); h.Box = false;
set(gca,'XTick',1:4);set(gca,'XTickLabel',{'BH';'Gated';'1-Nav';'Multi-Nav'});
h.YLim = [m M];h.YGrid = 'on';set(h.YGridHandle,'LineWidth',2);
h.YLabel.String = sprintf('%s',format); h.XLabel.String = sprintf('Technique');
h.FontSize = 15;h.TitleFontSizeMultiplier = 1.5;h.LabelFontSizeMultiplier = 1.5;
h.Parent.Name = sprintf('%s_tech',type2);h.Parent.Tag = num2str(9/8);

set(findobj(gcf,'Type','line','Tag','Box'),'LineWidth',10);
set(findobj(gcf,'Type','line','Tag','Whisker'),'LineWidth',3);

%% tech and lowb
jamount = 10;
jitter = jamount*(rand(height(tbl),1)-0.5); %add jitter so that the points aren't on top of one another

figure;
lowB1 = tbl.lowB1;lowB1 = lowB1-200*(lowB1>100); %reduce gap between 50 and 350

lowb_scatter = lowB1+jitter+20;
lowb_scatter(lowB1==15) = lowb_scatter(lowB1==15)-40; %moves scatter to left side of 15
lowb_box = lowB1 + 9*(2/3*(tech_num-1)-1);
g = gscatter(lowb_scatter,tbl.(type),{tbl.tech},c,'o',5,'off','','');
for i = 1:length(g)
    set(g(i),'MarkerEdgeColor','none','MarkerFaceColor',c(i,:));drawnow;
    set(g(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c(i,:)';0.5]));
end
hold on
boxplot(tbl.(type),{lowB1 tbl.tech},'Positions',lowb_box,'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[]);
hold off
h=gca;h.Title.String = sprintf('%s by tech and low b-value',type); h.Box = false;
set(gca,'XTick',[15 50:100:150]);set(gca,'XTickLabel',{'15';'50';'350'});
h.YLim = [m M]; h.XLim = [-15 200];h.YGrid = 'on';set(h.YGridHandle,'LineWidth',2);
h.YLabel.String = sprintf('%s',format); h.XLabel.String = sprintf('b_{low} (s/mm^2)');
h.FontSize = 15;h.TitleFontSizeMultiplier = 1.5;h.LabelFontSizeMultiplier = 1.5;
h.Parent.Name = sprintf('%s_lowb',type2);h.Parent.Tag = num2str(9/8);

set(findobj(gcf,'Type','line','Tag','Box'),'LineWidth',10);
set(findobj(gcf,'Type','line','Tag','Whisker'),'LineWidth',3);

figure;
ind = find(tbl.highB=='b350');
tbl2 = tbl(ind,:);
subplot(1,4,1);
g = gscatter(lowb_scatter(ind),tbl2.(type),{tbl2.tech},c,'o',5,'off','','');
for i = 1:length(g)
    set(g(i),'MarkerEdgeColor','none','MarkerFaceColor',c(i,:));drawnow;
    set(g(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c(i,:)';0.5]));
end
hold on
boxplot(tbl2.(type),{lowB1(ind) tbl2.tech},'Positions',lowb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[],'Width',0.5);
hold off
h=gca;h.Box = false;
set(gca,'XTick',[15 50]);set(gca,'XTickLabel',{'15';'50'});
% h.Title.String = sprintf('b_{high} = 350 s/mm^2');
% h.YLabel.String = sprintf('%s',format);%h.XLabel.String = sprintf('b_{low} (s/mm^2)');
h.FontSize = 15;
h.YLim = [m M];h.XLim = [-15 100];h.YGrid = 'on';set(h.YGridHandle,'LineWidth',2);
w = 0; width = 3/20; h.OuterPosition = [w 0 width 1];

ind = find(tbl.highB=='b450');
tbl2 = tbl(ind,:);
subplot(1,4,2);
g = gscatter(lowb_scatter(ind),tbl2.(type),{tbl2.tech},c,'o',5,'off','','');
for i = 1:length(g)
    set(g(i),'MarkerEdgeColor','none','MarkerFaceColor',c(i,:));drawnow;
    set(g(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c(i,:)';0.5]));
end
hold on
boxplot(tbl2.(type),{lowB1(ind) tbl2.tech},'Positions',lowb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[]);
hold off
h=gca;h.Box = false;
set(gca,'XTick',[15 50]);set(gca,'XTickLabel',{'15';'50'});
% h.Title.String = sprintf('b_{high} = 450 s/mm^2');
% h.XLabel.String = sprintf('b_{low} (s/mm^2)');%h.YLabel.String = sprintf('%s',format);
h.FontSize = 15;
h.YLim = [m M];h.XLim = [-15 100];h.YGrid = 'on';set(h.YGridHandle,'LineWidth',2);
w = w+width; width = 3/20; h.OuterPosition = [w 0 width 1];

ind = find(tbl.highB=='b550');
tbl2 = tbl(ind,:);
subplot(1,4,3);
g = gscatter(lowb_scatter(ind),tbl2.(type),{tbl2.tech},c,'o',5,'off','','');
for i = 1:length(g)
    set(g(i),'MarkerEdgeColor','none','MarkerFaceColor',c(i,:));drawnow;
    set(g(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c(i,:)';0.5]));
end
hold on
boxplot(tbl2.(type),{lowB1(ind) tbl2.tech},'Positions',lowb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[]);
hold off
h=gca;h.Box = false;
set(gca,'XTick',[15 50:100:150]);set(gca,'XTickLabel',{'15';'50';'350'});
% h.Title.String = sprintf('b_{high} = 550 s/mm^2');
% h.XLabel.String = sprintf('b_{low} (s/mm^2)');%h.YLabel.String = sprintf('%s',format);
h.FontSize = 15;
h.YLim = [m M];h.XLim = [-15 200];h.YGrid = 'on';set(h.YGridHandle,'LineWidth',2);
w = w+width; width = 7/20; h.OuterPosition = [w 0 width 1];

ind = find(tbl.highB=='b650');
tbl2 = tbl(ind,:);
subplot(1,4,4);
g = gscatter(lowb_scatter(ind),tbl2.(type),{tbl2.tech},c,'o',5,'off','','');
for i = 1:length(g)
    set(g(i),'MarkerEdgeColor','none','MarkerFaceColor',c(i,:));drawnow;
    set(g(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c(i,:)';0.5]));
end
hold on
boxplot(tbl2.(type),{lowB1(ind) tbl2.tech},'Positions',lowb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[]);
hold off
h=gca;h.Box = false;
set(gca,'XTick',[15 50:100:150]);set(gca,'XTickLabel',{'15';'50';'350'});
% h.Title.String = sprintf('b_{high} = 650 s/mm^2');
% h.XLabel.String = sprintf('b_{low} (s/mm^2)');%h.YLabel.String = sprintf('%s',format);
h.FontSize = 15;
h.YLim = [m M];h.XLim = [-15 200];h.YGrid = 'on';set(h.YGridHandle,'LineWidth',2);
w = w+width; width = 7/20; h.OuterPosition = [w 0 width 1];

set(findobj(gcf,'Type','line','Tag','Box'),'LineWidth',8);
set(findobj(gcf,'Type','line','Tag','Whisker'),'LineWidth',3);

h.Parent.Name = sprintf('%s_lowb_highb',type2);h.Parent.Tag = num2str(16/5);

%% tech and hihgb
jamount = 10;
jitter = jamount*(rand(height(tbl),1)-0.5); %add jitter so that the points aren't on top of one another

figure;
highb_scatter = tbl.highB1+jitter+20;
highb_box = tbl.highB1 + 9*(2/3*(tech_num-1)-1);
g = gscatter(highb_scatter,tbl.(type),{tbl.tech},c,'o',5,'off','','');
for i = 1:length(g)
    set(g(i),'MarkerEdgeColor','none','MarkerFaceColor',c(i,:));drawnow;
    set(g(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c(i,:)';0.5]));
end
hold on
boxplot(tbl.(type),{tbl.highB1 tbl.tech},'Positions',highb_box,'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[]);
hold off
h=gca;h.Title.String = sprintf('%s by tech and high b-value',type); h.Box = false;
set(gca,'XTick',350:100:650);set(gca,'XTickLabel',{'350';'450';'550';'650'});
h.YLim = [m M]; h.XLim = [300 700];h.YGrid = 'on';set(h.YGridHandle,'LineWidth',2);
h.YLabel.String = sprintf('%s',format); h.XLabel.String = sprintf('b_{high} (s/mm^2)');
h.FontSize = 15;h.TitleFontSizeMultiplier = 1.5;h.LabelFontSizeMultiplier = 1.5;
h.Parent.Name = sprintf('%s_highb',type2);h.Parent.Tag = num2str(9/8);

set(findobj(gcf,'Type','line','Tag','Box'),'LineWidth',9);
set(findobj(gcf,'Type','line','Tag','Whisker'),'LineWidth',3);

figure;
ind = find(tbl.lowB=='b015');
tbl2 = tbl(ind,:);
subplot(1,3,1);
g = gscatter(highb_scatter(ind),tbl2.(type),{tbl2.tech},c,'o',5,'off','','');
for i = 1:length(g)
    set(g(i),'MarkerEdgeColor','none','MarkerFaceColor',c(i,:));drawnow;
    set(g(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c(i,:)';0.5]));
end
hold on
boxplot(tbl2.(type),{tbl2.highB1 tbl2.tech},'Positions',highb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[]);
hold off
h=gca;h.Box = false;
set(gca,'XTick',350:100:650);set(gca,'XTickLabel',{'350';'450';'550';'650'});
% h.Title.String = sprintf('b_{low} = 15 s/mm^2');
% h.XLabel.String = sprintf('b_{high} (s/mm^2)');h.YLabel.String = sprintf('%s',format);
h.FontSize = 15;h.TitleFontSizeMultiplier = 1.5;h.LabelFontSizeMultiplier = 1.5;
h.YLim = [m M];h.XLim = [300 700];h.YGrid = 'on';set(h.YGridHandle,'LineWidth',2);
w = 0; width = 40/100;

ind = find(tbl.lowB=='b050');
tbl2 = tbl(ind,:);
subplot(1,3,2);

h.OuterPosition = [w 0 width 1];

g = gscatter(highb_scatter(ind),tbl2.(type),{tbl2.tech},c,'o',5,'off','','');
for i = 1:length(g)
    set(g(i),'MarkerEdgeColor','none','MarkerFaceColor',c(i,:));drawnow;
    set(g(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c(i,:)';0.5]));
end
hold on
boxplot(tbl2.(type),{tbl2.highB1 tbl2.tech},'Positions',highb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[]);
hold off
h=gca;h.Box = false;
set(gca,'XTick',350:100:650);set(gca,'XTickLabel',{'350';'450';'550';'650'});
% h.Title.String = sprintf('b_{low} = 50 s/mm^2');
% h.XLabel.String = sprintf('b_{high} (s/mm^2)');
h.FontSize = 15;h.TitleFontSizeMultiplier = 1.5;h.LabelFontSizeMultiplier = 1.5;
h.YLim = [m M];h.XLim = [300 700];h.YGrid = 'on';set(h.YGridHandle,'LineWidth',2);
w = w+width-0.03; width = 40/100;

ind = find(tbl.lowB=='b350');
tbl2 = tbl(ind,:);
subplot(1,3,3);

h.OuterPosition = [w 0 width 1];

g = gscatter(highb_scatter(ind),tbl2.(type),{tbl2.tech},c,'o',5,'off','','');
for i = 1:length(g)
    set(g(i),'MarkerEdgeColor','none','MarkerFaceColor',c(i,:));drawnow;
    set(g(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c(i,:)';0.5]));
end
hold on
boxplot(tbl2.(type),{tbl2.highB1 tbl2.tech},'Positions',highb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[]);
hold off
h=gca;h.Box = false;
set(gca,'XTick',550:100:650);set(gca,'XTickLabel',{'550';'650'});
% h.Title.String = sprintf('b_{low} = 350 s/mm^2');
% h.XLabel.String = sprintf('b_{high} (s/mm^2)');
h.FontSize = 15;h.TitleFontSizeMultiplier = 1.5;h.LabelFontSizeMultiplier = 1.5;
h.YLim = [m M];h.XLim = [500 700];h.YGrid = 'on';set(h.YGridHandle,'LineWidth',2);
w = w+width; width = 20/100; h.OuterPosition = [w 0 width 1];

set(findobj(gcf,'Type','line','Tag','Box'),'LineWidth',6);
set(findobj(gcf,'Type','line','Tag','Whisker'),'LineWidth',2);

h.Parent.Name = sprintf('%s_highb_lowb',type2);h.Parent.Tag = num2str(16/5);

end