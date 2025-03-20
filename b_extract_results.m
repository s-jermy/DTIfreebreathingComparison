if ismac
    main = uigetdir('/Users/steve/Library/CloudStorage/OneDrive-UniversityofCapeTown/Documents/PhD/Papers');
else
    main = uigetdir('D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers'); %base of main directory
end
listing = dir(fullfile(main,'**','*.xlsx')); %find all spreadsheets in the main directory including subfolders
listing = listing(~contains({listing.name},'data_'));
len = length(listing);
fname = ['data_' char(datetime("today",'Format','yyyyMMdd')) '.xlsx']; %file name

tbl_segment = table;
tbl_slice = table;

%% main loop - extract results from each spreasheet
for i = 1:len
    xlfile = fullfile(listing(i).folder,listing(i).name);
    ds = spreadsheetDatastore(xlfile);
    sheets = sheetnames(ds,1);
    
    t = split(listing(i).folder,filesep);
    
    %% each spreadsheet may be composed of multiple sheets
    for j = 1:length(sheets)
        warning('off','MATLAB:table:ModifiedVarnames');
        ds.Sheets = j; %go sheet by sheet
        ds.Range = ''; %entire range
        ds.ReadVariableNames = 1;
        
        tbl_result = read(ds);
        tbl_result(:,1) = []; %remove first column (phase or Row (segment))
        
        ID = t(end-1);
        tech = t(end);
        warning('on','MATLAB:table:ModifiedVarnames');
        
        %exceptions to look out for
        if strcmp(ID,'O3TPR_C00-00_21261')
            ID = "O3TPR_CD01_20877";
        elseif strcmp(ID,'O3TPR_CD01_1234')
            ID = "O3TPR_CD01_20632";
        elseif strcmp(ID,'O3TPR_CD01_7777')
            ID = "O3TPR_CD01_20769";
        elseif strcmp(ID,'STEVE_DTI_01STEVE_DTI_014')
            ID = "STEVE_DTI_014";
        end
        
        %% replicate missing info and create complete tables
        h = height(tbl_result);
        ID = repmat(ID,h,1);
        tech = repmat(tech,h,1);
        if ~strcmp(sheets(j),'Summary')
            tok2 = split(sheets(j),'_'); %tokenise name of sheet to get b-values and slice
            lowB = repmat(tok2(1),h,1);
            highB = repmat(tok2(2),h,1);
            slice = repmat(tok2(3),h,1);
            segment = (1:h);
            if strcmp(tok2{3},'Mid')
                segment = segment+6;
            elseif strcmp(tok2{3},'Apex')
                segment = segment+12;
            end
            tbl_info = table(ID,tech,slice,lowB,highB,segment','VariableNames',{'id','tech','Slice','lowB','highB','segment'});
            tbl_segment = [tbl_segment;tbl_info tbl_result];
            tbl_segment(end,:) = []; %remove average row
        else
            tbl_info = table(ID,tech,'VariableNames',{'ID','tech'});
            tbl_slice = [tbl_slice;tbl_info tbl_result];
        end
    end
end

%% convert MD, AD, RD to um^2/ms
tbl_segment(:,{'MD','MDstd','AD','ADstd','RD','RDstd'}) = tbl_segment(:,{'MD','MDstd','AD','ADstd','RD','RDstd'}).*1000;
tbl_slice(:,{'MD','MDstd','AD','ADstd','RD','RDstd'}) = tbl_slice(:,{'MD','MDstd','AD','ADstd','RD','RDstd'}).*1000;

%% rename b-values and enumerate techniques
lowB = tbl_segment.lowB;
lowB2 = tbl_slice.lowB;
ind = find(lowB == "b15");lowB(ind) = repmat({'b015'},size(ind));
ind = find(lowB == "b50");lowB(ind) = repmat({'b050'},size(ind));
ind = find(lowB2 == "b15");lowB2(ind) = repmat({'b015'},size(ind));
ind = find(lowB2 == "b50");lowB2(ind) = repmat({'b050'},size(ind));
tbl_segment.lowB = lowB;
tbl_slice.lowB = lowB2;

[~,~,ic] = unique(categorical(tbl_segment.tech));
tbl_segment.tech = ic;
[~,~,ic] = unique(categorical(tbl_slice.tech));
tbl_slice.tech = ic;

%% remove extra entry in segment sheet (average of myocardium)
% exclude = find(ismember(tbl_seg.segment,7))';
% tbl_seg(exclude,:) = [];

%% write segment sheet
exclude = find(ismember(tbl_segment.lowB,'b350') & ismember(tbl_segment.highB,'b450'))';
exclude2 = find(ismember(tbl_segment.lowB,'b015'))';
if isempty(exclude)
    exclude = find(ismember(tbl_segment.lowB,'b015') & ismember(tbl_segment.highB,'b450'))';
    exclude2 = [];
end
tbl_segment([exclude exclude2],:) = [];

warning('off','MATLAB:xlswrite:AddSheet');
writetable(tbl_segment,fullfile(main,fname),'Sheet','segment');
warning('on','MATLAB:xlswrite:AddSheet');

%% write slice sheet
exclude = find(ismember(tbl_slice.lowB,'b350') & ismember(tbl_slice.highB,'b450'))';
exclude2 = find(ismember(tbl_slice.lowB,'b015'))';
if isempty(exclude)
    exclude = find(ismember(tbl_slice.lowB,'b015') & ismember(tbl_slice.highB,'b450'))';
    exclude2 = [];
end
tbl_slice([exclude exclude2],:) = [];

warning('off','MATLAB:xlswrite:AddSheet');
writetable(tbl_slice,fullfile(main,fname),'Sheet','slice');
warning('on','MATLAB:xlswrite:AddSheet');