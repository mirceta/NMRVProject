function nextPrediction = corr_update(ptCloud, SearchSphereRadius, droneCentroid, template, WindowSize)
    
    % get the window with the points
    KdTree = createns(ptCloud.Location, 'Distance', 'euclidean');
    Cluster = rangesearch(KdTree, droneCentroid, SearchSphereRadius);
    dronePts = ptCloud.Location(Cluster{1}, :);
    
    % get the search region as feature
    WindowStart = droneCentroid - WindowSize / 2;
    sigma = norm(droneCentroid) * 0.001;
    window = points_to_gaussian_field(dronePts, WindowStart, WindowSize, 30, sigma);
    
    % only use if hanning window experiment
    dim = size(window, 1);
    window = window .* hamming_3d(dim, dim, dim);
    
    % compute the cross correlation
    [ssd, ncc] = template_matching(template, window);
    [v,loc] = max(ncc(:));
    [ii,jj,k] = ind2sub(size(ncc),loc);
    
    % only use when you want to update the template with the previous one
    % template = getpatch3D(window, size(template), [ii, jj, k]);
    
    % compute the centroid and new bounding box
    nextPrediction = WindowStart + ([ii, jj, k] ./ size(window)) .* WindowSize;
end

