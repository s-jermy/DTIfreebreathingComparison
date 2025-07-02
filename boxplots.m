function boxplots(tbl,type,outl_sd,islme,tbl2)

%finding outliers
Z = zscore(tbl.(type));
outliers = find(abs(Z)>outl_sd);
% disp('Outliers');disp(tbl(outliers,:));

if islme
    outliers = [];
end

tbl.(type)(outliers) = nan;

m = min(tbl.(type));M = max(tbl.(type));
switch type
    case {'MD','AD','RD'}
        type2 = type;
        unit = sprintf('\x03bcm^2/ms');
        format = [type ' (' unit ')'];
        buffer = 0.05*(M-m);
    case 'FA'
        type2 = type;
        format = type;
        buffer = 0.1*(M-m);
    case 'HAg'
        type2 = type;
        unit = sprintf('\x00b0/%%');
        format = [type ' (' unit ')'];
        buffer = 0.05*(M-m);
    case 'HAd'
        type2 = type;
        unit = sprintf('\x00b0/mm');
        format = [type ' (' unit ')'];
        buffer = 0.05*(M-m);
end
m = m-buffer;M = M+buffer;

if islme
    type2 = ['lme' type];
    % format = ['Fitted ' format];
end

extra = false;
if ~isempty(tbl2)
    extra = true;
end

c = 1/255*[[68 114 196];[165 165 165];[255 192 0];[237 125 49]]; %BH/CS/Gate/Nav
c2 = 1/255*[[68 114 196];[255 192 0];[237 125 49]]; %BH/Gate/Nav

%% boxplots

tech_num = ones(size(tbl,1),1);
tech_num(tbl.tech == 'CS') = 2; tech_num(tbl.tech == 'Gate') = 3; tech_num(tbl.tech == 'Nav') = 4; %this is to get around the fact that gscatter can't properly handle categorical variables

if extra
    tech_num2 = ones(size(tbl2,1),1);
    tech_num2(tbl2.tech == 'Gate') = 3; tech_num2(tbl2.tech == 'Nav') = 4;
end

%% tech
jamount = 1/4;
jitter = jamount*(rand(height(tbl),1)-0.5); %add jitter so that the points aren't on top of one another

figure; %by tech
tech_scatter = tech_num+jitter+1/4;
g = gscatter(tech_scatter,tbl.(type),{tbl.tech},c,'o',10,'off','','');
for i = 1:length(g)
    set(g(i),'MarkerEdgeColor','none','MarkerFaceColor',c(i,:));drawnow;
    set(g(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c(i,:)';0.5]));
end
hold on
if extra
    jamount = 1/6;
    jitter2 = jamount*(rand(height(tbl2),1)-0.5);
    tech_scatter2 = tech_num2+jitter2+3/5;
    g2 = gscatter(tech_scatter2,tbl2.(type),{tbl2.tech},c2,'^',10,'off','','');
    for i = 1:length(g2)
        set(g2(i),'MarkerEdgeColor','none','MarkerFaceColor',c2(i,:));drawnow;
        set(g2(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c2(i,:)';0.5]));
    end
end
boxplot(tbl.(type),{tbl.tech},'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[]);
hold off
h=gca;h.Box = false;
set(gca,'XTick',1:4);set(gca,'XTickLabel',{'BH';'CS';'Gate';'Nav'});
h.YLim = [m M];h.YGrid = 'on';set(h.YGridHandle,'LineWidth',2);
% h.Title.String = sprintf('%s by tech',type); 
% h.YLabel.String = sprintf('%s',format); h.XLabel.String = sprintf('Technique');
h.FontSize = 30;h.TitleFontSizeMultiplier = 1.5;h.LabelFontSizeMultiplier = 1.5;
h.Parent.Name = sprintf('%s_tech',type2);h.Parent.Tag = num2str(9/8);

set(findobj(gcf,'Type','line','Tag','Box'),'LineWidth',8);
set(findobj(gcf,'Type','line','Tag','Whisker'),'LineWidth',3);

%% tech and lowb
jamount = 12;
jitter = jamount*(rand(height(tbl),1)-0.5); %add jitter so that the points aren't on top of one another

figure; %by lowb
lowB1 = tbl.lowB1;lowB1 = lowB1-200*(lowB1>100); %reduce gap between 50 and 350
lowb_scatter = lowB1+jitter+20;
lowb_scatter(lowB1==15) = lowb_scatter(lowB1==15)-40; %moves scatter to left side of 15
lowb_box = lowB1 + 6*(2/3*(tech_num-1)-1);
g = gscatter(lowb_scatter,tbl.(type),{tbl.tech},c,'o',10,'off','','');
for i = 1:length(g)
    set(g(i),'MarkerEdgeColor','none','MarkerFaceColor',c(i,:));drawnow;
    set(g(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c(i,:)';0.5]));
end
hold on
if extra
    jamount = 8;
    jitter2 = jamount*(rand(height(tbl2),1)-0.5);
    lowB12 = tbl2.lowB1;lowB12 = lowB12-200*(lowB12>100);
    lowb_scatter2 = lowB12+jitter2+40;
    lowb_scatter2(lowB12==15) = lowb_scatter2(lowB12==15)-70; %moves scatter to left side of 15
    g2 = gscatter(lowb_scatter2,tbl2.(type),{tbl2.tech},c2,'^',10,'off','','');
    for i = 1:length(g2)
        set(g2(i),'MarkerEdgeColor','none','MarkerFaceColor',c2(i,:));drawnow;
        set(g2(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c2(i,:)';0.5]));
    end
end
boxplot(tbl.(type),{lowB1 tbl.tech},'Positions',lowb_box,'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[]);
hold off
h=gca;h.Box = false;
set(gca,'XTick',50:100:150);set(gca,'XTickLabel',{'50';'350'});
h.YLim = [m M]; h.XLim = [0 200];h.YGrid = 'on';set(h.YGridHandle,'LineWidth',2);
% h.Title.String = sprintf('%s by tech and low b-value',type); 
% h.YLabel.String = sprintf('%s',format); h.XLabel.String = sprintf('b_{low} (s/mm^2)');
h.FontSize = 30;h.TitleFontSizeMultiplier = 1.5;h.LabelFontSizeMultiplier = 1.5;
h.Parent.Name = sprintf('%s_lowb',type2);h.Parent.Tag = num2str(9/8);

set(findobj(gcf,'Type','line','Tag','Box'),'LineWidth',8);
set(findobj(gcf,'Type','line','Tag','Whisker'),'LineWidth',3);

figure; %by lowb and highb
ind = find(tbl.highB=='b350');
tbltemp = tbl(ind,:);
subplot(1,4,1);
g = gscatter(lowb_scatter(ind),tbltemp.(type),{tbltemp.tech},c,'o',10,'off','','');
for i = 1:length(g)
    set(g(i),'MarkerEdgeColor','none','MarkerFaceColor',c(i,:));drawnow;
    set(g(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c(i,:)';0.5]));
end
hold on
if extra
    ind2 = find(tbl2.highB=='b350');
    tbltemp2 = tbl2(ind2,:);
    g2 = gscatter(lowb_scatter2(ind2),tbltemp2.(type),{tbltemp2.tech},c2,'^',10,'off','','');
    for i = 1:length(g2)
        set(g2(i),'MarkerEdgeColor','none','MarkerFaceColor',c2(i,:));drawnow;
        set(g2(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c2(i,:)';0.5]));
    end
end
boxplot(tbltemp.(type),{lowB1(ind) tbltemp.tech},'Positions',lowb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[],'Width',0.5);
hold off
h=gca;h.Box = false;
set(gca,'XTick',50);set(gca,'XTickLabel',{'50'});
% h.Title.String = sprintf('b_{high} = 350 s/mm^2');
% h.YLabel.String = sprintf('%s',format);%h.XLabel.String = sprintf('b_{low} (s/mm^2)');
h.FontSize = 30;
h.YLim = [m M];h.XLim = [15 115];h.YGrid = 'on';set(h.YGridHandle,'LineWidth',2);
w = 0; width = 1/6; h.OuterPosition = [w 0 width 1];

ind = find(tbl.highB=='b450');
tbltemp = tbl(ind,:);
subplot(1,4,2);
g = gscatter(lowb_scatter(ind),tbltemp.(type),{tbltemp.tech},c,'o',10,'off','','');
for i = 1:length(g)
    set(g(i),'MarkerEdgeColor','none','MarkerFaceColor',c(i,:));drawnow;
    set(g(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c(i,:)';0.5]));
end
hold on
if extra
    ind2 = find(tbl2.highB=='b450');
    tbltemp2 = tbl2(ind2,:);
    g2 = gscatter(lowb_scatter2(ind2),tbltemp2.(type),{tbltemp2.tech},c2,'^',10,'off','','');
    for i = 1:length(g2)
        set(g2(i),'MarkerEdgeColor','none','MarkerFaceColor',c2(i,:));drawnow;
        set(g2(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c2(i,:)';0.5]));
    end
end
boxplot(tbltemp.(type),{lowB1(ind) tbltemp.tech},'Positions',lowb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[]);
hold off
h=gca;h.Box = false;
set(gca,'XTick',50);set(gca,'XTickLabel',{'50'});
% h.Title.String = sprintf('b_{high} = 450 s/mm^2');
% h.XLabel.String = sprintf('b_{low} (s/mm^2)');%h.YLabel.String = sprintf('%s',format);
h.FontSize = 30;
h.YLim = [m M];h.XLim = [15 115];h.YGrid = 'on';set(h.YGridHandle,'LineWidth',2);
w = w+width; width = 1/6; h.OuterPosition = [w 0 width 1];

ind = find(tbl.highB=='b550');
tbltemp = tbl(ind,:);
subplot(1,4,3);
g = gscatter(lowb_scatter(ind),tbltemp.(type),{tbltemp.tech},c,'o',10,'off','','');
for i = 1:length(g)
    set(g(i),'MarkerEdgeColor','none','MarkerFaceColor',c(i,:));drawnow;
    set(g(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c(i,:)';0.5]));
end
hold on
if extra
    ind2 = find(tbl2.highB=='b550');
    tbltemp2 = tbl2(ind2,:);
    g2 = gscatter(lowb_scatter2(ind2),tbltemp2.(type),{tbltemp2.tech},c2,'^',10,'off','','');
    for i = 1:length(g2)
        set(g2(i),'MarkerEdgeColor','none','MarkerFaceColor',c2(i,:));drawnow;
        set(g2(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c2(i,:)';0.5]));
    end
end
boxplot(tbltemp.(type),{lowB1(ind) tbltemp.tech},'Positions',lowb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[]);
hold off
h=gca;h.Box = false;
set(gca,'XTick',50:100:150);set(gca,'XTickLabel',{'50';'350'});
% h.Title.String = sprintf('b_{high} = 550 s/mm^2');
% h.XLabel.String = sprintf('b_{low} (s/mm^2)');%h.YLabel.String = sprintf('%s',format);
h.FontSize = 30;
h.YLim = [m M];h.XLim = [0 200];h.YGrid = 'on';set(h.YGridHandle,'LineWidth',2);
w = w+width; width = 1/3; h.OuterPosition = [w 0 width 1];

ind = find(tbl.highB=='b650');
tbltemp = tbl(ind,:);
subplot(1,4,4);
g = gscatter(lowb_scatter(ind),tbltemp.(type),{tbltemp.tech},c,'o',10,'off','','');
for i = 1:length(g)
    set(g(i),'MarkerEdgeColor','none','MarkerFaceColor',c(i,:));drawnow;
    set(g(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c(i,:)';0.5]));
end
hold on
if extra
    ind2 = find(tbl2.highB=='b650');
    tbltemp2 = tbl2(ind2,:);
    g2 = gscatter(lowb_scatter2(ind2),tbltemp2.(type),{tbltemp2.tech},c2,'^',10,'off','','');
    for i = 1:length(g2)
        set(g2(i),'MarkerEdgeColor','none','MarkerFaceColor',c2(i,:));drawnow;
        set(g2(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c2(i,:)';0.5]));
    end
end
boxplot(tbltemp.(type),{lowB1(ind) tbltemp.tech},'Positions',lowb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[]);
hold off
h=gca;h.Box = false;
set(gca,'XTick',50:100:150);set(gca,'XTickLabel',{'50';'350'});
% h.Title.String = sprintf('b_{high} = 650 s/mm^2');
% h.XLabel.String = sprintf('b_{low} (s/mm^2)');%h.YLabel.String = sprintf('%s',format);
h.FontSize = 30;
h.YLim = [m M];h.XLim = [0 200];h.YGrid = 'on';set(h.YGridHandle,'LineWidth',2);
w = w+width; width = 1/3; h.OuterPosition = [w 0 width 1];

set(findobj(gcf,'Type','line','Tag','Box'),'LineWidth',8);
set(findobj(gcf,'Type','line','Tag','Whisker'),'LineWidth',3);

h.Parent.Name = sprintf('%s_lowb_highb',type2);h.Parent.Tag = num2str(16/5);

%% tech and highb
jamount = 12;
jitter = jamount*(rand(height(tbl),1)-0.5); %add jitter so that the points aren't on top of one another

figure; %by highb
highb_scatter = tbl.highB1+jitter+20;
highb_box = tbl.highB1 + 6*(2/3*(tech_num-1)-1);
g = gscatter(highb_scatter,tbl.(type),{tbl.tech},c,'o',10,'off','','');
for i = 1:length(g)
    set(g(i),'MarkerEdgeColor','none','MarkerFaceColor',c(i,:));drawnow;
    set(g(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c(i,:)';0.5]));
end
hold on
if extra
    jamount = 8;
    jitter2 = jamount*(rand(height(tbl2),1)-0.5);
    highb_scatter2 = tbl2.highB1+jitter2+40;
    g2 = gscatter(highb_scatter2,tbl2.(type),{tbl2.tech},c2,'^',10,'off','','');
    for i = 1:length(g2)
        set(g2(i),'MarkerEdgeColor','none','MarkerFaceColor',c2(i,:));drawnow;
        set(g2(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c2(i,:)';0.5]));
    end
end
boxplot(tbl.(type),{tbl.highB1 tbl.tech},'Positions',highb_box,'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[]);
hold off
h=gca;h.Box = false;
set(gca,'XTick',350:100:650);set(gca,'XTickLabel',{'350';'450';'550';'650'});
h.YLim = [m M]; h.XLim = [300 700];h.YGrid = 'on';set(h.YGridHandle,'LineWidth',2);
% h.Title.String = sprintf('%s by tech and high b-value',type); 
% h.YLabel.String = sprintf('%s',format); h.XLabel.String = sprintf('b_{high} (s/mm^2)');
h.FontSize = 30;h.TitleFontSizeMultiplier = 1.5;h.LabelFontSizeMultiplier = 1.5;
h.Parent.Name = sprintf('%s_highb',type2);h.Parent.Tag = num2str(9/8);

set(findobj(gcf,'Type','line','Tag','Box'),'LineWidth',8);
set(findobj(gcf,'Type','line','Tag','Whisker'),'LineWidth',3);

figure; %by highb and lowb
ind = find(tbl.lowB=='b050');
tbltemp = tbl(ind,:);
subplot(1,2,1);

g = gscatter(highb_scatter(ind),tbltemp.(type),{tbltemp.tech},c,'o',10,'off','','');
for i = 1:length(g)
    set(g(i),'MarkerEdgeColor','none','MarkerFaceColor',c(i,:));drawnow;
    set(g(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c(i,:)';0.5]));
end
hold on
if extra
    ind2 = find(tbl2.lowB=='b050');
    tbltemp2 = tbl2(ind2,:);
    g2 = gscatter(highb_scatter2(ind2),tbltemp2.(type),{tbltemp2.tech},c2,'^',10,'off','','');
    for i = 1:length(g2)
        set(g2(i),'MarkerEdgeColor','none','MarkerFaceColor',c2(i,:));drawnow;
        set(g2(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c2(i,:)';0.5]));
    end
end
boxplot(tbltemp.(type),{tbltemp.highB1 tbltemp.tech},'Positions',highb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[]);
hold off
h=gca;h.Box = false;
set(gca,'XTick',350:100:650);set(gca,'XTickLabel',{'350';'450';'550';'650'});
% h.Title.String = sprintf('b_{low} = 50 s/mm^2');
% h.XLabel.String = sprintf('b_{high} (s/mm^2)');
h.FontSize = 30;h.TitleFontSizeMultiplier = 1.5;h.LabelFontSizeMultiplier = 1.5;
h.YLim = [m M];h.XLim = [300 700];h.YGrid = 'on';set(h.YGridHandle,'LineWidth',2);
w = 0; width = 60/100;

ind = find(tbl.lowB=='b350');
tbltemp = tbl(ind,:);
subplot(1,2,2);
h.OuterPosition = [w 0 width 1]; %this has to go AFTER subplot 

g = gscatter(highb_scatter(ind),tbltemp.(type),{tbltemp.tech},c,'o',10,'off','','');
for i = 1:length(g)
    set(g(i),'MarkerEdgeColor','none','MarkerFaceColor',c(i,:));drawnow;
    set(g(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c(i,:)';0.5]));
end
hold on
if extra
    ind2 = find(tbl2.lowB=='b350');
    tbltemp2 = tbl2(ind2,:);
    g2 = gscatter(highb_scatter2(ind2),tbltemp2.(type),{tbltemp2.tech},c2,'^',10,'off','','');
    for i = 1:length(g2)
        set(g2(i),'MarkerEdgeColor','none','MarkerFaceColor',c2(i,:));drawnow;
        set(g2(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c2(i,:)';0.5]));
    end
end
boxplot(tbltemp.(type),{tbltemp.highB1 tbltemp.tech},'Positions',highb_box(ind),'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[]);
hold off
h=gca;h.Box = false;
set(gca,'XTick',550:100:650);set(gca,'XTickLabel',{'550';'650'});
% h.Title.String = sprintf('b_{low} = 350 s/mm^2');
% h.XLabel.String = sprintf('b_{high} (s/mm^2)');
h.FontSize = 30;h.TitleFontSizeMultiplier = 1.5;h.LabelFontSizeMultiplier = 1.5;
h.YLim = [m M];h.XLim = [500 700];h.YGrid = 'on';set(h.YGridHandle,'LineWidth',2);
w = w+width; width = 40/100; h.OuterPosition = [w 0 width 1];

set(findobj(gcf,'Type','line','Tag','Box'),'LineWidth',8);
set(findobj(gcf,'Type','line','Tag','Whisker'),'LineWidth',3);

h.Parent.Name = sprintf('%s_highb_lowb',type2);h.Parent.Tag = num2str(16/5);

end