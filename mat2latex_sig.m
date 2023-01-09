function [tblSumm,tblMain,tblBval,tblAll,tblSE,lat1,lat2] = mat2latex_sig(lme,se)

%all techniques, bref 15, bhigh 350
tblSumm = [lme{1,1};...
    lme{2,1};...
    lme{3,1};...
    lme{4,1}];

%BH technique, bref 15, bhigh 350
tblMain = lme{1,1};

%all techniques, bref 15, bhigh 350, no interactions
tblBval = [lme{1,1}(1:6,:);...
    lme{2,1}([1 3:6],:);...
    lme{3,1}([1 4:6],:);...
    lme{4,1}([1 5:6],:)];

%all
tblAll = table;
for i = 1:length(lme(1,:))
    %technique
    range = 4*(i-1)+1:4*i;
    tblAll(range,:) = lme{1,i}(1:4,:);
end

%interactions
tmpInt = [lme{1,1}(7:12,:);...
    lme{2,1}([8:9 11:12],:);...
    lme{3,1}([9 12],:)];

%SEs
tblSE = [se(3,:) se(1,:) se(2,:) se(4,:)]';

%% table 2 corrrected p-values 
alpha = 0.05;
p = tblMain.pValue;
[corr_p,h] = bonf_holm(p(2:end),alpha);
corr_p = [nan;corr_p];
tblMain.corr_pValue = corr_p;
h = [nan;h];
tblMain.h = h;

%% table 3 corrected p-values
p = tblBval.pValue;
[sort_p,ind] = sort(p);
[~,ind2] = sort(ind);
[sort_corr_p,sort_h] = bonf_holm(sort_p(5:end),alpha);
sort_corr_p = [nan(4,1);sort_corr_p];
corr_p = sort_corr_p(ind2);
sort_h = [nan(4,1);sort_h];
h = sort_h(ind2);

tblBval.corr_pValue = corr_p;
tblBval.h = h;

tmpBval = tblBval([5:6 10:11 14:15 17:18],:);
%% table 4 corrected p-values
% holm's correction of p-values
p = tblAll.pValue;
[sort_p,ind] = sort(p);
[~,ind2] = sort(ind);
[sort_corr_p,sort_h] = bonf_holm(sort_p(11:end),alpha);
sort_corr_p = [nan(10,1);sort_corr_p];
corr_p = sort_corr_p(ind2);
sort_h = [nan(10,1);sort_h];
h = sort_h(ind2);

tblAll.corr_pValue = corr_p;
tblAll.h = h;

%% create empty table
sz = [4 19];
varTypes = repmat({'string'},1,sz(2));
lat1 = table('Size',sz,'VariableTypes',varTypes);

%% fill columns with column breaks and line breaks
lat1(:,2:2:16) = {'&'};
lat1(:,18) = {'\\'};
lat1(:,19) = {''};
lat1(4,19) = {'\bottomrule'};

%% fixed factors
lat1(1,1) = {'BH'};
lat1(2,1) = {'Gated'};
lat1(3,1) = {'1-Nav'};
lat1(4,1) = {'Multi-Nav'};

%% add estimates, CI
rfx = @(x,xpnt) [sign(x).*10.^(log10(abs(x))-xpnt), xpnt]; 
% format = '%#0.2ge%d'; %print 2 significant digits (include trailing zeros)
format = '%0.2fe%d'; %print 2 digits
note = {{''} {'\superbold{*}'} {'\superbold{**}'} {'\superbold{***}'}};

est = tblBval.Estimate;
low = tblBval.Lower;
up = tblBval.Upper;
corp = tblBval.corr_pValue;

sig=sum([corp>=0 corp<0.05 corp<0.01 corp<0.001],2);

ii=5;
for i=1:sz(1)
    xpnt = -3;
    lat1(i,3) = {sprintf(format,rfx(est(ii),xpnt))};
    lat1(i,5) = {sprintf(format,rfx(low(ii),xpnt))};
    lat1(i,7) = {sprintf(format,rfx(up(ii),xpnt))};
    lat1(i,9) = note{sig(ii)};
    xpnt = -2;
    lat1(i,11) = {sprintf(format,rfx(est(ii+1),xpnt))};
    lat1(i,13) = {sprintf(format,rfx(low(ii+1),xpnt))};
    lat1(i,15) = {sprintf(format,rfx(up(ii+1),xpnt))};
    lat1(i,17) = note{sig(ii+1)};
    
    ii = ii+6-i;
end

%% create empty table
sz = [10 35];%sz = [11 29];
varTypes = repmat({'string'},1,sz(2));
lat2 = table('Size',sz,'VariableTypes',varTypes);

%% fixed factors
lat2(:,2:2:32) = {'&'};
lat2(:,34) = {'\\'};
lat2(:,[1 35]) = {''};
lat2([4 8],35) = {'\addlinespace'};
lat2(10,35) = {'\bottomrule'};

%% name of factor
lat2(1:10,1) = {'$\cdot$'};
lat2(1,1) = {'\multirow[t]{4}{*}{15}'};
lat2(5,1) = {'\multirow[t]{4}{*}{50}'};
lat2(9,1) = {'\multirow[t]{3}{*}{350}'};
lat2([1 5],3) = {'350'};
lat2([2 6],3) = {'450'};
lat2([3 7 9],3) = {'550'};
lat2([4 8 10],3) = {'650'};

%% add estimates, CI
% format = '%#0.2g'; %print 2 significant digits (include trailing zeros)
format = '%0.2f'; %print 2 digits
% format = '%0.3f'; %print 2 digits
note = {{''} {'\superbold{*}'} {'\superbold{**}'} {'\superbold{***}'}};

est = tblAll.Estimate;
low = tblAll.Lower;
up = tblAll.Upper;
corp = tblAll.corr_pValue;

sig=sum([corp>=0 corp<0.05 corp<0.01 corp<0.001],2);

for i=1:sz(1)
    j = 4*i;
    
    a = est(j-3)+est(j-2:j);
    b = est(j-3)+low(j-2:j);
    c = est(j-3)+up(j-2:j);
    
    lat2(i,5) = {sprintf(format,a(1))};
    lat2(i,7) = {sprintf(format,b(1))};
    lat2(i,9) = {sprintf(format,c(1))};
    lat2(i,11) = note{sig(j-2)};
    lat2(i,13) = {sprintf(format,a(2))};
    lat2(i,15) = {sprintf(format,b(2))};
    lat2(i,17) = {sprintf(format,c(2))};
    lat2(i,19) = note{sig(j-1)};
    lat2(i,21) = {sprintf(format,a(3))};
    lat2(i,23) = {sprintf(format,b(3))};
    lat2(i,25) = {sprintf(format,c(3))};
    lat2(i,27) = note{sig(j)};
    lat2(i,29) = {sprintf(format,est(j-3))};
    lat2(i,31) = {sprintf(format,low(j-3))};
    lat2(i,33) = {sprintf(format,up(j-3))};
end

end