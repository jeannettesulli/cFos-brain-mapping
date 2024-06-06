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

[V, D] = eig(cross_correlation_matrix);
[D_sorted, idx] = sort(diag(D), 'descend');
V_sorted = V(:, idx);
explained = 100 * D_sorted / sum(D_sorted);
coeff = V_sorted;

figure;
bar(explained);
xlabel('Principal Component');
ylabel('Explained Variance (%)');
title('Explained Variance by Principal Components');
figure;
heatmap(new_group_names, 1:num_groups, coeff, 'Colormap', jet, 'ColorScaling', 'scaled');

xlabel('Group Names');
ylabel('Principal Component');
title('Principal Component Coefficients');

scores = cross_correlation_matrix * coeff;

component1 = 1;
component2 = 2;
figure;
scatter(scores(:, component1), scores(:, component2), 100, 'filled');
text(scores(:, component1), scores(:, component2), new_group_names, 'VerticalAlignment','bottom', 'HorizontalAlignment','right');
xlabel(['Principal Component ', num2str(component1)]);
ylabel(['Principal Component ', num2str(component2)]);
title(['Principal Component Scores (2D): PC', num2str(component1), ' vs PC', num2str(component2)]);
