f1 = 'D:\Steve\OneDrive - University of Cape Town\Documents\MATLAB\DTIanalysis\steve_cubic\';
t1 = 'D:\Steve\OneDrive - University of Cape Town\Documents\PhD\Papers\DTI2_resources\data\';
ff1 = 'RejectImages';
ff2 = 'Systole_Base';
ff3 = 'Systole_Mid';
ff4 = 'Systole_Apex';

copyImages = 0; %1;
%%
for j = 1:11
    switch j
        case 1
            f3 = 'STEVE_DTI_002\';
        case 2
            f3 = 'STEVE_DTI_004\';
        case 3
            f3 = 'STEVE_DTI_006\';
        case 4
            f3 = 'STEVE_DTI_008\';
        case 5
            f3 = 'STEVE_DTI_009\';
        case 6
            f3 = 'STEVE_DTI_010\';
        case 7
            f3 = 'STEVE_DTI_011\';
        case 8
            f3 = 'STEVE_DTI_012\';
        case 9
            f3 = 'STEVE_DTI_013\';
        case 10
            f3 = 'STEVE_DTI_01STEVE_DTI_014\';
        case 11
            f3 = 'STEVE_DTI_016\';
    end
    t2 = f3;
    for i = 1:2
        switch i
            case 1
                f4 = 'affreg_HRcorr_dti_BH';
            case 2
                f4 = 'affreg_HRcorr_dti_CS';
        end
        t3 = f4;
        from1 = [f1 f3 f4 '\' f4 '.xlsx'];
        to1 = [t1 t2 t3 '\'];
        mkdir(to1);
        copyfile(from1,to1);
        if copyImages
            from1 = [f1 f3 f4 '\' ff1];
            from2 = [f1 f3 f4 '\' ff2];
            from3 = [f1 f3 f4 '\' ff3];
            from4 = [f1 f3 f4 '\' ff4];
            to2 = [to1 '\' ff1];
            to3 = [to1 '\' ff2];
            to4 = [to1 '\' ff3];
            to5 = [to1 '\' ff4];
            copyfile(from1,to2);
            copyfile(from2,to3);
            copyfile(from3,to4);
            copyfile(from4,to5);
        end
    end
end