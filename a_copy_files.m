if ismac
    main = '/Users/steve/Library/CloudStorage/OneDrive-UniversityofCapeTown/Documents';
else
    main = 'D:\Steve\OneDrive - University of Cape Town\Documents'; %base of main directory
end
load1 = fullfile(main,'MATLAB','DTIanalysis','output'); %base directory to load from
save1 = fullfile(main,'PhD','Papers'); %base directory to save to
l_rej = 'RejectImages';
l_bas = 'Systole_Base';
l_mid = 'Systole_Mid';
l_ape = 'Systole_Apex';

load2 = uigetdir(load1,'Choose folder to load from...');
temp = split(load2,filesep);
save2 = uigetdir(save1,'Choose folder to save to...');
save2 = fullfile(save2,'resources','data');

listing = dir(load2);
listing = listing([listing.isdir]);
listing = listing(~ismember({listing.name},{'.','..'}));

copyImages = 1; %0;

%% main loop
for j = 1:length(listing)
    %% get subject and list methods
    l_subj = listing(j).name;
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
    elseif contains(temp{end},'steve_cubic')
        if strcmp(l_subj,'STEVE_DTI_01STEVE_DTI_014')
            s_subj = 'STEVE_DTI_014';
        end
    elseif contains(temp{end},'steve_cmo')
        switch j
            case 1
                s_subj = 'PATIENT1';
            case 2
                s_subj = 'PATIENT6';
            case 3
                s_subj = 'PATIENT5';
            case 4
                s_subj = 'PATIENT3';
            case 5
                s_subj = 'PATIENT4';
        end
    end
    
    listing2 = dir(fullfile(load2,l_subj,'*','Paths.mat'));
    
    %% copy spreadsheet of results (and images) out of each methods folder
    for i = 1:length(listing2)
        f = listing2(i).folder;
        temp2 = split(f,filesep);
        load(fullfile(f,listing2(i).name),"analysisTag");

        l_meth = analysisTag;
        s_meth = temp2{end};
        
        %%mislabeled methods
        % if strcmp(temp{end},'steve_oxford_2021')
        %     if strcmp(l_subj,'O3TPR_C00-00_21261')
        %         s_meth = s_meth(1:end-1); %remove trailing 2 from some method names
        %     end
        % end
        
        l_file = fullfile(f,l_meth,[l_meth '.xlsx']);
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
            l_temp = fullfile(f,l_meth);
            
            load3 = fullfile(l_temp,l_rej);
            save3 = fullfile(s_fold,l_rej);
            if ~exist(save3,'dir')
                mkdir(save3);
            end
            copyimages(load3,save3);
            
            load3 = fullfile(l_temp,l_bas);
            save3 = fullfile(s_fold,l_bas);
            if ~exist(save3,'dir')
                mkdir(save3);
            end
            copyimages(load3,save3);
            
            load3 = fullfile(l_temp,l_mid);
            save3 = fullfile(s_fold,l_mid);
            if ~exist(save3,'dir')
                mkdir(save3);
            end
            copyimages(load3,save3);
            
            load3 = fullfile(l_temp,l_ape);
            save3 = fullfile(s_fold,l_ape);
            if ~exist(save3,'dir')
                mkdir(save3);
            end
            copyimages(load3,save3);
        end
    end
end

function copyimages(load,save)
    files = dir(fullfile(load,'**'));

    % remove folders
    files = files(~[files.isdir]);
    
    for f_idx = 1:length(files)
        [~,~,ext] = fileparts(files(f_idx).name);
        
        % skip .fig files
        if strcmpi(ext, '.fig')
            continue
        end
        
        src = fullfile(files(f_idx).folder, files(f_idx).name);
        dst = save;
        
        try
            copyfile(src, dst);
        catch
        end
    end
end