%%%%%%%%%%%%%%%
% prepare the first frame
datafolder = 'nmrvscans/Scan';
datasuffix = '00000.pcd';
ptCloud = pcread(join([datafolder, '0', datasuffix]));

ClusterIndices = RBNN(ptCloud.Location, 1.0, 5);

centroid = [17 0 2];
cid = simple_detector(ptCloud.Location, ClusterIndices, centroid);

% find the centroid of the drone
dronePts = ptCloud.Location(ClusterIndices == cid, :);
droneCentroid = mean(dronePts);

% compute the bounding box
droneBoundingBox = max(dronePts) - min(dronePts) + [1, 1, 1];

PlotSegmentation(ptCloud, ClusterIndices);
hold on;
plotcube(droneBoundingBox, droneCentroid - droneBoundingBox/2, .3, [1 0 1]);

%%%%%%%%%%%%%%%
% mean shift on next frames
SearchSphereRadius = max(droneBoundingBox) / 2;
for frame = 1:1:99
    ptCloud = pcread(join([datafolder, string(frame), datasuffix], ''));
    
    KdTree = createns(ptCloud.Location, 'Distance', 'euclidean');
    Cluster = rangesearch(KdTree, droneCentroid, SearchSphereRadius);
    
    % compute centroid + bounding box
    dronePts = ptCloud.Location(Cluster{1}, :);
    droneCentroid = mean(dronePts);
    droneBoundingBox = max(dronePts) - min(dronePts) + [1, 1, 1];
   
    hold on;
    pcshow(ptCloud, 'MarkerSize', 30); 
    plotcube(droneBoundingBox, droneCentroid - droneBoundingBox/2, .3, [1 0 1]);
    hold off;
end