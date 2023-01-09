main = 'D:\Steve\OneDrive - University of Cape Town\Documents';
load1 = fullfile(main,'MATLAB','DTIanalysis');
save1 = fullfile(main,'PhD','Papers');
l_rej = 'RejectImages';
l_bas = 'Systole_Base';
l_mid = 'Systole_Mid';
l_ape = 'Systole_Apex';

load2 = uigetdir(load1,'Choose folder to load from...');
temp = split(load2,filesep);
save2 = uigetdir(save1,'Choose folder to save to...');
save2 = fullfile(save2,'data');

list = dir(load2);
list = list(3:end);

copyImages = 0; %1;
%%
for j = 1:length(list)    
    l_subj = list(j).name;
    s_subj = l_subj;
    
    list2 = dir(fullfile(load2,l_subj));
    list2 = list2(3:end);
    for i = 1:length(list2)
        l_meth = list2(i).name;
        s_meth = l_meth;
        
        l_file = fullfile(load2,l_subj,l_meth,[l_meth '.xlsx']);
        s_fold = fullfile(save2,s_subj,s_meth);
        
        status = mkdir(s_fold);
        try
            copyfile(l_file,s_fold);
        catch
        end
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