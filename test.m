% visualize raw input data
ptCloud = pcread('nmrvscans/Scan500000.pcd');

ClusterIndices = RBNN(ptCloud.Location, 1.0, 5);

PlotSegmentation(ptCloud, ClusterIndices);