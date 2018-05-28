function ClusterIndices = RBNN(Points, r, nMin)
% RBNN finds a segmentation of the input point set into clusters
% such that the clusters are bigger than nMin, and point pairs that
% are less than r apart in euclidean distance are in the same cluster

    ClusterIndices = repmat(-1, size(Points, 1), 1);
    KdTree = createns(Points, 'Distance', 'euclidean');
    currentCluster = 0;
    
    for i = 1:size(Points, 1)
        
        % 1. assert that the current point is not assigned to a cluster
        if (ClusterIndices(i) ~= -1) 
            continue;
        end
        
        % 2. Find nearest neighbors in radius r
        NN = rangesearch(KdTree, Points(i, :), r);
        NN = NN{1};
        
        % 3. Merge or assign new clusters (core)
        for j = 1:size(NN, 2)
            oc = ClusterIndices(i); % original's cluster
            nc = ClusterIndices(NN(j)); % neighbor's cluster
            if (oc ~= -1 && nc ~= -1)
                if (oc ~= nc)
                    ClusterIndices = mergeClusters(ClusterIndices, oc, nc);
                end
            else
                if nc ~= -1
                    ClusterIndices(i) = nc;
                else
                    if oc ~= -1
                        ClusterIndices(NN(j)) = oc;
                    end
                end
            end
        end
        
        % 4. If there is still no cluster, then create a new one and assign
        % all neighbors to it.
        if ClusterIndices(i) == -1
            % create new cluster
            currentCluster = currentCluster + 1;
            ClusterIndices(i) = currentCluster;
            
            % assign this cluster to neighbors as well
            NN = rangesearch(KdTree, Points(i, :), r);
            NN = NN{1};
            for j = 1:size(NN, 2)
                ClusterIndices(NN(j)) = ClusterIndices(i);
            end
        end
            
    end
    
    % 5. Delete the clusters that are too small

end

function ClusterIndices = mergeClusters(ClusterIndices, idx1, idx2)
    res = ClusterIndices == idx1;
    ClusterIndices(res) = idx2;
end
