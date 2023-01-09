function [tblSumm,tblMain,tblBval,tblAll,tblSE,latTech,latBval] = sigInt(tbl,type,outl_sd,mdl)

tbl2 = tbl;
Z = zscore(tbl2.(type));
outliers = find(abs(Z)>outl_sd);

%% shift lowB values
tbl2.lowB15 = (tbl2.lowB1 - 15)/10; %shift so zero at lowB = 15
tbl2.lowB50 = (tbl2.lowB1 - 50)/10;
tbl2.lowB350 = (tbl2.lowB1 - 350)/10;

%% shift highB values
tbl2.highB350 = (tbl2.highB1 - 350)/100; %shift so zero at highB = 350
tbl2.highB450 = (tbl2.highB1 - 450)/100;
tbl2.highB550 = (tbl2.highB1 - 550)/100;
tbl2.highB650 = (tbl2.highB1 - 650)/100;

coeff = {};
for j=1:4
    switch j
        case 1
            tbl2.tech = reordercats(tbl2.tech,[1;2;3;4]);
        case 2
            tbl2.tech = reordercats(tbl2.tech,[2;1;3;4]);
        case 3
            tbl2.tech = reordercats(tbl2.tech,[3;2;1;4]);
        case 4
            tbl2.tech = reordercats(tbl2.tech,[4;2;3;1]);
    end
    for i=1:10
        switch i
            case 1
                l = 'lowB15';
                h = 'highB350';
            case 2
                h = 'highB450';
            case 3
                h = 'highB550';
            case 4
                h = 'highB650';
            case 5
                l = 'lowB50';
                h = 'highB350';
            case 6
                h = 'highB450';
            case 7
                h = 'highB550';
            case 8
                h = 'highB650';
            case 9
                l = 'lowB350';
                h = 'highB550';
            case 10
                h = 'highB650';
        end
        if mdl==1
            model = sprintf('%s ~ 1 + tech * (%s + %s) + (1|ID) + (1|ID:segment)',type,l,h);
            try
                lme = fitlme(tbl2,model,'Exclude',outliers);
            catch
                model = sprintf('%s ~ 1 + tech * (%s + %s) + (1|ID)',type,l,h);
                lme = fitlme(tbl2,model,'Exclude',outliers);
            end
        elseif mdl==2
            model = sprintf('%s ~ 1 + tech * (%s + %s) + (tech|ID:segment)',type,l,h);
            try
                lme = fitlme(tbl2,model,'Exclude',outliers);
            catch
                model = sprintf('%s ~ 1 + tech * (%s + %s) + (tech|ID)',type,l,h);
                lme = fitlme(tbl2,model,'Exclude',outliers);
            end
        end
        coeff{j,i} = dataset2table(lme.Coefficients);
        se(j,i) = lme.Coefficients.SE(1);
        
        if j>1
            break;
        end
    end
end
[tblSumm,tblMain,tblBval,tblAll,tblSE,latTech,latBval] = mat2latex_sig(coeff,se);

end