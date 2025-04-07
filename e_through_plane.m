dataDir = '/Volumes/mri/UserFolders/Steve/DiffusionData/_full_/oxford';

files={
    fullfile(dataDir,'20180627_O3TPR_CD01_10258','114_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20180628_O3TPR_CD11-01_10275','91_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20180629_O3TPR_C11-01_10286','94_sj_ep2d_diff_nav_steve_td225'),...
    fullfile(dataDir,'20180629_O3TPR_C11-01_10286','102_sj_ep2d_diff_nav_steve_td225'),...
    fullfile(dataDir,'20200923_O3TPR_CD01_16789','25_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20200923_O3TPR_CD01_16789','28_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20201021_O3TPR_CD01_17059','21_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20201021_O3TPR_CD01_17059','24_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20211125_O3TPR_CD01_20632','15_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20211125_O3TPR_CD01_20632','22_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20211222_O3TPR_CD01_20877','23_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20211222_O3TPR_CD01_20877','26_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20220119_O3TPR_CD01_21026','15_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20220119_O3TPR_CD01_21026','18_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20220304_O3TPR_CD01_7777','31_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20220304_O3TPR_CD01_7777','34_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20220408_O3TPR_C21-06_21735','40_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20220408_O3TPR_C21-06_21735','43_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20250226_O3TPR_C21-06_26200','24_sj_ep2d_diff_nav_steve')...
};

minnum = 17;

for i = 1:length(files)
    dirlisting = dir(fullfile(files{i},'**')); %find all in the main directory including subfolders
    notdir = arrayfun(@(x) ~x.isdir,dirlisting);
    dirlisting = dirlisting(notdir); %remove folders
    
    [~,~,ext] = arrayfun(@(x) fileparts(x.name),dirlisting,'UniformOutput',false);
    validExt = {'.ima', '.dcm'};
    valid = cellfun(@(x) ismember(x, validExt), ext);
    dirlisting = dirlisting(valid); %remove non-dicom files

    Nsum = 0;
    allpos(i).pos = [];
    for j = 1:length(dirlisting)
        try
            % dcmInfo = dicominfo(fullfile(dirlisting(end).folder,dirlisting(end).name));
            dcmInfo = dicominfo(fullfile(dirlisting(j).folder,dirlisting(j).name));
        catch
            fprintf('%s is not a dicom file\n',dirlisting(j).name); %hopefully this shouldn't happen
            % fprintf('%s is not a dicom file\n',dirlisting(end).name); %hopefully this shouldn't happen
            continue
        end
        image = double(dicomread(dcmInfo));
        if j==1
            figure(1); imagesc(image);colormap gray;axis equal;
        end

        if j~=length(dirlisting)
            boundsx = 30:221;boundsy = 31:239;
            traceImg = image(boundsy,boundsx);
            % figure(2);imagesc(traceImg==1024);
            [r,c] = find(traceImg==1024);
            %midy = range(boundsy)/2+min(boundsy);
            bins = 7;
            pos = r(1:bins:end);
            allpos(i).pos = [allpos(i).pos; pos];
            [N,edges] = histcounts(r,[0 (boundsy-min(boundsy)+1)]);
            Nsum = Nsum+fliplr(N)/bins;
            edges = edges+minnum;
            % figure(3);histogram('BinEdges',edges,'BinCounts',Nsum)
        else
            histImg = image;
        
            [r,c] = find(histImg==2000);
            oneline = histImg(min(r)-1,min(c):max(c));
            hv = max(oneline);
            isHigh = (oneline==hv);
            d = diff([0 isHigh 0]);
            startIdx = find(d == 1);  % Start of high-value segments
            endIdx = find(d == -1) - 1;  % End of high-value segments
            segmentLengths = endIdx - startIdx + 1;
            maxLength(i) = max(segmentLengths, [], 'omitnan');  % Get the largest segment
        end
    end
end

files={
    fullfile(dataDir,'20180627_O3TPR_CD01_10258','115_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20180628_O3TPR_CD11-01_10275','92_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20180629_O3TPR_C11-01_10286','95_sj_ep2d_diff_nav_steve_td225'),...
    fullfile(dataDir,'20180629_O3TPR_C11-01_10286','103_sj_ep2d_diff_nav_steve_td225'),...
    fullfile(dataDir,'20200923_O3TPR_CD01_16789','26_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20200923_O3TPR_CD01_16789','29_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20201021_O3TPR_CD01_17059','22_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20201021_O3TPR_CD01_17059','25_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20211125_O3TPR_CD01_20632','16_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20211125_O3TPR_CD01_20632','23_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20211222_O3TPR_CD01_20877','24_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20211222_O3TPR_CD01_20877','27_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20220119_O3TPR_CD01_21026','16_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20220119_O3TPR_CD01_21026','19_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20220304_O3TPR_CD01_7777','32_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20220304_O3TPR_CD01_7777','35_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20220408_O3TPR_C21-06_21735','41_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20220408_O3TPR_C21-06_21735','44_sj_ep2d_diff_nav_steve'),...
    fullfile(dataDir,'20250226_O3TPR_C21-06_26200','25_sj_ep2d_diff_nav_steve')...
};

for i = 1:length(files)
    dirlisting = dir(fullfile(files{i},'**')); %find all in the main directory including subfolders
    notdir = arrayfun(@(x) ~x.isdir,dirlisting);
    dirlisting = dirlisting(notdir); %remove folders
    
    [~,~,ext] = arrayfun(@(x) fileparts(x.name),dirlisting,'UniformOutput',false);
    validExt = {'.ima', '.dcm'};
    valid = cellfun(@(x) ismember(x, validExt), ext);
    dirlisting = dirlisting(valid); %remove non-dicom files
    
    try
        dcmInfo = dicominfo(fullfile(dirlisting(1).folder,dirlisting(1).name));
    catch
        fprintf('%s is not a dicom file\n',dirlisting(1).name); %hopefully this shouldn't happen
        continue
    end
    image = double(dicomread(dcmInfo));
    
    iop = dcmInfo.ImageOrientationPatient;
    zcomp(i) = dot([0;0;1],cross(iop(1:3),iop(4:6)));
end

maxDisplacement = 0.6*zcomp.*maxLength;
maxDisplacement(3) = mean(maxDisplacement(3:4));
maxDisplacement(5) = mean(maxDisplacement(5:6));
maxDisplacement(7) = mean(maxDisplacement(7:8));
maxDisplacement(9) = mean(maxDisplacement(9:10));
maxDisplacement(11) = mean(maxDisplacement(11:12));
maxDisplacement(13) = mean(maxDisplacement(13:14));
maxDisplacement(15) = mean(maxDisplacement(15:16));
maxDisplacement(17) = mean(maxDisplacement(17:18));
maxDisplacement([4 6 8 10 12 14 16 18]) = [];
[mind,maxd] = bounds(maxDisplacement);
meand = mean(maxDisplacement);
stdd = std(maxDisplacement);