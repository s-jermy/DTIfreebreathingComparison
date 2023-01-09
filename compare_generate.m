close all

dir = 'D:\Steve\OneDrive - University of Cape Town\Documents\MATLAB\DTIanalysis\steve_cubic\STEVE_DTI_006';
file1 = 'CleanAver.mat';
file2 = 'CleanMaps.mat';
file3 = 'contours.mat';

fname = 'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\images\comparison\';

%% BH
tech = 'affreg_HRcorr_dti_BH';
load(fullfile(dir,tech,file1),'CleanAverage','Trace');
load(fullfile(dir,tech,file2),'CleanMaps');
load(fullfile(dir,tech,file3),'contours');

epi = contours.epi{1};
rvi = contours.rvi{1};
endo = contours.endo{1};
M_myo = contours.myoMask{1};

blow = Trace{2}{2};
bhigh1 = CleanAverage.Systole.Mid.AveragedData(2).image;
bhigh2 = CleanAverage.Systole.Mid.AveragedData(3).image;
bhigh3 = CleanAverage.Systole.Mid.AveragedData(4).image;
bhigh4 = CleanAverage.Systole.Mid.AveragedData(5).image;
bhigh5 = CleanAverage.Systole.Mid.AveragedData(6).image;
bhigh6 = CleanAverage.Systole.Mid.AveragedData(13).image;
md = CleanMaps.Systole.Mid.MD.b50.b450;
fa = CleanMaps.Systole.Mid.FA.b50.b450;
e2a = CleanMaps.Systole.Mid.E2A.b50.b450;
ha = CleanMaps.Systole.Mid.HA_filt.b50.b450;

IM = blow;
h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap gray % here just view the image you want to base your borders on
hold on;
plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
hold off;
export_fig([fname 'b50.png'],'-png','-transparent','-r100');
close(h)

IM = bhigh1;
h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap gray % here just view the image you want to base your borders on
hold on;
plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
hold off;
export_fig([fname 'bhigh1.png'],'-png','-transparent','-r100');
close(h)

IM = bhigh2;
h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap gray % here just view the image you want to base your borders on
hold on;
plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
hold off;
export_fig([fname 'bhigh2.png'],'-png','-transparent','-r100');
close(h)

IM = bhigh3;
h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap gray % here just view the image you want to base your borders on
hold on;
plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
hold off;
export_fig([fname 'bhigh3.png'],'-png','-transparent','-r100');
close(h)

IM = bhigh4;
h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap gray % here just view the image you want to base your borders on
hold on;
plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
hold off;
export_fig([fname 'bhigh4.png'],'-png','-transparent','-r100');
close(h)

IM = bhigh5;
h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap gray % here just view the image you want to base your borders on
hold on;
plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
hold off;
export_fig([fname 'bhigh5.png'],'-png','-transparent','-r100');
close(h)

IM = bhigh6;
h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap gray % here just view the image you want to base your borders on
hold on;
plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
hold off;
export_fig([fname 'bhigh6.png'],'-png','-transparent','-r100');
close(h)

IM = blow;
h = figure;
ax1 = axes;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap(ax1,'gray');
ax2 = axes;imagesc(ax2,md*1e3,'alphadata',M_myo,[0 2.5]);colormap(ax2,pf_colormap('MD')); %sj
ax2.Visible = 'off'; linkprop([ax1 ax2],'Position');
export_fig([fname 'md.png'],'-png','-transparent','-r100');
close(h)
h = figure;
ax1 = axes;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap(ax1,'gray');
ax2 = axes;imagesc(ax2,fa,'alphadata',M_myo,[0 1]);colormap(ax2,pf_colormap('FA')); %sj
ax2.Visible = 'off'; linkprop([ax1 ax2],'Position');
export_fig([fname 'fa.png'],'-png','-transparent','-r100');
close(h)
h = figure;
ax1 = axes;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap(ax1,'gray');
ax2 = axes;imagesc(ax2,abs(e2a),'alphadata',M_myo,[0 90]);colormap(ax2,pf_colormap('abs_E2A')); %sj
ax2.Visible = 'off'; linkprop([ax1 ax2],'Position');
export_fig([fname 'ha.png'],'-png','-transparent','-r100');
close(h)
h = figure;
ax1 = axes;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap(ax1,'gray');
ax2 = axes;imagesc(ax2,ha,'alphadata',M_myo,[-90 90]);colormap(ax2,pf_colormap('helix_angle')); %sj
ax2.Visible = 'off'; linkprop([ax1 ax2],'Position');
export_fig([fname 'ha.png'],'-png','-transparent','-r100');
close(h)

%% CS
tech = 'affreg_HRcorr_dti_CS';
load(fullfile(dir,tech,file1),'CleanAverage','Trace');
load(fullfile(dir,tech,file2),'CleanMaps');
load(fullfile(dir,tech,file3),'contours');

epi = contours.epi{1};
rvi = contours.rvi{1};
endo = contours.endo{1};
M_myo = contours.myoMask{1};

blow = Trace{2}{2};
bhigh1 = CleanAverage.Systole.Mid.AveragedData(8).image;
bhigh2 = CleanAverage.Systole.Mid.AveragedData(9).image;
bhigh3 = CleanAverage.Systole.Mid.AveragedData(10).image;
bhigh4 = CleanAverage.Systole.Mid.AveragedData(11).image;
bhigh5 = CleanAverage.Systole.Mid.AveragedData(12).image;
bhigh6 = CleanAverage.Systole.Mid.AveragedData(13).image;
md = CleanMaps.Systole.Mid.MD.b50.b450;
fa = CleanMaps.Systole.Mid.FA.b50.b450;
e2a = CleanMaps.Systole.Mid.E2A.b50.b450;
ha = CleanMaps.Systole.Mid.HA_filt.b50.b450;

IM = blow;
h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap gray % here just view the image you want to base your borders on
hold on;
plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
hold off;
export_fig([fname 'b50.png'],'-png','-transparent','-r100');
close(h)

IM = bhigh1;
h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap gray % here just view the image you want to base your borders on
hold on;
plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
hold off;
export_fig([fname 'bhigh1.png'],'-png','-transparent','-r100');
close(h)

IM = bhigh2;
h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap gray % here just view the image you want to base your borders on
hold on;
plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
hold off;
export_fig([fname 'bhigh2.png'],'-png','-transparent','-r100');
close(h)

IM = bhigh3;
h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap gray % here just view the image you want to base your borders on
hold on;
plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
hold off;
export_fig([fname 'bhigh3.png'],'-png','-transparent','-r100');
close(h)

IM = bhigh4;
h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap gray % here just view the image you want to base your borders on
hold on;
plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
hold off;
export_fig([fname 'bhigh4.png'],'-png','-transparent','-r100');
close(h)

IM = bhigh5;
h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap gray % here just view the image you want to base your borders on
hold on;
plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
hold off;
export_fig([fname 'bhigh5.png'],'-png','-transparent','-r100');
close(h)

IM = bhigh6;
h=figure;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap gray % here just view the image you want to base your borders on
hold on;
plot(epi(:,1),epi(:,2),'g.-','LineWidth',2.25)
plot(endo(:,1),endo(:,2),'r.-','LineWidth',2.25)
plot(rvi(:,1),rvi(:,2),'bx','LineWidth',2.25)
hold off;
export_fig([fname 'bhigh6.png'],'-png','-transparent','-r100');
close(h)

IM = blow;
h = figure;
ax1 = axes;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap(ax1,'gray');
ax2 = axes;imagesc(ax2,md*1e3,'alphadata',M_myo,[0 2.5]);colormap(ax2,pf_colormap('MD')); %sj
ax2.Visible = 'off'; linkprop([ax1 ax2],'Position');
export_fig([fname 'md.png'],'-png','-transparent','-r100');
close(h)
h = figure;
ax1 = axes;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap(ax1,'gray');
ax2 = axes;imagesc(ax2,fa,'alphadata',M_myo,[0 1]);colormap(ax2,pf_colormap('FA')); %sj
ax2.Visible = 'off'; linkprop([ax1 ax2],'Position');
export_fig([fname 'fa.png'],'-png','-transparent','-r100');
close(h)
h = figure;
ax1 = axes;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap(ax1,'gray');
ax2 = axes;imagesc(ax2,abs(e2a),'alphadata',M_myo,[0 90]);colormap(ax2,pf_colormap('abs_E2A')); %sj
ax2.Visible = 'off'; linkprop([ax1 ax2],'Position');
export_fig([fname 'ha.png'],'-png','-transparent','-r100');
close(h)
h = figure;
ax1 = axes;imagesc(IM,[min(IM(:)) max(IM(:))]);axis off;colormap(ax1,'gray');
ax2 = axes;imagesc(ax2,ha,'alphadata',M_myo,[-90 90]);colormap(ax2,pf_colormap('helix_angle')); %sj
ax2.Visible = 'off'; linkprop([ax1 ax2],'Position');
export_fig([fname 'ha.png'],'-png','-transparent','-r100');
close(h)