% define filenames / group
file_names = {'HC_MatLab_Analyses.xlsx', 'PRND_MatLab_Analyses.xlsx', 'RR_MatLab_Analyses.xlsx', 'SD_MatLab_Analyses.xlsx', 'OS2_MatLab_Analyses.xlsx', 'OS1_MatLab_Analyses.xlsx'};
num_groups = numel(file_names);

% initialize cell array to store Z scores / comparison
z_scores = cell(num_groups, num_groups);

% loop over each pair of groups
for group1_idx = 1:num_groups
    for group2_idx = (group1_idx + 1):num_groups
        % read data from excel for the groups
        data1 = xlsread(file_names{group1_idx});
        data2 = xlsread(file_names{group2_idx});
        
        % compute correlation matrices for groups
        correlation_matrix1 = corr(data1, 'rows', 'pairwise');
        correlation_matrix2 = corr(data2, 'rows', 'pairwise');
        
        % fisher's Z transformation --> correlation matrices
        fisher_z_matrix1 = real(0.5 * log((1 + correlation_matrix1) ./ (1 - correlation_matrix1)));
        fisher_z_matrix2 = real(0.5 * log((1 + correlation_matrix2) ./ (1 - correlation_matrix2)));
        
        % compute Z score btwn two groups for each region
        z_score_matrix = zeros(size(fisher_z_matrix1));
        for region_idx = 1:size(fisher_z_matrix1, 1)
            % region-specific sample sizes
            sample_size1 = sum(~isnan(data1(:, region_idx)));
            sample_size2 = sum(~isnan(data2(:, region_idx)));
            
            % compute Zscore for region
            z_score_matrix(region_idx, :) = (fisher_z_matrix1(region_idx, :) - fisher_z_matrix2(region_idx, :)) ./ ...
                sqrt(1./(sample_size1-3) + 1./(sample_size2-3));
        end
        
        % store Z score matrix
        z_scores{group1_idx, group2_idx} = z_score_matrix;
        z_scores{group2_idx, group1_idx} = z_score_matrix; % z score symmetric
        
        % heatmap of Z scores
        % NTS - add different label for NaN values 
        figure;
        heatmap(z_score_matrix, 'Colormap', jet, 'ColorScaling', 'scaled');
        title(['Z Scores Heatmap: ', file_names{group1_idx}, ' - ', file_names{group2_idx}]);
        xlabel('ROI');
        ylabel('ROI');
        colorbar;


    end
end


