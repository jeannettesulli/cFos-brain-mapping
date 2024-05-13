
file_names = {'PRND_MatLab_Analyses.xlsx', 'RR_MatLab_Analyses.xlsx', 'SD_MatLab_Analyses.xlsx', 'OS2_MatLab_Analyses.xlsx', 'OS1_MatLab_Analyses.xlsx'};
num_groups = numel(file_names);
correlation_matrices = cell(1, num_groups);
for group_idx = 1:num_groups
    data = xlsread(file_names{group_idx});
    correlation_matrix = corr(data, 'rows', 'pairwise');

    if size(correlation_matrix, 1) ~= size(correlation_matrix, 2)
        correlation_matrix = correlation_matrix';
    end
    
    correlation_matrices{group_idx} = correlation_matrix;
end


cross_correlation_matrix = zeros(num_groups, num_groups);
for i = 1:num_groups
    for j = 1:num_groups
        cross_corr = corr(reshape(correlation_matrices{i},[],1), reshape(correlation_matrices{j},[],1));
       
        cross_correlation_matrix(i,j) = cross_corr;
    end
end

new_group_names = {'PRND', 'RR', 'SD', 'OS2', 'OS1'};

% PCA on the cross-correlation matrix
[J, S] = eig(cross_correlation_matrix);

% eigenvectors and eigenvalues in descending order
[S_sorted, idx] = sort(diag(S), 'descend');
J_sorted = J(:, idx);

% calc explained variance
explained = 100 * S_sorted / sum(S_sorted);

% get the loadings
coeff = J_sorted;

% plot pca
figure;
bar(explained);
xlabel('Principal Component');
ylabel('Explained Variance (%)');
title('Explained Variance per PCA');

% plot the principal component coefficients
figure;
heatmap(new_group_names, 1:num_groups, coeff, 'Colormap', jet, 'ColorScaling', 'scaled');

xlabel('Group Names');
ylabel('Principal Component');
title('Principal Component Coef');

% calculate the component scores
scores = cross_correlation_matrix * coeff;

% plot corr 
figure;
scatter3(scores(:,1), scores(:,2), scores(:,3), 100, 'filled');
text(scores(:,1), scores(:,2), scores(:,3), new_group_names, 'VerticalAlignment','bottom', 'HorizontalAlignment','right');

% add axis labels and title
xlabel('PC 1');
ylabel('PC 2');
zlabel('PC 3');
title('PCA');
