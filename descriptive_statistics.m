%%% requires Statistics and Machine Learning Toolbox

function [stats_tech,stats_all] = descriptive_statistics(tbl,type,outl_sd,display_on)

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
Z = zscore(tbl2.(type));
outliers = find(abs(Z)>outl_sd);
% disp('Outliers');disp(tbl(outliers,:));

%remove outliers 
tbl2(outliers,:) = [];

if display_on
    figure;histfit(tbl2.(type),20); h=gca;
%     h.Children(2).FaceAlpha = 0.6; h.Children(2).FaceColor = [0 0 0];
    h.Children(1).Color = [0 0 0]; h.Box = false;
    h.Title.String = sprintf('%s histogram',type); h.XLabel.String = sprintf('%s',format);
    h.FontSize = 15;h.TitleFontSizeMultiplier = 1.5;h.LabelFontSizeMultiplier = 1.5;
    h.Parent.Name = sprintf('%s_hist',type);h.Parent.Tag = num2str(1);
end

p = 0:0.25:1;
stats_all.quant = quantile(tbl2.(type),p);
stats_all.av = mean(tbl2.(type));
stats_all.sd = std(tbl2.(type));
stats_all.med = median(tbl2.(type));
stats_all.skew = skewness(tbl2.(type));
stats_all.kurt = kurtosis(tbl2.(type));

t = unique(tbl2.tech);
b = unique(tbl2.lowB);
stats_tech.quant = zeros([length(t) length(p) length(b)+1]);

for i = 1:length(t)
    stats_tech.quant(i,:,1) = quantile(tbl2.(type)(tbl2.tech==t(i)),p);
    stats_tech.av(i,1) = mean(tbl2.(type)(tbl2.tech==t(i)));
    stats_tech.sd(i,1) = std(tbl2.(type)(tbl2.tech==t(i)));
    stats_tech.med(i,1) = median(tbl2.(type)(tbl2.tech==t(i)));
    stats_tech.skew(i,1) = skewness(tbl2.(type)(tbl2.tech==t(i)));
    stats_tech.kurt(i,1) = kurtosis(tbl2.(type)(tbl2.tech==t(i)));
    for j = 1:length(b)
        stats_tech.quant(i,:,j+1) = quantile(tbl2.(type)(tbl2.tech==t(i)&tbl2.lowB==b(j)),p);
        stats_tech.av(i,j+1) = mean(tbl2.(type)(tbl2.tech==t(i)&tbl2.lowB==b(j)));
        stats_tech.sd(i,j+1) = std(tbl2.(type)(tbl2.tech==t(i)&tbl2.lowB==b(j)));
        stats_tech.med(i,j+1) = median(tbl2.(type)(tbl2.tech==t(i)&tbl2.lowB==b(j)));
        stats_tech.skew(i,j+1) = skewness(tbl2.(type)(tbl2.tech==t(i)&tbl2.lowB==b(j)));
        stats_tech.kurt(i,j+1) = kurtosis(tbl2.(type)(tbl2.tech==t(i)&tbl2.lowB==b(j)));
    end
end

if display_on
    fprintf('Quantiles of %s\n',type);
    fprintf('%.4f\t',p);fprintf('\n');fprintf('%.4f\t',stats_all.quant);fprintf('\n');
    fprintf('Mean and median of %s\n',type);
    fprintf('%.4f\t%.4f\n',stats_all.av,stats_all.med);
    fprintf('Skewness and kurtosis of %s\n',type);
    fprintf('%.4f\t%.4f\n',stats_all.skew,stats_all.kurt);
    
    boxplots(tbl,type,outl_sd,0);
end

end