function field = points_to_gaussian_field(points, boundingBoxOrigin, boundingBoxSize, resolution, sigma)
%POINTS_TO_GAUSSIAN_FIELD Transforms a point cloud to a gaussian field
%   points = Nx3 matrix of points to transform
%   boundingBox = bounding box of the points in world space 
%   resolution = integer value - how many bins is one unit in world space
%                could just use a constant resolution, but this means that
%                the drones would be rescaled impropperly
%   variance = either a scalar or a vector - how big the gaussian blobs
%              should be

    % prepare field
    field = zeros(round(boundingBoxSize) * resolution);
    
    % populate the field with the points
    
    points = points - boundingBoxOrigin; % move to origin
    points = points * resolution; % make it detailed proportionally to resolution
    sigma = sigma * resolution; % because the scale is now smaller, sigma needs to get bigger
    points = round(points);
    
    for i = 1:size(points, 1)
        field(points(i, 1), points(i, 2), points(i,3)) = 1; % fill the bins where there are points
    end
    field = gauss3filter(field, sigma); % smooth by gaussian
    
    % plot_descriptor(points, field);
end

