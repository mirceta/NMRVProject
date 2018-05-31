function patch = getpatch3D(window, templateSize, center)
% worcenter(3)s only for perfect cube windows
% window = 3D matrix
% templateSize = 3 dim vector
    templateSize = templateSize / 2;
    xl = max(1, min(size(window, 1), center(1) - templateSize(1)));
    xr = max(1, min(size(window, 1), center(1) + templateSize(1)));
    yl = max(1, min(size(window, 1), center(2) - templateSize(2)));
    yr = max(1, min(size(window, 1), center(2) + templateSize(2)));
    zl = max(1, min(size(window, 1), center(3) - templateSize(3)));
    zr = max(1, min(size(window, 1), center(3) + templateSize(3)));
    patch = window(xl:xr, yl:yr, zl:zr);
end

