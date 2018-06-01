%%%%%%%%%%%%%%%
% prepare the first frame
datafolder = 'nmrvscans/Scan';
datasuffix = '00000.pcd';
ptCloud = pcread(join([datafolder, '40', datasuffix]));

ClusterIndices = RBNN(ptCloud.Location, 1.0, 5);

centroid = [17 0 2];
cid = simple_detector(ptCloud.Location, ClusterIndices, centroid);

% find the centroid of the drone
dronePts = ptCloud.Location(ClusterIndices == cid, :);
droneCentroid = mean(dronePts);

% compute the bounding box
droneBoundingBox = max(dronePts) - min(dronePts) + [1, 1, 1];

% get current distance from sensor
sigma = norm(droneCentroid) * 0.001;

% compute the template
template = points_to_gaussian_field(dronePts, droneCentroid - droneBoundingBox / 2, droneBoundingBox, 30, sigma);


PlotSegmentation(ptCloud, ClusterIndices);
hold on;
plotcube(droneBoundingBox, droneCentroid - droneBoundingBox/2, .3, [1 0 1]);

%%%%%%%%%%%%%%%
% mean shift on next frames
WindowSize = max(droneBoundingBox) * 1.2;
SearchSphereRadius = WindowSize / 2;
WindowSize = [WindowSize, WindowSize, WindowSize];
alpha = 0.5;
for frame = 41:1:99
    hold off;
    ptCloud = pcread(join([datafolder, string(frame), datasuffix], ''));
    
    
    
    %% CORE
    % get the window with the points
    KdTree = createns(ptCloud.Location, 'Distance', 'euclidean');
    Cluster = rangesearch(KdTree, droneCentroid, SearchSphereRadius);
    dronePts = ptCloud.Location(Cluster{1}, :);
    
    % get the search region as feature
    WindowStart = droneCentroid - WindowSize / 2;
    sigma = norm(droneCentroid) * 0.001;
    window = points_to_gaussian_field(dronePts, WindowStart, WindowSize, 30, sigma);
    dim = size(window, 1);
    %window = window .* hamming_3d(dim, dim, dim);
    
    % compute the cross correlation
    [ssd, ncc] = template_matching(template, window);
    [v,loc] = max(ncc(:));
    [ii,jj,k] = ind2sub(size(ncc),loc);
    
    % compute the centroid and new bounding box
    droneCentroid = WindowStart + ([ii, jj, k] ./ size(window)) .* WindowSize;
        % bounding box stays the same
    
    %%% NCC UPDATE
    % compute new template from ncc equation
    template_new = getpatch3D(window, size(template), [ii, jj, k]);
    
    % g = fft(gaussian_peak)
    [sx, sy, sz] = size(template_new);
    g = gaussPeak3D(sx, sy, sz,  round(sx / 2), round(sy / 2), round(sz / 2), 0.5);
    
    %template_new = flipdim(flipdim(flipdim(template_new,1),2),3); % flip dimension in 3D
    gF = fftn(g, size(template_new));
    templateF = fftn(template_new, size(template_new));
    templateF = (gF .* conj(templateF)) ./ (templateF .* conj(templateF));
    template_new = ifftn(templateF);
    
    template = alpha * template_new + (1 - alpha) * template;
    
    
    
    
    
    
    
    
    %%%% PLOT
    hold on;
    pcshow(ptCloud, 'MarkerSize', 30);
    plotcube(droneBoundingBox, droneCentroid - droneBoundingBox/2, .3, [1 0 1]);
    hold off;
end