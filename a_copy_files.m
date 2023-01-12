main = 'D:\Steve\OneDrive - University of Cape Town\Documents'; %main directory - may vary
load1 = fullfile(main,'MATLAB','DTIanalysis'); %base directory to load from
save1 = fullfile(main,'PhD','Papers'); %base directory to save to
l_rej = 'RejectImages';
l_bas = 'Systole_Base';
l_mid = 'Systole_Mid';
l_ape = 'Systole_Apex';

load2 = uigetdir(load1,'Choose folder to load from...');
temp = split(load2,filesep);
save2 = uigetdir(save1,'Choose folder to save to...');
save2 = fullfile(save2,'data');

list = dir(load2);
list = list(3:end); %remove . .. directories

copyImages = 0; %1;

%% main loop
for j = 1:length(list)
    %% get subject and list methods
    l_subj = list(j).name;
    s_subj = l_subj;
    
    %some mislabeled subjects to look out for
    if strcmp(temp{end},'steve_oxford_2021')
        if strcmp(l_subj,'O3TPR_C00-00_21261')
            s_subj = 'O3TPR_CD01_20877';
        elseif strcmp(l_subj,'O3TPR_CD01_1234')
            s_subj = 'O3TPR_CD01_20632';
        elseif strcmp(l_subj,'O3TPR_CD01_7777')
            s_subj = 'O3TPR_CD01_20769';
        end
    end
    
    list2 = dir(fullfile(load2,l_subj));
    list2 = list2(3:end);
    
    %% copy spreadsheet of results (and images) out of each methods folder
    for i = 1:length(list2)
        l_meth = list2(i).name;
        s_meth = l_meth;
        
        %mislabeled methods
        if strcmp(temp{end},'steve_oxford_2021')
            if strcmp(l_subj,'O3TPR_C00-00_21261')
                s_meth = s_meth(1:end-1); %remove trailing 2 from some method names
            end
        end
        
        l_file = fullfile(load2,l_subj,l_meth,[l_meth '.xlsx']);
        s_fold = fullfile(save2,s_subj,s_meth);
        
        warning('off','MATLAB:MKDIR:DirectoryExists')
        status = mkdir(s_fold);
        warning('on','MATLAB:MKDIR:DirectoryExists')
        try
            copyfile(l_file,s_fold);
        catch
        end
        
        %% not every experiment has base mid and apex images
        if copyImages
            l_temp = fullfile(load2,l_subj,l_meth);
            
            load3 = fullfile(l_temp,l_rej);
            save3 = fullfile(s_fold,l_rej);
            try
                copyfile(load3,save3);
            catch
            end
            
            load3 = fullfile(l_temp,l_bas);
            save3 = fullfile(s_fold,l_bas);
            try
                copyfile(load3,save3);
            catch
            end
            
            load3 = fullfile(l_temp,l_mid);
            save3 = fullfile(s_fold,l_mid);
            try
                copyfile(load3,save3);
            catch
            end
            
            load3 = fullfile(l_temp,l_ape);
            save3 = fullfile(s_fold,l_ape);
            try
                copyfile(load3,save3);
            catch
            end
        end
    end
end