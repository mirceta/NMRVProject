function out = gaussPeak3D(sx, sy, sz, cx, cy, cz, sigma)
% GAUSSPEAK3D - makes a 3D gaussian peak kernel
% sx,y,z = the size of the desired output
% cx,y,z = desired location of gaussian peak
out = zeros(sx,sy,sz);
out(cx,cy,cz) = 1.0;
out = gauss3filter(out, sigma);
end

