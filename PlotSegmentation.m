function Some = PlotSegmentation(PointCloud, ClusterIndices)
%PLOTSEGMENTATION assigns colors to clusters and
% shows them to the user
    ClusterIds = unique(ClusterIndices);
    for i = ClusterIds'
        color = uint8([rand() * 255, rand() * 255, rand() * 255]);
        idx = find(ClusterIndices == i);
        PointCloud.Color(idx, :) = repmat(color, size(idx, 1), 1);        
    end
    pcshow(PointCloud, 'MarkerSize', 30);
    
    Some = 0;
end

