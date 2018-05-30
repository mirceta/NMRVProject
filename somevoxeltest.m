% 7 seconds for 1000 voxels
for i = 1:1000
    plotcube([3,3,3], [3,3,3], .3, [1 0 1]);
    if mod(i,10000) == 0
        i
    end
end