main = uigetdir('D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers'); %base of main directory
listing = dir(fullfile(main,'**','*.xlsx')); %find all spreadsheets in the main directory including subfolders
len = length(listing);
fname = ['dti_' datestr(today,'yyyymmdd') '.xlsx']; %file name

tbl_seg = table; 
tbl_glo = table;

%% main loop - extract results from each spreasheet
for i = 1:len
    xlfile = fullfile(listing(i).folder,listing(i).name);
    ds = spreadsheetDatastore(xlfile);
    sheets = sheetnames(ds,1);
    
    t = split(listing(i).folder,filesep);
    tok = split(t(end),'_'); %tokenise folder name to get tech name
    
    %% each spreadsheet may be composed of multiple sheets
    for j = 1:length(sheets)
        warning('off','MATLAB:table:ModifiedVarnames');
        ds.Sheets = j; %go sheet by sheet
        ds.Range = ''; %entire range
        ds.ReadVariableNames = 1;
        if j>1
            ds.NumHeaderLines = 5; %skip 5 lines to find the header
        end
        tbl_res = read(ds);
        tbl_res = tbl_res(:,2:end); %remove first column
        
        %first sheet doesn't have an ID
        if j==1
            ds.Sheets = 2;
        end
        ds.Range = 'B1:B1'; %copy from single cell
        ds.NumHeaderLines = 0;
        ds.ReadVariableNames = 0; %ignore headers
        ID = read(ds);
        ID = ID{1,1};
        warning('on','MATLAB:table:ModifiedVarnames');
        
        %exceptions to look out for
        if strcmp(ID,'O3TPR_C00-00_21261')
            ID = {'O3TPR_CD01_20877'};
        elseif strcmp(ID,'O3TPR_CD01_1234')
            ID = {'O3TPR_CD01_20632'};
        elseif strcmp(ID,'O3TPR_CD01_7777')
            ID = {'O3TPR_CD01_20769'};
        end
        
        %% replicate missing info and create complete tables
        h = height(tbl_res);
        ID = repmat(ID,h,1);
        tech = repmat(tok(end),h,1);
        if j>1
            tok2 = split(sheets(j),'_'); %tokenise name of sheet to get b-values and slice
            lowB = repmat({tok2{1}},h,1);
            highB = repmat({tok2{2}},h,1);
            slice = repmat({tok2{3}},h,1);
            segment = (1:h);
            tbl_inf = table(ID,tech,slice,lowB,highB,segment','VariableNames',{'ID','tech','Slice','lowB','highB','segment'});
            tbl_seg = [tbl_seg;tbl_inf tbl_res];
        else
            tbl_inf = table(ID,tech,'VariableNames',{'ID','tech'});
            tbl_glo = [tbl_glo;tbl_inf tbl_res];
        end
    end
end

%% rename b-values and enumerate techniques
lowB = tbl_seg.lowB;
lowB2 = tbl_glo.lowB;
ind = find(lowB == "b15");lowB(ind) = repmat({'b015'},size(ind));
ind = find(lowB == "b50");lowB(ind) = repmat({'b050'},size(ind));
ind = find(lowB2 == "b15");lowB2(ind) = repmat({'b015'},size(ind));
ind = find(lowB2 == "b50");lowB2(ind) = repmat({'b050'},size(ind));
tbl_seg.lowB = lowB;
tbl_glo.lowB = lowB2;

[~,~,ic] = unique(categorical(tbl_seg.tech));
tbl_seg.tech = ic;
[~,~,ic] = unique(categorical(tbl_glo.tech));
tbl_glo.tech = ic;

%% remove extra entry in segment sheet (average of myocardium)
exclude = find(ismember(tbl_seg.segment,7))';
tbl_seg(exclude,:) = [];

%% write segment sheet
exclude = find(ismember(tbl_seg.lowB,'b350') & ismember(tbl_seg.highB,'b450'))';
if isempty(exclude)
    exclude = find(ismember(tbl_seg.lowB,'b015') & ismember(tbl_seg.highB,'b450'))';
end
tbl_seg(exclude,:) = [];

warning('off','MATLAB:xlswrite:AddSheet');
writetable(tbl_seg,fullfile(main,fname),'Sheet',1);
warning('on','MATLAB:xlswrite:AddSheet');

%% write global sheet
exclude = find(ismember(tbl_glo.lowB,'b350') & ismember(tbl_glo.highB,'b450'))';
if isempty(exclude)
    exclude = find(ismember(tbl_glo.lowB,'b015') & ismember(tbl_glo.highB,'b450'))';
end
tbl_glo(exclude,:) = [];

warning('off','MATLAB:xlswrite:AddSheet');
writetable(tbl_glo,fullfile(main,fname),'Sheet',2);
warning('on','MATLAB:xlswrite:AddSheet');