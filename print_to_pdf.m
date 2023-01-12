function print_to_pdf(type,img_folder,display_on)

if display_on
    cur_folder = fullfile(img_folder,type);
    warning('off');
    mkdir(cur_folder);
    warning('on');
    
    fig = findall(groot,'Type','figure');
    for num = 1:numel(fig)
        h = fig(num); %or choose the figure you want to print
        filename = ['fig' num2str(h.Number) '_' h.Name]; %set filename
        
        ratio = str2double(h.Tag);
        if ratio>16/9
            h.OuterPosition = [0 0 1920 1920/ratio];
        else
            h.OuterPosition = [0 0 1080*ratio 1080];
        end
%         for j=1:numel(h.Children)
%             h.Children(j).XLabel.Position(2) = -25;
%         end
        drawnow;
%         print(h,fullfile(cur_folder,filename),'-depsc','-tiff','-loose');
        exportgraphics(h,fullfile(cur_folder,[filename '.tif']),'BackgroundColor','none','Resolution',300);
%         warning off export_fig:exportgraphics
%         export_fig(fullfile(cur_folder,filename),'-eps','-transparent',h);
%         warning on

%         set(h,'PaperUnits','Centimeters');
%         set(h,'PaperPositionMode','manual','PaperSize',[29.7 21],'InvertHardcopy','on')
%         print(h,filename,'-dpdf','-r0','-bestfit') 
%         print(h,filename,'-dpng','-r0')
    end
    close all
end

end