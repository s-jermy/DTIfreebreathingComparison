clear
close all

%% load data
main = uigetdir('D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers'); %base of main directory
listing = dir(fullfile(main,'**','dti_*.xlsx')); %find dti spreadsheet in the main directory including subfolders
xlfile = fullfile(listing(1).folder,listing(1).name);

ds = spreadsheetDatastore(xlfile);
ds.Sheets = 2;
bAll = read(ds);

if max(bAll.tech)==2
    valueset = (1:2); catnames = {'BH','CS'};
elseif max(bAll.tech)==4 
    valueset = (1:4); catnames = {'BH','Gated','1-Nav','Multi-Nav'};
end

bAll.ID = categorical(bAll.ID);
bAll.tech = categorical(bAll.tech,valueset,catnames);
bAll.Slice = categorical(bAll.Slice);
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

%%
tbl_inf = bAll(:,[1:6 25:26]);
outl_sd = 4;
mdl = 2;
display_on = 0;

%% MD
% %{
type = 'MD';
tbl_dat = [tbl_inf bAll(:,type) bAll(:,[type 'std'])];
[av,med,quant,skew,kurt] = descriptive_statistics(tbl_dat,type,outl_sd,display_on);
[p,h] = variance_analysis(tbl_dat,type,outl_sd,display_on);
[lme,coeff,latLME] = lmem(tbl_dat,type,outl_sd,mdl,display_on);
[tblSumm,tblMain,tblBval,tblAll,tblSE,latTech,latBval] = sigInt(tbl_dat,type,outl_sd,mdl);
%}

%% AD
%{
type = 'AD';
tbl_dat = [tbl_inf bAll(:,type) bAll(:,[type 'std'])];
[av,med,quant,skew,kurt] = descriptive_statistics(tbl_dat,type,outl_sd,display_on);
[p,h] = variance_analysis(tbl_dat,type,outl_sd,display_on);
[lme,coeff,latLME] = lmem(tbl_dat,type,outl_sd,mdl,display_on);
[tblSumm,tblMain,tblBval,tblAll,tblSE,latTech,latBval] = sigInt(tbl_dat,type,outl_sd,mdl);
%}

%% RD
%{
type = 'RD';
tbl_dat = [tbl_inf bAll(:,type) bAll(:,[type 'std'])];
[av,med,quant,skew,kurt] = descriptive_statistics(tbl_dat,type,outl_sd,display_on);
[p,h] = variance_analysis(tbl_dat,type,outl_sd,display_on);
[lme,coeff,latLME] = lmem(tbl_dat,type,outl_sd,mdl,display_on);
[tblSumm,tblMain,tblBval,tblAll,tblSE,latTech,latBval] = sigInt(tbl_dat,type,outl_sd,mdl);
%}

%% FA
%{
type = 'FA';
tbl_dat = [tbl_inf bAll(:,type) bAll(:,[type 'std'])];
[av,med,quant,skew,kurt] = descriptive_statistics(tbl_dat,type,outl_sd,display_on);
[p,h] = variance_analysis(tbl_dat,type,outl_sd,display_on);
[lme,coeff,latLME] = lmem(tbl_dat,type,outl_sd,mdl,display_on);
[tblSumm,tblMain,tblBval,tblAll,tblSE,latTech,latBval] = sigInt(tbl_dat,type,outl_sd,mdl);
%}

%% HAg
%{
type = 'HAg';
tbl_dat = [tbl_inf bAll(:,type) bAll(:,[type 'std'])];
[av,med,quant,skew,kurt] = descriptive_statistics(tbl_dat,type,outl_sd,display_on);
[p,h] = variance_analysis(tbl_dat,type,outl_sd,display_on);
[lme,coeff,latLME] = lmem(tbl_dat,type,outl_sd,mdl,display_on);
[tblSumm,tblMain,tblBval,tblAll,tblSE,latTech,latBval] = sigInt(tbl_dat,type,outl_sd,mdl);
%}

%% HAd
%{
type = 'HAd';
tbl_dat = [tbl_inf bAll(:,type) bAll(:,[type 'std'])];
[av,med,quant,skew,kurt] = descriptive_statistics(tbl_dat,type,outl_sd,display_on);
[p,h] = variance_analysis(tbl_dat,type,outl_sd,display_on);
[lme,coeff,latLME] = lmem(tbl_dat,type,outl_sd,mdl,display_on);
[tblSumm,tblMain,tblBval,tblAll,tblSE,latTech,latBval] = sigInt(tbl_dat,type,outl_sd,mdl);
%}