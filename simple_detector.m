function cidx = simple_detector(Points, ClusterIndices, centroid)
    % Detects the drone by you inputing the approximate centroid
    % of the drone
    KdTree = createns(Points, 'Distance', 'euclidean');
    result = knnsearch(KdTree, centroid,'K',1);
    
    cidx = ClusterIndices(result);
end

