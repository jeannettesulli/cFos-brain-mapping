file_names = {'PRND_MatLab_Analyses.xlsx', 'RR_MatLab_Analyses.xlsx', 'SD_MatLab_Analyses.xlsx', 'OS2_MatLab_Analyses.xlsx', 'OS1_MatLab_Analyses.xlsx'};
num_groups = numel(file_names);
num_subjects = 43;

% store full matrix
full_dissimilarity_matrix = zeros(num_groups * num_subjects);
group_labels = cell(1, num_groups);
for i = 1:num_groups
    [~, group_labels{i}, ~] = fileparts(file_names{i});
end

% loop / group 
for group_idx1 = 1:num_groups
    for group_idx2 = 1:num_groups
    
        data1 = xlsread(file_names{group_idx1});
        data2 = xlsread(file_names{group_idx2});

        % correlation matrix
        num_rows = min(size(data1, 1), size(data2, 1));
        correlation_matrix = corr(data1(1:num_rows, :), data2(1:num_rows, :), 'rows', 'pairwise');

        % +1 for dissim
        dissimilarity_matrix = correlation_matrix + 1;
        
        % indices for inserting the dissimilarity matrix
        start_row = (group_idx1 - 1) * num_subjects + 1;
        start_col = (group_idx2 - 1) * num_subjects + 1;
        end_row = start_row + size(dissimilarity_matrix, 1) - 1;
        end_col = start_col + size(dissimilarity_matrix, 2) - 1;
        
        % dissimilarity matrix into full matrix
        full_dissimilarity_matrix(start_row:end_row, start_col:end_col) = dissimilarity_matrix;
    end
end

imagesc(full_dissimilarity_matrix);
    
    am = colorbar;
    am.Ticks = linspace(0,2,3);

    colormap(jet(256));

    caxis([0, 2]);

    js = gca;
    js.XTick = [21 64 107 150 193]; 
    js.YTick = [21 64 107 150 193];
    js.XAxis.TickLength = [0 0];
    js.YAxis.TickLength = [0 0];
    js.XTickLabel = {'PRND' 'RR' 'SD' 'OS2' 'OS1'}; 
    js.YTickLabel = {'PRND' 'RR' 'SD' 'OS2' 'OS1'};

    col = [43,86,129,172]; 
    row = [43,86,129,172]; 
    xline(js, col+.5, 'k-', 'LineWidth',1.5);
    yline(js, row+.5, 'k-', 'LineWidth',1.5);




