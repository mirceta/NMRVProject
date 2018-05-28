% visualize raw input data
ptCloud = pcread('100000.pcd');

ClusterIndices = RBNN(ptCloud.Location, 1.0, 5);

PlotSegmentation(ptCloud, ClusterIndices);