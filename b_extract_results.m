files = {...
    'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\STEVE_DTI_002\affreg_HRcorr_dti_BH\affreg_HRcorr_dti_BH.xlsx',...
    'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\STEVE_DTI_002\affreg_HRcorr_dti_CS\affreg_HRcorr_dti_CS.xlsx',...
    'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\STEVE_DTI_004\affreg_HRcorr_dti_BH\affreg_HRcorr_dti_BH.xlsx',...
    'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\STEVE_DTI_004\affreg_HRcorr_dti_CS\affreg_HRcorr_dti_CS.xlsx',...
    'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\STEVE_DTI_006\affreg_HRcorr_dti_BH\affreg_HRcorr_dti_BH.xlsx',...
    'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\STEVE_DTI_006\affreg_HRcorr_dti_CS\affreg_HRcorr_dti_CS.xlsx',...
    'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\STEVE_DTI_008\affreg_HRcorr_dti_BH\affreg_HRcorr_dti_BH.xlsx',...
    'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\STEVE_DTI_008\affreg_HRcorr_dti_CS\affreg_HRcorr_dti_CS.xlsx',...
    'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\STEVE_DTI_009\affreg_HRcorr_dti_BH\affreg_HRcorr_dti_BH.xlsx',...
    'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\STEVE_DTI_009\affreg_HRcorr_dti_CS\affreg_HRcorr_dti_CS.xlsx',...
    'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\STEVE_DTI_010\affreg_HRcorr_dti_BH\affreg_HRcorr_dti_BH.xlsx',...
    'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\STEVE_DTI_010\affreg_HRcorr_dti_CS\affreg_HRcorr_dti_CS.xlsx',...
    'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\STEVE_DTI_011\affreg_HRcorr_dti_BH\affreg_HRcorr_dti_BH.xlsx',...
    'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\STEVE_DTI_011\affreg_HRcorr_dti_CS\affreg_HRcorr_dti_CS.xlsx',...
    'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\STEVE_DTI_012\affreg_HRcorr_dti_BH\affreg_HRcorr_dti_BH.xlsx',...
    'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\STEVE_DTI_012\affreg_HRcorr_dti_CS\affreg_HRcorr_dti_CS.xlsx',...
    'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\STEVE_DTI_013\affreg_HRcorr_dti_BH\affreg_HRcorr_dti_BH.xlsx',...
    'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\STEVE_DTI_013\affreg_HRcorr_dti_CS\affreg_HRcorr_dti_CS.xlsx',...
    'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\STEVE_DTI_01STEVE_DTI_014\affreg_HRcorr_dti_BH\affreg_HRcorr_dti_BH.xlsx',...
    'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\STEVE_DTI_01STEVE_DTI_014\affreg_HRcorr_dti_CS\affreg_HRcorr_dti_CS.xlsx',...
    'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\STEVE_DTI_016\affreg_HRcorr_dti_BH\affreg_HRcorr_dti_BH.xlsx',...
    'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\STEVE_DTI_016\affreg_HRcorr_dti_CS\affreg_HRcorr_dti_CS.xlsx'...
    };
len = length(files);
fname = ['dti_' datestr(today,'yyyymmdd') '.xlsx'];

T = table;T2 = table;
count = 0;

lowB = {'b50'};lowB1 = {'b050'};
highB = {'b450'};
for i = 1:len
    count = count+1;
    for j = 1:3
        switch j
            case 1
                slice = {'Base'};
                range = 'B6:S12';
            case 2
                slice = {'Mid'};
                range = 'B6:S12';
            case 3
                slice = {'Apex'};
                range = 'B6:S10';
                
        end
        sheet = [lowB{1} '_' highB{1} '_' slice{1} '_Sys'];
        
        warning('off','MATLAB:table:ModifiedAndSavedVarnames');
        try
            tbl = readtable(files{i},'Sheet',sheet,'Range',range);
            ID = readcell(files{i},'Sheet',sheet,'Range','B1:B1');
        catch
            warning('sheet does not exist');
            continue
        end
        warning('on','MATLAB:table:ModifiedAndSavedVarnames');
        
        h = height(tbl);
        ID2 = repmat(ID,h,1);
        tech = repmat(count,h,1);
        slice = repmat(slice,h,1);
        lowB2 = repmat(lowB1,h,1);
        highB2 = repmat(highB,h,1);
        segment = (1:h);
        tbl2 = table(ID2,tech,slice,lowB2,highB2,segment','VariableNames',{'ID','tech','Slice','lowB','highB','segment'});
        T = [T;tbl2 tbl];
        %ID tech Slice lowB highB segment MD std FA std AD std RD std HAd std HAg std absE2A std TRA std SA std
    end
    warning('off','MATLAB:table:ModifiedAndSavedVarnames');
    tbl = readtable(files{i},'Sheet','Summary','Range','B1:V7','VariableNamingRule','modify');
    warning('on','MATLAB:table:ModifiedAndSavedVarnames');
    tbl = rmmissing(tbl);
    tbl = tbl(2:2:end,:);
    
    h = height(tbl);
    ID2 = repmat(ID,h,1);
    tech = repmat(count,h,1);    
    tbl2 = table(ID2,tech,'VariableNames',{'ID','tech'});
    T2 = [T2;tbl2 tbl];
    count = mod(count,2);
    %ID tech Slice lowB highB MD std FA std AD std RD std HAd std HAg std absE2A std TRA std SA std
end

%% segments
warning('off','MATLAB:xlswrite:AddSheet');
writetable(T,fname,'Sheet',1);
warning('on','MATLAB:xlswrite:AddSheet');

%% global
lowB = T2.lowB;
ind = find(lowB == "b50");
lowB(ind) = repmat({'b050'},size(ind));
T2.lowB = lowB;

warning('off','MATLAB:xlswrite:AddSheet');
writetable(T2,fname,'Sheet',2);
warning('on','MATLAB:xlswrite:AddSheet');