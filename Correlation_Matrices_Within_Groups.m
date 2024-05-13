%separate excel sheets for each group
% rows = brains columns = ROI 
% each cell has the average fos/mm^2 per ROI for each rat 
file_names = {'HC_MatLab_Analyses.xlsx', 'PRND_MatLab_Analyses.xlsx', 'RR_MatLab_Analyses.xlsx', 'SD_MatLab_Analyses.xlsx', 'OS2_MatLab_Analyses.xlsx', 'OS1_MatLab_Analyses.xlsx'};

for group_idx = 1:numel(file_names)

    data = xlsread(file_names{group_idx});
    
    [~, ~, raw] = xlsread(file_names{group_idx});
    labels = raw(1, 2:end); % calls each ROI label from excel, assumes labels are in first row starting from second column (first column with Rat ID)
    %computing pairwise accounts for brains w/o data in a given region 
    correlation_matrix = corr(data, 'rows', 'pairwise');
    
    figure;
    
    % imagesc so axis can be labeled 
    imagesc(correlation_matrix);
    
    % correct underscore auto format 
    labels = strrep(labels, '_', ' ');
    
    set(gca, 'XTick', 1:numel(labels), 'XTickLabel', labels, 'YTick', 1:numel(labels), 'YTickLabel', labels);
    xtickangle(90); 

    js = colorbar;
    js.Ticks = linspace (-1,1,3); 
    colormap(jet(256));
    caxis([-1, 1]);
   
    [~, group_name, ~] = fileparts(file_names{group_idx});
    group_name = extractBefore(group_name, '_MatLab_Analyses');
    title(['Correlation Heatmap - ', group_name], 'Interpreter', 'none');
    
end
