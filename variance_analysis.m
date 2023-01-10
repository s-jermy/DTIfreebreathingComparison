function [p,h] = variance_analysis(tbl,type,outl_sd,display_on)

dispopt = 'off';
if display_on
    dispopt = 'on';  
end

tbl2 = tbl;

%finding outliers in whole table
Z = zscore(tbl2.(type));
outliers = find(abs(Z)>outl_sd);

%remove outliers 
tbl2(outliers,:) = [];

[C,~,ic] = unique(tbl2(:,{'lowB','highB'}).Variables,'stable','rows');
b_l = size(C,1); %number of group categories lowb_highb

C = unique(tbl2.tech);
t_l = size(C,1); %number of techniques

temp = nchoosek(string(C),2);
nck = nchoosek(t_l,2);
sz = [b_l nck];
varNames = strcat(temp(:,1)," ",temp(:,2));
varTypes = repmat({'logical'},size(varNames));
varTypes2 = repmat({'double'},size(varNames));
h = table('Size',sz,'VariableNames',varNames,'VariableTypes',varTypes);
p = table('Size',sz,'VariableNames',varNames,'VariableTypes',varTypes2);
h2 = h;
p2 = p;

count = 0;
for i=1:b_l
    ind = any(ic == i,2);
    
    x = tbl2.(type)(ind);
    g = tbl2.tech(ind);
%     pval = vartestn(x,g,'Display',dispopt);
    
%     if pval<0.05
        [~,~,igc] = unique(g,'stable');
%         count = 0;
        for j=1:(t_l-1)
            for k=(j+1):t_l
                count = count+1;
                [~,pval(count)] = vartest2(x(igc==j),x(igc==k));
            end
        end
        [corr_p,bonf_h] = bonf_holm(pval((i-1)*nck+1:count),0.05);
        h{i,:} = bonf_h;
        p{i,:} = corr_p;
%     end
end

[corr_p2,bonf_h2] = bonf_holm(pval,0.05);
for i=1:nck
    h2{:,i} = bonf_h2(i:nck:end)';
    p2{:,i} = corr_p2(i:nck:end)';
end

end