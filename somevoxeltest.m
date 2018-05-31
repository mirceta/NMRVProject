% verify whether cross correlation works.

window = ones(100, 100, 100);
[x, y, z] = size(field);
window(20:20+x-1, 20:20+y-1, 20:20+z-1) = field;

[ssd, ncc] = template_matching(field, window);

[v,loc] = max(ncc(:));
[ii,jj,k] = ind2sub(size(ncc),loc);