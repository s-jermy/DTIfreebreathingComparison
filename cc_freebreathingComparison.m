clear
close all

%% load data
valueset = (1:4); catnames = {'BH','Gated','1-Nav','Multi-Nav'};
dataxlsx = 'dti_20220825.xlsx';

bAll = readtable(dataxlsx,'Sheet','Sheet4');
bAll.ID = categorical(bAll.ID);
bAll.tech = categorical(bAll.tech,valueset,catnames);
bAll.lowB = categorical(bAll.lowB);
bAll.highB = categorical(bAll.highB);
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

%% change highB from categorical to continuous
ind = find(bAll.highB == "b350");
bAll.highB1(ind) = repmat(350,size(ind));
ind = find(bAll.highB == "b450");
bAll.highB1(ind) = repmat(450,size(ind));
ind = find(bAll.highB == "b550");
bAll.highB1(ind) = repmat(550,size(ind));
ind = find(bAll.highB == "b650");
bAll.highB1(ind) = repmat(650,size(ind));

%% only neeeded if the tech names haven't been corrected already
%{ 
% a = find(b15.tech == "Nav-ST");
% n = strcat({char(hex2dec('200A'))},{'1-Nav'});
% new = repmat(n,size(a));
% b15.tech(a) = new;
% a = find(b15.tech == "CS-ST");
% new = repmat({'Multi-Nav'},size(a));
% b15.tech(a) = new;
% b15.tech = removecats(b15.tech);
% 
% a = find(b50.tech == "Nav-ST");
% n = strcat({char(hex2dec('200A'))},{'1-Nav'});
% new = repmat(n,size(a));
% b50.tech(a) = new;
% a = find(b50.tech == "CS-ST");
% new = repmat({'Multi-Nav'},size(a));
% b50.tech(a) = new;
% b50.tech = removecats(b50.tech);
% 
% a = find(b350.tech == "Nav-ST");
% n = strcat({char(hex2dec('200A'))},{'1-Nav'});
% new = repmat(n,size(a));
% b350.tech(a) = new;
% a = find(b350.tech == "CS-ST");
% new = repmat({'Multi-Nav'},size(a));
% b350.tech(a) = new;
% b350.tech = removecats(b350.tech);
%}
%%
fprintf('********* all ref b-value 15,50,350 s/mm^2 *******\n');
tbl2 = bAll(:,[1:5 24:25]);
outl_sd = 4;
mdl = 2;
display_on = 0;

%% MD
%{
type = 'MD';
tbl = [tbl2 bAll(:,type) bAll(:,[type 'std'])];
[av,med,quant,skew,kurt] = descriptive_statistics(tbl,type,outl_sd,display_on);
[lme,coeff,latLME] = lmem(tbl,type,outl_sd,mdl,display_on);
[tblSumm,tblMain,tblBval,tblAll,tblSE,latTech,latBval] = sigInt(tbl,type,outl_sd,mdl);
%}

%% AD
%{
type = 'AD';
tbl = [tbl2 bAll(:,type) bAll(:,[type 'std'])];
[av,med,quant,skew,kurt] = descriptive_statistics(tbl,type,outl_sd,display_on);
[lme,coeff,latLME] = lmem(tbl,type,outl_sd,mdl,display_on);
[tblSumm,tblMain,tblBval,tblAll,tblSE,latTech,latBval] = sigInt(tbl,type,outl_sd,mdl);
%}

%% RD
%{
type = 'RD';
tbl = [tbl2 bAll(:,type) bAll(:,[type 'std'])];
[av,med,quant,skew,kurt] = descriptive_statistics(tbl,type,outl_sd,display_on);
[lme,coeff,latLME] = lmem(tbl,type,outl_sd,mdl,display_on);
[tblSumm,tblMain,tblBval,tblAll,tblSE,latTech,latBval] = sigInt(tbl,type,outl_sd,mdl);
%}

%% FA
%{
type = 'FA';
tbl = [tbl2 bAll(:,type) bAll(:,[type 'std'])];
[av,med,quant,skew,kurt] = descriptive_statistics(tbl,type,outl_sd,display_on);
[lme,coeff,latLME] = lmem(tbl,type,outl_sd,mdl,display_on);
[tblSumm,tblMain,tblBval,tblAll,tblSE,latTech,latBval] = sigInt(tbl,type,outl_sd,mdl);
%}

%% HAg
% %{
type = 'HAg';
tbl = [tbl2 bAll(:,type) bAll(:,[type 'std'])];
[av,med,quant,skew,kurt] = descriptive_statistics(tbl,type,outl_sd,display_on);
[lme,coeff,latLME] = lmem(tbl,type,outl_sd,mdl,display_on);
[tblSumm,tblMain,tblBval,tblAll,tblSE,latTech,latBval] = sigInt(tbl,type,outl_sd,mdl);
%}

%% HAd
% %{
type = 'HAd';
tbl = [tbl2 bAll(:,type) bAll(:,[type 'std'])];
[av,med,quant,skew,kurt] = descriptive_statistics(tbl,type,outl_sd,display_on);
[lme,coeff,latLME] = lmem(tbl,type,outl_sd,mdl,display_on);
[tblSumm,tblMain,tblBval,tblAll,tblSE,latTech,latBval] = sigInt(tbl,type,outl_sd,mdl);
%}