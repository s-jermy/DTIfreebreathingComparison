close all

if ismac
    mainfolder = '/Users/steve/Library/CloudStorage/OneDrive-UniversityofCapeTown/Documents/MATLAB/DTIanalysis/output';
    fname = '/Users/steve/Library/CloudStorage/OneDrive-UniversityofCapeTown/Documents/PhD/Papers';
else
    mainfolder = 'D:\Steve\OneDrive - University of Cape Town\Documents\MATLAB\DTIanalysis\output';
    fname = 'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers'; %
end
%% paper 1
%{
tag = 'steve_oxford'; 
%pid = x; %'O3TPR_CD01_26440';%2rr paper 1

tag = 'steve_oxford_2018'; 
pid = 1; %O3TPR_C11-01_10286%- max paper 1
pid = 3; %O3TPR_CD01_10258
pid = 10; %O3TPR_CD11-01_10275

tag = 'steve_oxford_2020'; 
pid = 4; %O3TPR_CD01_16789
pid = 5; %O3TPR_CD01_17059

tag = 'steve_oxford_2021'; 
pid = 2; %O3TPR_C21-06_21735
pid = 6; %O3TPR_CD01_20632%- average paper 1
pid = 7; %O3TPR_CD01_20769
pid = 8; %O3TPR_CD01_20877
pid = 8; %O3TPR_CD01_21026
%}

%% paper 2
%{
tag = 'steve_cubic';
pid = 1; %'STEVE_DTI_002'
pid = 2; %'STEVE_DTI_005'
pid = 3; %'STEVE_DTI_006'
pid = 4; %'STEVE_DTI_008'
pid = 5; %'STEVE_DTI_009'
pid = 6; %'STEVE_DTI_010'
pid = 7; %'STEVE_DTI_011'
pid = 8; %'STEVE_DTI_012'
pid = 9; %'STEVE_DTI_013' %- paper 2
pid = 10; %'STEVE_DTI_014'
pid = 11; %'STEVE_DTI_016'
%}

%% paper 3
%{
tag = 'steve_cmo';
pid = 1; %P1 %- paper 3
% pid = 2; %P3
% pid = 3; %P4
% pid = 4; %P5
% pid = 5; %P6
%}

%%
if contains(tag,'steve_oxford*')
    paper = 'DTI1';
    ind_t = 1:4;
    ind_s = 1;
elseif contains(tag,'steve_cubic')
    paper = 'DTI2';
    ind_t = 1:2;
    ind_s = 1:3;
elseif contains(tag,'steve_cmo')
    paper = 'DTI3';
    ind_t = 2;
    ind_s = 1:3;
else
    error('Error, wrong tag');
end

dirlisting = dir(fullfile(mainfolder,tag));
isadir = arrayfun(@(x) x.isdir,dirlisting);
dirlisting = dirlisting(isadir); %keep only folders
participant = dirlisting(pid+2).name;

main = fullfile(mainfolder,tag,participant);

file0 = 'Trace.mat';
file1 = 'CleanAver.mat';
file2 = 'CleanMaps.mat';
file3 = 'contours.mat';
file4 = 'CleanTensor.mat';

fname = fullfile(fname,paper,'resources\figures\comparison',participant);

mkdir(fullfile(fname));

for ii=ind_t
    % tag = 'affReg_dti';
    tag = 'glyph_dti';
    switch ii
        case 1
            tech = 'BH';
        case 2
            tech = 'CS';
        case 3
            tech = 'Gate';
        case 4
            tech = 'Nav';
    end

    try
        load(fullfile(main,tech,tag,file0),'Trace');
        load(fullfile(main,tech,tag,file1),'CleanAverage');
        load(fullfile(main,tech,tag,file2),'CleanMaps');
        load(fullfile(main,tech,file3),'contours');
        load(fullfile(main,tech,tag,file4),'CleanTensor');
    catch
        continue
    end

    slices = fieldnames(CleanAverage.Systole);
    for jj = 1:length(slices)
        epi = contours.epi{jj};
        rvi = contours.rvi{jj};
        endo = contours.endo{jj};
        M_myo = contours.myoMask{jj};

        bref = Trace{jj}{2};

        %{
%% raw images
        bhigh1 = CleanAverage.Systole.(slices{jj}).AveragedData(14).image;
        bhigh2 = CleanAverage.Systole.(slices{jj}).AveragedData(15).image;
        bhigh3 = CleanAverage.Systole.(slices{jj}).AveragedData(16).image;
        bhigh4 = CleanAverage.Systole.(slices{jj}).AveragedData(17).image;
        bhigh5 = CleanAverage.Systole.(slices{jj}).AveragedData(18).image;
        bhigh6 = CleanAverage.Systole.(slices{jj}).AveragedData(19).image;
        IM = bref;

        h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;axis equal;colormap gray % here just view the image you want to base your borders on
        hold on;
        plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
        plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
        plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
        hold off;
        set(h,'Color',[0.35 0 0.35]);
        export_fig(fullfile(fname,[tech '_b50.png']),'-png','-transparent=[0.35 0 0.35]','-r100');
        close(h)

        IM = bhigh1;
        h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;axis equal;colormap gray % here just view the image you want to base your borders on
        hold on;
        plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
        plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
        plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
        hold off;
        set(h,'Color',[0.35 0 0.35]);
        export_fig(fullfile(fname,[tech '_bhigh1.png']),'-png','-transparent=[0.35 0 0.35]','-r100');
        close(h)

        IM = bhigh2;
        h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;axis equal;colormap gray % here just view the image you want to base your borders on
        hold on;
        plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
        plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
        plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
        hold off;
        set(h,'Color',[0.35 0 0.35]);
        export_fig(fullfile(fname,[tech '_bhigh2.png']),'-png','-transparent=[0.35 0 0.35]','-r100');
        close(h)

        IM = bhigh3;
        h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;axis equal;colormap gray % here just view the image you want to base your borders on
        hold on;
        plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
        plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
        plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
        hold off;
        set(h,'Color',[0.35 0 0.35]);
        export_fig(fullfile(fname,[tech '_bhigh3.png']),'-png','-transparent=[0.35 0 0.35]','-r100');
        close(h)

        IM = bhigh4;
        h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;axis equal;colormap gray % here just view the image you want to base your borders on
        hold on;
        plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
        plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
        plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
        hold off;
        set(h,'Color',[0.35 0 0.35]);
        export_fig(fullfile(fname,[tech '_bhigh4.png']),'-png','-transparent=[0.35 0 0.35]','-r100');
        close(h)

        IM = bhigh5;
        h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;axis equal;colormap gray % here just view the image you want to base your borders on
        hold on;
        plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
        plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
        plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
        hold off;
        set(h,'Color',[0.35 0 0.35]);
        export_fig(fullfile(fname,[tech '_bhigh5.png']),'-png','-transparent=[0.35 0 0.35]','-r100');
        close(h)

        IM = bhigh6;
        h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;axis equal;colormap gray % here just view the image you want to base your borders on
        hold on;
        plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
        plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
        plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
        hold off;
        set(h,'Color',[0.35 0 0.35]);
        export_fig(fullfile(fname,[tech '_bhigh6.png']),'-png','-transparent=[0.35 0 0.35]','-r100');
        close(h)
        %}

        md = CleanMaps.Systole.(slice{jj}).MD.b50.b450;
        fa = CleanMaps.Systole.(slice{jj}).FA.b50.b450;
        ha = CleanMaps.Systole.(slice{jj}).HA_filt.b50.b450;
        e2a = CleanMaps.Systole.(slice{jj}).E2A.b50.b450;
        IM = bref;

        h = figure;
        ax1 = axes;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;axis equal;colormap(ax1,'gray');
        ax2 = axes;imagesc(ax2,md*1e3,'alphadata',M_myo,[0 2.5]);colormap(ax2,'turbo'); %sj
        ax2.Visible = 'off'; linkprop([ax1 ax2],'Position');
        axis equal;
        set(h,'Color',[0.35 0 0.35]);
        export_fig(fullfile(fname,[tech '_' slices{jj} '_md.png']),'-png','-transparent=[0.35 0 0.35]','-r100');
        close(h)
        h = figure;
        ax1 = axes;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;axis equal;colormap(ax1,'gray');
        ax2 = axes;imagesc(ax2,fa,'alphadata',M_myo,[0 1]);colormap(ax2,'turbo'); %sj
        ax2.Visible = 'off'; linkprop([ax1 ax2],'Position');
        axis equal;
        set(h,'Color',[0.35 0 0.35]);
        export_fig(fullfile(fname,[tech '_' slices{jj} '_fa.png']),'-png','-transparent=[0.35 0 0.35]','-r100');
        close(h)
        h = figure;
        ax1 = axes;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;axis equal;colormap(ax1,'gray');
        ax2 = axes;imagesc(ax2,ha,'alphadata',M_myo,[-60 60]);colormap(ax2,'turbo'); %sj
        ax2.Visible = 'off'; linkprop([ax1 ax2],'Position');
        axis equal;
        set(h,'Color',[0.35 0 0.35]);
        export_fig(fullfile(fname,[tech '_' slices{jj} '_ha.png']),'-png','-transparent=[0.35 0 0.35]','-r100');
        close(h)
        h = figure;cmap = brewermap([],"-RdBu");
        ax1 = axes;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;axis equal;colormap(ax1,'gray');
        ax2 = axes;imagesc(ax2,abs(e2a),'alphadata',M_myo,[0 90]);colormap(ax2,cmap); %sj
        ax2.Visible = 'off'; linkprop([ax1 ax2],'Position');
        axis equal;
        set(h,'Color',[0.35 0 0.35]);
        export_fig(fullfile(fname,[tech '_' slices{jj} '_e2a.png']),'-png','-transparent=[0.35 0 0.35]','-r100');
        close(h)

        %{
%% glyphs
        delta = 2; %sj - distance between glyphs
        numpoints = 25; %sj - number of points in glyph (+1)
        tensor = CleanTensor.Systole.(slices{j}).tensor.b50.b450;
        tensor = permute(tensor,[3 4 1 2]); %rearrange array dimension to get 3x3xNxM
        M_myo_glyph = permute(repmat(M_myo,[1 1 3 3]),[3 4 1 2]); %rearrange array dimension to get 3x3xNxM
        D = tensor.*M_myo_glyph;

        h = figure;
        lim = [-60 60];
        cmap = colormap('turbo');
        ax1 = axes; imagesc(imresize(IM,delta));axis equal off;colormap(ax1,'gray'); %scale up trace image to match glyph spacing
        ax2 = axes; plotDTI(ax2,D,delta,numpoints);drawnow;
        linkprop([ax1 ax2],{'YDir'}); %base image has reversed Y-direction, copy to glyph axis
        linkprop([ax1 ax2],{'XLim','YLim'}); %copy glyph axis limits to base image
        colormapDTI(ax2,ha,cmap,lim,delta,numpoints);drawnow; %add colour to the glyphs based on map
        
        P = prctile([epi;endo],[0 25 50 75 100],1); %calculate percentiles of epi and endo
        ud = delta*(P-1);
        targetx = round(ud(:,1));
        targety = round(ud(:,2));
        h.OuterPosition = [0 0 1400 800];
        set(gcf().Children,'CameraViewAngle',4.5)
        set(gcf().Children,'View',[0 25])
        set(gcf().Children,'CameraPosition',[100 650 300])
        set(gcf().Children,'CameraTarget',[targetx(3)+2.5 targety(3)+5 0])
        close(h)
        %}
    end
end

%{
%% breathing traces
dataDir = '/Volumes/mri/UserFolders/Steve/DiffusionData/_full_/oxford';
f = fullfile(dataDir,'20211125_O3TPR_CD01_20632','15_sj_ep2d_diff_nav_steve'); %- average
% f = fullfile(dataDir,'20180629_O3TPR_C11-01_10286','102_sj_ep2d_diff_nav_steve_td225'); %- max

dirlisting = dir(fullfile(f,'**')); %find all in the main directory including subfolders
notdir = arrayfun(@(x) ~x.isdir,dirlisting);
dirlisting = dirlisting(notdir); %remove folders

[~,~,ext] = arrayfun(@(x) fileparts(x.name),dirlisting,'UniformOutput',false);
validExt = {'.ima', '.dcm'};
valid = cellfun(@(x) ismember(x, validExt), ext);
dirlisting = dirlisting(valid); %remove non-dicom files

fullImg = [];
jj=length(dirlisting)-2; %last image is histogram
for j =(jj-6):jj
    try
        dcmInfo = dicominfo(fullfile(dirlisting(j).folder,dirlisting(j).name));
    catch
        fprintf('%s is not a dicom file\n',dirlisting(j).name); %hopefully this shouldn't happen
        continue
    end
    image = double(dicomread(dcmInfo));
    boundsx = 30:221;boundsy = 31:239;
    if j==jj
        boundsx = 30:256; %on the last image get the scale as well
    end
    traceImg = image(boundsy,boundsx);
    traceImg(traceImg==1024)=384;
    % figure(2);imagesc(traceImg);
    fullImg = [fullImg traceImg];
end

h = figure; imagesc(fullImg);
axis off;axis equal;colormap gray
export_fig(fullfile(fname,'breathing.png'),'-png','-transparent','-r100','-m10');
close(h)
%}