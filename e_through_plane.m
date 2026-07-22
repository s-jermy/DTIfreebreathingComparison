dataDir = '/Volumes/mri/UserFolders/Steve/DiffusionData/_full_/oxford';

files={
    fullfile(dataDir,'20180627_O3TPR_CD01_10258','114_sj_ep2d_diff_nav_steve'),...          #1-1
    fullfile(dataDir,'20180628_O3TPR_CD11-01_10275','91_sj_ep2d_diff_nav_steve'),...        #2-2
    fullfile(dataDir,'20180629_O3TPR_C11-01_10286','94_sj_ep2d_diff_nav_steve_td225'),...   #3-3 -max
    fullfile(dataDir,'20180629_O3TPR_C11-01_10286','102_sj_ep2d_diff_nav_steve_td225'),...  #4-3 -max
    fullfile(dataDir,'20200923_O3TPR_CD01_16789','25_sj_ep2d_diff_nav_steve'),...           #5-4
    fullfile(dataDir,'20200923_O3TPR_CD01_16789','28_sj_ep2d_diff_nav_steve'),...           #6-4
    fullfile(dataDir,'20201021_O3TPR_CD01_17059','21_sj_ep2d_diff_nav_steve'),...           #7-5 -min
    fullfile(dataDir,'20201021_O3TPR_CD01_17059','24_sj_ep2d_diff_nav_steve'),...           #8-5 -min
    fullfile(dataDir,'20211125_O3TPR_CD01_20632','15_sj_ep2d_diff_nav_steve'),...           #9-6 -mean
    fullfile(dataDir,'20211125_O3TPR_CD01_20632','22_sj_ep2d_diff_nav_steve'),...           #10-6 -mean
    fullfile(dataDir,'20211222_O3TPR_CD01_20877','23_sj_ep2d_diff_nav_steve'),...           #11-7
    fullfile(dataDir,'20211222_O3TPR_CD01_20877','26_sj_ep2d_diff_nav_steve'),...           #12-7
    fullfile(dataDir,'20220119_O3TPR_CD01_21026','15_sj_ep2d_diff_nav_steve'),...           #13-8
    fullfile(dataDir,'20220119_O3TPR_CD01_21026','18_sj_ep2d_diff_nav_steve'),...           #14-8
    fullfile(dataDir,'20220304_O3TPR_CD01_7777','31_sj_ep2d_diff_nav_steve'),...            #15-9
    fullfile(dataDir,'20220304_O3TPR_CD01_7777','34_sj_ep2d_diff_nav_steve'),...            #16-9
    fullfile(dataDir,'20220408_O3TPR_C21-06_21735','40_sj_ep2d_diff_nav_steve'),...         #17-10
    fullfile(dataDir,'20220408_O3TPR_C21-06_21735','43_sj_ep2d_diff_nav_steve'),...         #18-10
    fullfile(dataDir,'20250226_O3TPR_C21-06_26200','24_sj_ep2d_diff_nav_steve')...          #19-11
};

minnum = 17;
edges2 = repmat(1:68,length(files),1);
sz = size(edges2);
Nsum2 = zeros(sz(1),sz(2)-1);

%for i = 1:length(files)
i=4;
    dirlisting = dir(fullfile(files{i},'**')); %find all in the main directory including subfolders
    notdir = arrayfun(@(x) ~x.isdir,dirlisting);
    dirlisting = dirlisting(notdir); %remove folders
    
    [~,~,ext] = arrayfun(@(x) fileparts(x.name),dirlisting,'UniformOutput',false);
    validExt = {'.ima', '.dcm'};
    valid = cellfun(@(x) ismember(x, validExt), lower(ext));
    dirlisting = dirlisting(valid); %remove non-dicom files

    Nsum = 0;
    allpos(i).pos = [];  % convert from pos to actual navigator position (209 - pos + minnum)
    l = length(dirlisting);
    for j = 12:l %skip the first set of training data
        try
            % dcmInfo = dicominfo(fullfile(dirlisting(end).folder,dirlisting(end).name));
            dcmInfo = dicominfo(fullfile(dirlisting(j).folder,dirlisting(j).name));
        catch
            fprintf('%s is not a dicom file\n',dirlisting(j).name); %hopefully this shouldn't happen
            % fprintf('%s is not a dicom file\n',dirlisting(end).name); %hopefully this shouldn't happen
            continue
        end
        image = double(dicomread(dcmInfo));

        if j~=l
            % figure(1); imagesc(image);colormap gray;axis equal;
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
        else
            figure(1); imagesc(image);colormap gray;axis equal;
            histImg = image;
            [r,c] = find(histImg==2000);
            boundsx = c(1):c(end);
            boundsy = 31:(min(r)-1);
            search = histImg(boundsy,boundsx);
            sz = size(search);
            [rr,cc] = find(search==1000);

            [uc,ia,~] = unique(cc);
            count = rr(ia);
            count = sz(1)-count+1;

            idx = 1;
            for k=1:size(edges2,2)-1
                if idx<=length(uc) && edges2(i,k)==uc(idx)
                    Nsum2(i,k) = count(idx);
                    idx = idx+1;
                end
            end
            isHigh = (Nsum>0);
            d = diff([0 isHigh 0]);
            startIdx = find(d == 1);  % Start of high-value segments
            endIdx = find(d == -1) - 1;  % End of high-value segments
            segmentLengths = endIdx - startIdx + 1;

            Csum = normalize(cumsum(Nsum),"range");
            q025_idx = find(Csum >= 0.025, 1, 'first');
            q05_idx = find(Csum >= 0.05, 1, 'first');
            q25_idx = find(Csum >= 0.25, 1, 'first');
            q75_idx = find(Csum >= 0.75, 1, 'first');
            q95_idx = find(Csum >= 0.95, 1, 'first');
            q975_idx = find(Csum >= 0.975, 1, 'first');
            binCenters = (edges(1:end-1) + edges(2:end)) / 2;
            q025_value = binCenters(q025_idx);
            q05_value = binCenters(q05_idx);
            q25_value = binCenters(q25_idx);
            q75_value = binCenters(q75_idx);
            q95_value = binCenters(q95_idx);
            q975_value = binCenters(q975_idx);
            value_iqr = q75_value - q25_value; %determine range of middle 50%
            value_90 = q95_value - q05_value; %determine range of middle 90%
            value_95 = q975_value - q025_value; %determine range of middle 95%
            iqrLength(i) = value_iqr;
            midLength(i) = value_90;
            twoSdLength(i) = value_95;
            maxzLength(i) = max(segmentLengths, [], 'omitnan');  % Get the largest segment
            figure(3);histogram('BinEdges',edges,'BinCounts',Nsum)
        end
    end
% end

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

%load('wspace.mat')

maxzLength = 0.6*zcomp.*maxLength;
[mind,maxd] = bounds(maxzLength);
maxzLength(3) = mean(maxzLength(3:4));
maxzLength(5) = mean(maxzLength(5:6));
maxzLength(7) = mean(maxzLength(7:8));
maxzLength(9) = mean(maxzLength(9:10));
maxzLength(11) = mean(maxzLength(11:12));
maxzLength(13) = mean(maxzLength(13:14));
maxzLength(15) = mean(maxzLength(15:16));
maxzLength(17) = mean(maxzLength(17:18));
maxzLength([4 6 8 10 12 14 16 18]) = [];
meand = mean(maxzLength);
stdd = std(maxzLength);