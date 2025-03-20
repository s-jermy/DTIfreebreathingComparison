function lat = mat2latex_lme(lme)

est = lme.Coefficients.Estimate;
se = lme.Coefficients.SE;
low = lme.Coefficients.Lower;
up = lme.Coefficients.Upper;
p = lme.Coefficients.pValue;

%% create empty table
% sz = [length(est) 15];
sz = [length(est) 13];
varTypes = repmat({'string'},1,sz(2));
lat = table('Size',sz,'VariableTypes',varTypes);

%% fill columns with column breaks and line breaks
lat(:,2:2:11) = {'&'};
lat(:,12) = {'\\'};

%% fixed factors
lat(:,[1 3 13]) = {''};
lat(1,1) = {'\multicolumn{2}{c}{(Intercept)}'};lat(1,2)= {''};
lat(2,1) = {'\multirow[t]{3}{*}{Technique}'};
lat(5,1) = {'\multicolumn{2}{c}{b\textsubscript{low}\superbold{a}}'};lat(5,2)= {''};
lat(6,1) = {'\multicolumn{2}{c}{b\textsubscript{high}\superbold{b}}'};lat(6,2)= {''};
lat(7,1) = {'\multirow[t]{3}{*}{Technique:b\textsubscript{low}\superbold{a}}'};
lat(10,1) = {'\multirow[t]{3}{*}{Technique:b\textsubscript{high}\superbold{b}}'};

%% name of factor
lat(2,3) = {'Gated'};
lat(3,3) = {'1-Nav'};
lat(4,3) = {'Multi-Nav'};
lat(7,3) = {'Gated:b\textsubscript{low}'};
lat(8,3) = {'1-Nav:b\textsubscript{low}'};
lat(9,3) = {'Multi-Nav:b\textsubscript{low}'};
lat(10,3) = {'Gated:b\textsubscript{high}'};
lat(11,3) = {'1-Nav:b\textsubscript{high}'};
lat(12,3) = {'Multi-Nav:b\textsubscript{high}'};

lat([1 4 5 6 9],13) = {'\addlinespace'};
lat(12,13) = {'\bottomrule'};

%% holm's correction of p-values
% [corr_p,~] = bonf_holm(p(2:end),0.05);
% corr_p = [0;corr_p];

%% add estimates, se, CI, and p-values
format1 = '\\num{%0.2f}';
format2 = ['$\\mathrel{\\phantom{-}}$' format1];

rfx = @(x,xpnt) [sign(x).*10.^(log10(abs(x))-xpnt), xpnt]; 
% format3 = '%#0.2ge%d'; %print 2 significant digits (include trailing zeros)
format3 = '%0.2fe%d'; %print 2 digits
note = {{'1'} {'<.05'} {'<.01'} {'<.001'}};

sig=sum([p>=1 p<0.05 p<0.05 p<0.01 p<0.001],2);

for i = 1:sz(1)
    if est(i)<0
        lat(i,5) = {sprintf(format1,est(i))};
    else
        lat(i,5) = {sprintf(format1,est(i))};
    end
    if low(i)<0
        lat(i,7) = {sprintf(format1,low(i))};
    else
        lat(i,7) = {sprintf(format1,low(i))};
    end
    if up(i)<0
        lat(i,9) = {sprintf(format1,up(i))};
    else
        lat(i,9) = {sprintf(format1,up(i))};
    end
    
    if i>1
        xpnt = -3;
        lat(i,5) = {sprintf(format3,rfx(est(i),xpnt))};
        lat(i,7) = {sprintf(format3,rfx(low(i),xpnt))};
        lat(i,9) = {sprintf(format3,rfx(up(i),xpnt))};
        if any([i<5 i==6 i>9])
            xpnt = -2;
            lat(i,5) = {sprintf(format3,rfx(est(i),xpnt))};
            lat(i,7) = {sprintf(format3,rfx(low(i),xpnt))};
            lat(i,9) = {sprintf(format3,rfx(up(i),xpnt))};
        end
%         if i<5
%             xpnt = -1;
%             lat(i,5) = {sprintf(format3,rfx(est(i),xpnt))};
%             lat(i,7) = {sprintf(format3,rfx(low(i),xpnt))};
%             lat(i,9) = {sprintf(format3,rfx(up(i),xpnt))};
%         end
    end

    lat(i,11) = {sprintf('%.2f',p(i))};
    if sig(i)
        lat(i,11) = note{sig(i)};
    end
    %{
    if corr_p(i)<0.001
        lat(i,15) = {'<.001'};
    elseif corr_p(i)<0.01
        lat(i,15) = {'<.01'};
    elseif corr_p(i)<0.05
        lat(i,15) = {'<.05'};
    elseif corr_p(i)>=1
        lat(i,15) = {'1'};
    else
        lat(i,15) = {sprintf('%.2f',corr_p(i))};
    end
    %}
    
    if i==1
        lat(i,11) = {'{-}'};
    end
end

end