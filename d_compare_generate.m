close all

if ismac
    main = '/Users/steve/Library/CloudStorage/OneDrive-UniversityofCapeTown/Documents/MATLAB/DTIanalysis/steve_oxford_2021/O3TPR_CD01_21026';
else
    main = 'D:\Steve\OneDrive - University of Cape Town\Documents\MATLAB\DTIanalysis\steve_oxford_2021\O3TPR_CD01_21026'; %base of main directory
end
file1 = 'CleanAver.mat';
file2 = 'CleanMaps.mat';
file3 = 'contours.mat';

if ismac
    fname = '/Users/steve/Library/CloudStorage/OneDrive-UniversityofCapeTown/Documents/PhD/Papers/DTI1/resources/images/comparison';
else
    fname = 'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI1\resources\images\comparison'; %
end


for ii=1:4
    switch ii
        case 1
            tech = fullfile('BH','affreg_dti');
            sf = 'bh';
        case 2
            tech = fullfile('Gate','affreg_dti');
            sf = 'gate';
        case 3
            tech = fullfile('Nav','affreg_dti');
            sf = 'nav';
        case 4
            tech = fullfile('CS','affreg_dti');
            sf = 'cs';
    end

    mkdir(fullfile(fname,sf));
    
    load(fullfile(main,tech,file1),'CleanAverage','Trace');
    load(fullfile(main,tech,file2),'CleanMaps');
    load(fullfile(main,tech,file3),'contours');

    epi = contours.epi{1};
    rvi = contours.rvi{1};
    endo = contours.endo{1};
    M_myo = contours.myoMask{1};

    bref = Trace{1}{2};
    bhigh1 = CleanAverage.Systole.Mid.AveragedData(14).image;
    bhigh2 = CleanAverage.Systole.Mid.AveragedData(15).image;
    bhigh3 = CleanAverage.Systole.Mid.AveragedData(16).image;
    bhigh4 = CleanAverage.Systole.Mid.AveragedData(17).image;
    bhigh5 = CleanAverage.Systole.Mid.AveragedData(18).image;
    bhigh6 = CleanAverage.Systole.Mid.AveragedData(19).image;
    md = CleanMaps.Systole.Mid.MD.b50.b450;
    fa = CleanMaps.Systole.Mid.FA.b50.b450;
    ha = CleanMaps.Systole.Mid.HA_filt.b50.b450;

    IM = bref;
    h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap gray % here just view the image you want to base your borders on
    hold on;
    plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
    plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
    plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
    hold off;
    export_fig(fullfile(fname,sf,'b50.png'),'-png','-transparent','-r100');
    close(h)

    IM = bhigh1;
    h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap gray % here just view the image you want to base your borders on
    hold on;
    plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
    plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
    plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
    hold off;
    export_fig(fullfile(fname,sf,'bhigh1.png'),'-png','-transparent','-r100');
    close(h)

    IM = bhigh2;
    h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap gray % here just view the image you want to base your borders on
    hold on;
    plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
    plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
    plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
    hold off;
    export_fig(fullfile(fname,sf,'bhigh2.png'),'-png','-transparent','-r100');
    close(h)

    IM = bhigh3;
    h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap gray % here just view the image you want to base your borders on
    hold on;
    plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
    plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
    plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
    hold off;
    export_fig(fullfile(fname,sf,'bhigh3.png'),'-png','-transparent','-r100');
    close(h)

    IM = bhigh4;
    h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap gray % here just view the image you want to base your borders on
    hold on;
    plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
    plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
    plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
    hold off;
    export_fig(fullfile(fname,sf,'bhigh4.png'),'-png','-transparent','-r100');
    close(h)

    IM = bhigh5;
    h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap gray % here just view the image you want to base your borders on
    hold on;
    plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
    plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
    plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
    hold off;
    export_fig(fullfile(fname,sf,'bhigh5.png'),'-png','-transparent','-r100');
    close(h)

    IM = bhigh6;
    h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap gray % here just view the image you want to base your borders on
    hold on;
    plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
    plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
    plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
    hold off;
    export_fig(fullfile(fname,sf,'bhigh6.png'),'-png','-transparent','-r100');
    close(h)

    IM = bref;
    h = figure;
    ax1 = axes;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap(ax1,'gray');
    ax2 = axes;imagesc(ax2,md*1e3,'alphadata',M_myo,[0 2.5]);colormap(ax2,'turbo'); %sj
    ax2.Visible = 'off'; linkprop([ax1 ax2],'Position');
    export_fig(fullfile(fname,sf,'md.png'),'-png','-transparent','-r100');
    close(h)
    h = figure;
    ax1 = axes;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap(ax1,'gray');
    ax2 = axes;imagesc(ax2,fa,'alphadata',M_myo,[0 1]);colormap(ax2,'turbo'); %sj
    ax2.Visible = 'off'; linkprop([ax1 ax2],'Position');
    export_fig(fullfile(fname,sf,'fa.png'),'-png','-transparent','-r100');
    close(h)
    h = figure;
    ax1 = axes;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap(ax1,'gray');
    ax2 = axes;imagesc(ax2,ha,'alphadata',M_myo,[-90 90]);colormap(ax2,'turbo'); %sj
    ax2.Visible = 'off'; linkprop([ax1 ax2],'Position');
    export_fig(fullfile(fname,sf,'ha.png'),'-png','-transparent','-r100');
    close(h)

end