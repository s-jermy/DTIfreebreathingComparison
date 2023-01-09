function [lme,coeff,latLME] = lmem(tbl,type,outl_sd,mdl,display_on)

switch type
    case {'MD','AD','RD'}
        unit = sprintf('\x03bcm^2/ms');
        format = [type ' (' unit ')'];
    case 'FA'
        format = type;
    case 'HAg'
        unit = sprintf('\x00b0/%%');
        format = [type ' (' unit ')'];
    case 'HAd'
        unit = sprintf('\x00b0/mm');
        format = [type ' (' unit ')'];
end
tbl2 = tbl;
%finding outliers
Z = zscore(tbl.(type));
outliers = find(abs(Z)>outl_sd);
% disp('Outliers');disp(tbl(outliers,:));

%% shift lowB values
tbl2.lowB15 = (tbl2.lowB1 - 15)/10; %shift so zero at lowB = 15

%% shift highB values
tbl2.highB350 = (tbl2.highB1 - 350)/100; %shift so zero at highB = 350

c = 1/255*[[68 114 196];[165 165 165];[255 192 0];[237 125 49]];

%% LMEMs
if mdl==1
    model = sprintf('%s ~ 1 + tech * (lowB15 + highB350) + (1|ID) + (1|ID:segment)',type);
    try
        lme = fitlme(tbl2,model,'Exclude',outliers,'CheckHessian',true); %model we settled on after consultation with Francesca. Interaction terms between b-values and techs. Grouping terms as well as interactions in the random variables.
    catch
        model = sprintf('%s ~ 1 + tech * (lowB15 + highB350) + (1|ID)',type);
        lme = fitlme(tbl2,model,'Exclude',outliers,'CheckHessian',true);
    end
elseif mdl==2
    model = sprintf('%s ~ 1 + tech * (lowB15 + highB350) + (tech|ID:segment)',type);
    try
        lme = fitlme(tbl2,model,'Exclude',outliers,'CheckHessian',true);
    catch
        model = sprintf('%s ~ 1 + tech * (lowB15 + highB350) + (tech|ID)',type);
        lme = fitlme(tbl2,model,'Exclude',outliers,'CheckHessian',true);
    end
end
latLME = mat2latex_lme(lme);

coeff = dataset2table(lme.Coefficients);
p = coeff.pValue;
[corr_p,h] = bonf_holm(p(2:end),0.05);
corr_p = [0;corr_p];
h = [0;h];
coeff.corr_pValue = corr_p;
coeff.h = h;

F = fitted(lme);R = residuals(lme);

if display_on
    tbl2.(type)(outliers,:) = nan;
    
    z = [-20 0;20 0];
    figure;
    g = gscatter(F,R,{tbl2.tech},c,'^sph',7,'off');
    for i = 1:length(g)
        set(g(i),'MarkerEdgeColor','none','MarkerFaceColor',c(i,:));drawnow;
        set(g(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c(i,:)';0.75]));
    end
    hold on;
    plot(z(:,1),z(:,2),'HandleVisibility','off','Color',[0 0 0]);
    hold off;
    h=gca;h.Title.String = sprintf('Fitted vs. Residuals\n%s',model);
    h.YLabel.String = 'Residuals';h.XLabel.String = 'Fitted';
    h.FontSize = 15;h.TitleFontSizeMultiplier = 1.5;h.LabelFontSizeMultiplier = 1.5;
    h.Parent.Name = sprintf('lme%s_res',type);h.Parent.Tag = num2str(1);
    
    z = [-20;20];
    figure;
    g = gscatter(tbl2.(type),F,{tbl2.tech},c,'^sph',7,'off');
    for i = 1:length(g)
        set(g(i),'MarkerEdgeColor','none','MarkerFaceColor',c(i,:));drawnow;
        set(g(i).MarkerHandle,'FaceColorType','truecoloralpha','FaceColorData',uint8(255*[c(i,:)';0.75]));
    end
    hold on;
    plot(z,z,'HandleVisibility','off','Color',[0 0 0]);
    hold off
    h=gca;h.Title.String = sprintf('%1$s vs. Fitted %1$s\n%2$s',type,model);
    h.YLabel.String = sprintf('Fitted %s',format); h.XLabel.String = sprintf('%s',format);
    h.FontSize = 15;h.TitleFontSizeMultiplier = 1.5;h.LabelFontSizeMultiplier = 1.5;
    h.Parent.Name = sprintf('lme%s_qq',type);h.Parent.Tag = num2str(1);
    
    tbl.(type) = F;
    boxplots(tbl,type,outl_sd,1);
end

lowBm = coeff.Estimate(5) + [0 coeff.Estimate(7:9)'];
ind = find(tbl2.tech=='BH'&tbl2.lowB=='b015');lowB(1)=mean(F(ind),'omitnan');
% lowx = [-135;465];lowy = lowB(1)+[-15*lowBm(1);45*lowBm(1)];
ind = find(tbl2.tech=='Gated'&tbl2.lowB=='b015');lowB(2)=mean(F(ind),'omitnan');
% lowx = cat(2,lowx,[-134;465]);lowy = cat(2,lowy,lowB(2)+[-14.9*lowBm(2);45*lowBm(2)]);
ind = find(tbl2.tech=='1-Nav'&tbl2.lowB=='b015');lowB(3)=mean(F(ind),'omitnan');
% lowx = cat(2,lowx,[-133;465]);lowy = cat(2,lowy,lowB(3)+[-14.8*lowBm(3);45*lowBm(3)]);
ind = find(tbl2.tech=='Multi-Nav'&tbl2.lowB=='b015');lowB(4)=mean(F(ind),'omitnan');
% lowx = cat(2,lowx,[-132;465]);lowy = cat(2,lowy,lowB(4)+[-14.7*lowBm(4);45*lowBm(4)]);
lowx = repmat([-135;465],1,4);lowy = lowB+[-15*lowBm;45*lowBm];

highBm = coeff.Estimate(6) + [0 coeff.Estimate(10:12)'];
ind = find(tbl2.tech=='BH'&tbl2.highB=='b350');highB(1)=mean(F(ind),'omitnan');
ind = find(tbl2.tech=='Gated'&tbl2.highB=='b350');highB(2)=mean(F(ind),'omitnan');
ind = find(tbl2.tech=='1-Nav'&tbl2.highB=='b350');highB(3)=mean(F(ind),'omitnan');
ind = find(tbl2.tech=='Multi-Nav'&tbl2.highB=='b350');highB(4)=mean(F(ind),'omitnan');
highx = repmat([200;800],1,4);highy = highB+[-1.5*highBm;4.5*highBm];

if display_on
    tbl2.(type)(outliers,:) = nan;
    tech_num = ones(size(tbl2,1),1);
    tech_num(tbl2.tech == 'Gated') = 2; tech_num(tbl2.tech == '1-Nav') = 3; tech_num(tbl2.tech == 'Multi-Nav') = 4; %this is to get around the fact that gscatter can't properly handle categorical variables
    
    m = min(tbl2.(type));M = max(tbl2.(type));
    switch type
        case {'MD','AD','RD'}
            buffer = 0.05*(M-m);
            m = m+buffer;M = M-buffer;
        case 'FA'
            buffer = 0.1*(M-m);
            m = m;M = M-buffer;
        case {'HAg','HAd'}
            buffer = 0.05*(M-m);
            m = m+buffer;M = M+buffer;
    end

    figure;
    lowB1 = tbl2.lowB1;%lowB1 = lowB1-200*(lowB1>100); %reduce gap between 50 and 350
    lowx = lowx+6*(2/3*(0:3)-1);
    
    lowb_box = lowB1 + 6*(2/3*(tech_num-1)-1);
    hold on
    plot(lowx(:,1),lowy(:,1),'LineStyle',':','LineWidth',6,'Color',c(1,:));
    plot(lowx(:,2),lowy(:,2),'LineStyle',':','LineWidth',6.5,'Color',c(2,:));
    plot(lowx(:,3),lowy(:,3),'LineStyle',':','LineWidth',7,'Color',c(3,:));
    plot(lowx(:,4),lowy(:,4),'LineStyle',':','LineWidth',7.5,'Color',c(4,:));
    boxplot(tbl2.(type),{lowB1 tbl2.tech},'Positions',lowb_box,'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[]);
    hold off
    h=gca;h.Box = false;
    set(gca,'XTick',[15 50:100:350]);set(gca,'XTickLabel',{'15';'50';'150';'250';'350'});
    h.YLim = [m M]; h.XLim = [0 400];h.YGrid = 'on';set(h.YGridHandle,'LineWidth',2);
%     h.Title.String = sprintf('%s by tech and low b-value',type);
%     h.YLabel.String = sprintf('%s',format); h.XLabel.String = sprintf('b_{low} (s/mm^2)');
    h.FontSize = 30;%h.TitleFontSizeMultiplier = 1.5;h.LabelFontSizeMultiplier = 1.5;
    h.Parent.Name = sprintf('lme%s_lowb_fit',type);h.Parent.Tag = num2str(8/5);
    
    set(findobj(gcf,'Type','line','Tag','Box'),'LineWidth',9);
    set(findobj(gcf,'Type','line','Tag','Whisker'),'LineWidth',3);
    
    figure;
    highx = highx+9*(2/3*(0:3)-1);
    
    highb_box = tbl.highB1 + 9*(2/3*(tech_num-1)-1);
    hold on
    plot(highx(:,1),highy(:,1),'LineStyle',':','LineWidth',6,'Color',c(1,:));
    plot(highx(:,2),highy(:,2),'LineStyle',':','LineWidth',6.5,'Color',c(2,:));
    plot(highx(:,3),highy(:,3),'LineStyle',':','LineWidth',7,'Color',c(3,:));
    plot(highx(:,4),highy(:,4),'LineStyle',':','LineWidth',7.5,'Color',c(4,:));
    boxplot(tbl2.(type),{tbl2.highB1 tbl2.tech},'Positions',highb_box,'PlotStyle','compact','Colors',c,'Symbol','','FactorGap',[]);
    hold off
    h=gca;h.Box = false;
    set(gca,'XTick',350:100:650);set(gca,'XTickLabel',{'350';'450';'550';'650'});
    h.YLim = [m M]; h.XLim = [300 700];h.YGrid = 'on';set(h.YGridHandle,'LineWidth',2);
%     h.Title.String = sprintf('%s by tech and high b-value',type);
%     h.YLabel.String = sprintf('%s',format); h.XLabel.String = sprintf('b_{high} (s/mm^2)');
    h.FontSize = 30;%h.TitleFontSizeMultiplier = 1.5;h.LabelFontSizeMultiplier = 1.5;
    h.Parent.Name = sprintf('lme%s_highb_fit',type);h.Parent.Tag = num2str(8/5);
    
    set(findobj(gcf,'Type','line','Tag','Box'),'LineWidth',9);
    set(findobj(gcf,'Type','line','Tag','Whisker'),'LineWidth',3);
end

end