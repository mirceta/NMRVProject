% setup (the relevant variables)
alpha = 0.5;
beta = 0.5;
gamma = 0.5;
w = 5;
h = 5;
r = 50.0;
q = 50.0;
[A, C, Q, R, V] = get_kalmanParams(alpha, beta, gamma, w ,h, r, q)

% We set up the scene and find the initial drone position
datafolder = 'nmrvscans/Scan';
datasuffix = '00000.pcd';
ptCloud = pcread(join([datafolder, '0', datasuffix]));

ClusterIndices = RBNN(ptCloud.Location, 1.0, 5);
centroid = [17 0 2];
cid = simple_detector(ptCloud.Location, ClusterIndices, centroid);
dronePts = ptCloud.Location(ClusterIndices == cid, :); % find the centroid of the drone
droneCentroid = mean(dronePts);
droneBoundingBox = max(dronePts) - min(dronePts) + [1, 1, 1]; % compute the bounding box
sigma = norm(droneCentroid) * 0.001; % get current distance from sensor
template = points_to_gaussian_field(dronePts, droneCentroid - droneBoundingBox / 2, droneBoundingBox, 30, sigma); % compute the template


PlotSegmentation(ptCloud, ClusterIndices);
hold on;
plotcube(droneBoundingBox, droneCentroid - droneBoundingBox/2, .3, [1 0 1]);

% main loop
WindowSize = max(droneBoundingBox) * 1.2;
SearchSphereRadius = WindowSize / 2;
WindowSize = [WindowSize, WindowSize, WindowSize];
covariance = V;
for frame = 1:1:99
    ptCloud = pcread(join([datafolder, string(frame), datasuffix], ''));
    
    % get prediction from correlation model
    observation = corr_update(ptCloud, SearchSphereRadius, droneCentroid, template, WindowSize);
    currState = get_kalmanState(droneCentroid(1), droneCentroid(2), droneCentroid(3), 0.2, 0.1, 0.05);
    
    % run the kalman update function -> the output is the new centroid
    [currState, covariance] = kalman_update(A, C, Q, R,...
                                        observation,...
                                        currState,...
                                        covariance);
    droneCentroid = [currState(1), currState(3), currState(5)];

    hold on;
    pcshow(ptCloud, 'MarkerSize', 30);
    plotcube(droneBoundingBox, droneCentroid - droneBoundingBox/2, .3, [1 0 1]);
    hold off;
    
    if frame == 47
        window;
    end
end
