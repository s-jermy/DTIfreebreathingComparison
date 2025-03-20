function [av,med,quant,skew,kurt] = descriptive_statistics(tbl,type,outl_sd,display_on)

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
quant = quantile(tbl2.(type),p);
av = mean(tbl2.(type));
med = median(tbl2.(type));
skew = skewness(tbl2.(type));
kurt = kurtosis(tbl2.(type));

if display_on
    fprintf('Quantiles of %s\n',type);
    fprintf('%.4f\t',p);fprintf('\n');fprintf('%.4f\t',quant);fprintf('\n');
    fprintf('Mean and median of %s\n',type);
    fprintf('%.4f\t%.4f\n',av,med);
    fprintf('Skewness and kurtosis of %s\n',type);
    fprintf('%.4f\t%.4f\n',skew,kurt);
    
    boxplots(tbl,type,outl_sd,0);
end

end