file_names = {'HC_grouped.xlsx', 'PRND_grouped.xlsx', 'RR_grouped.xlsx', 'SD_grouped.xlsx', 'OS2_grouped.xlsx', 'OS1_grouped.xlsx'};

for group_idx = 1:numel(file_names)
    data = xlsread(file_names{group_idx});
    
    
    [~, ~, raw] = xlsread(file_names{group_idx});
    labels = raw(1, 2:end); 
    labels = strrep(labels, '_', ' '); 
    
    correlation_matrix = corr(data, 'rows', 'pairwise');
    
    % threshold corr value
    threshold = 0.88;
    correlation_matrix(abs(correlation_matrix) < threshold) = 0;
    
    binarizedMatrix = correlation_matrix ~= 0;
    
    % node degree
    nodeDegree = sum(binarizedMatrix, 2);
    
    % node size / degree
    minNodeSize = 5; 
    maxNodeSize = 20; 
    nodeSizes = minNodeSize + (maxNodeSize - minNodeSize) * (nodeDegree - min(nodeDegree)) / (max(nodeDegree) - min(nodeDegree));
    
    % edge widths / corr values
    edgeWidths = abs(correlation_matrix(correlation_matrix ~= 0));
    edgeWidths = 1 + 9 * (edgeWidths - min(edgeWidths)) / (max(edgeWidths) - min(edgeWidths)); 

    figure;
    circularGraph(binarizedMatrix, 'Label', labels, 'NodeSizes', nodeSizes, 'EdgeWidths', edgeWidths);
   
    [~, group_name, ~] = fileparts(file_names{group_idx});
    group_name = extractBefore(group_name, '_grouped');
    title(['Functional Connectome - ', group_name], 'Interpreter', 'none');
    
    annotation('textbox', [0.1, 0.9, 0.1, 0.1], 'String', file_names{group_idx}, 'FitBoxToText', 'on', 'EdgeColor', 'none');
    
    saveas(gcf, [group_name, '_connectome.png']);
end



