function res = get_kalmanState(x,y,z,xp,yp,zp)
%GET_KALMANSTATE This function is tailored only to the ncv 3D model
% [x, y, z, x', y', z'] => kalman state
    res = zeros(6, 1);
    res(1) = x;
    res(2) = xp;
    res(3) = y;
    res(4) = yp;
    res(5) = z;
    res(6) = zp;
end

