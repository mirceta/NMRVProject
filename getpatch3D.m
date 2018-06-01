function patch = getpatch3D(window, templateSize, center)
% worcenter(3)s only for perfect cube windows
% window = 3D matrix
% templateSize = 3 dim vector
    orig = templateSize;
    templateSize = templateSize / 2;
    xl = max(1, min(size(window, 1), center(1) - templateSize(1)));
    xr = max(1, min(size(window, 1), center(1) + templateSize(1)));
    yl = max(1, min(size(window, 1), center(2) - templateSize(2)));
    yr = max(1, min(size(window, 1), center(2) + templateSize(2)));
    zl = max(1, min(size(window, 1), center(3) - templateSize(3)));
    zr = max(1, min(size(window, 1), center(3) + templateSize(3)));
    patch = window(xl:xr, yl:yr, zl:zr);
    
    % fix the padding
    if size(patch) ~= orig;
        A = zeros(orig(1), orig(2), orig(3));
        xr = min(size(A, 1), size(patch, 1));
        yr = min(size(A, 2), size(patch, 2));
        zr = min(size(A, 3), size(patch, 3));
        A(1:xr,1:yr,1:zr) = patch(1:min(xr, size(patch, 1)), 1:min(yr, size(patch, 2)), 1:min(zr, size(patch, 3)));
        patch = A;
    end
end

