main = uigetdir('D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers');
listing = dir(fullfile(main,'**','*.xlsx'));
len = length(listing);
fname = ['dti_' datestr(today,'yyyymmdd') '.xlsx'];

T = table;T2 = table;

for i = 1:len
    xlfile = fullfile(listing(i).folder,listing(i).name);
    ds = spreadsheetDatastore(xlfile);
    sheets = sheetnames(ds,1);
    
    t = split(listing(i).folder,filesep);
    tok = split(t(end),'_');
    for j = 1:length(sheets)
        warning('off','MATLAB:table:ModifiedVarnames');
        ds.Sheets = j;
        ds.Range = '';
        ds.ReadVariableNames = 1;
        if j>1
            ds.NumHeaderLines = 5;
        end
        tbl = read(ds);
        tbl = tbl(:,2:end);
        
        if j==1
            ds.Sheets = 2;
        end
        ds.Range = 'B1:B1';
        ds.NumHeaderLines = 0;
        ds.ReadVariableNames = 0;
        ID = read(ds);
        ID = ID{1,1};
        warning('on','MATLAB:table:ModifiedVarnames');
        
        if strcmp(ID,'O3TPR_C00-00_21261')
            ID = {'O3TPR_CD01_20877'};
        elseif strcmp(ID,'O3TPR_CD01_1234')
            ID = {'O3TPR_CD01_20632'};
        elseif strcmp(ID,'O3TPR_CD01_7777')
            ID = {'O3TPR_CD01_20769'};
        end

        h = height(tbl);
        ID = repmat(ID,h,1);
        tech = repmat(tok(end),h,1);
        if j>1
            tok2 = split(sheets(j),'_');
            lowB = repmat({tok2{1}},h,1);
            highB = repmat({tok2{2}},h,1);
            slice = repmat({tok2{3}},h,1);
            segment = (1:h);
            tbl2 = table(ID,tech,slice,lowB,highB,segment','VariableNames',{'ID','tech','Slice','lowB','highB','segment'});
            T = [T;tbl2 tbl];
        else
            tbl2 = table(ID,tech,'VariableNames',{'ID','tech'});
            T2 = [T2;tbl2 tbl];
        end
    end
end

%%
lowB = T.lowB;
lowB2 = T2.lowB;
ind = find(lowB == "b15");lowB(ind) = repmat({'b015'},size(ind));
ind = find(lowB == "b50");lowB(ind) = repmat({'b050'},size(ind));
ind = find(lowB2 == "b15");lowB2(ind) = repmat({'b015'},size(ind));
ind = find(lowB2 == "b50");lowB2(ind) = repmat({'b050'},size(ind));
T.lowB = lowB;
T2.lowB = lowB2;

[~,~,ic] = unique(categorical(T.tech));
T.tech = ic;
[~,~,ic] = unique(categorical(T2.tech));
T2.tech = ic;

%% remove extra entry in segment sheet (average of myocardium)
exclude = find(ismember(T.segment,7))';
T(exclude,:) = [];

%% write segments
exclude = find(ismember(T.lowB,'b350') & ismember(T.highB,'b450'))';
if isempty(exclude)
    exclude = find(ismember(T.lowB,'b015') & ismember(T.highB,'b450'))';
end
T(exclude,:) = [];

warning('off','MATLAB:xlswrite:AddSheet');
writetable(T,fullfile(main,fname),'Sheet',1);
warning('on','MATLAB:xlswrite:AddSheet');

%% write global
exclude = find(ismember(T2.lowB,'b350') & ismember(T2.highB,'b450'))';
if isempty(exclude)
    exclude = find(ismember(T2.lowB,'b015') & ismember(T2.highB,'b450'))';
end
T2(exclude,:) = [];

warning('off','MATLAB:xlswrite:AddSheet');
writetable(T2,fullfile(main,fname),'Sheet',2);
warning('on','MATLAB:xlswrite:AddSheet');