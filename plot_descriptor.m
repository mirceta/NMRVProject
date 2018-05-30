function field = plot_descriptor(points, field)
    hold off;
    
    scatter3(points(:, 1), points(:, 2), points(:, 3));
    
    field(field > 0.001) = 1;
    
    voxelPlot(field);
end

