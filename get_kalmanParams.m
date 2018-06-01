function [A, C, Q, R, x, V] = get_kalmanParams(xm, ym, zm, xp_init, yp_init, zp_init, alpha, beta, w ,h, r, q)
% returns the kalman parameters fitting to a NCV model
    % x,y = initial observations
    % xp, yp init = initial velocity
    % alpha, beta = prior covariance matrix parameters
    % w, h = width, height used in initial estimate of prior covariance
    dt = 1.0;
    
    % state vector
    x = zeros(6, 1);
    x(1) = xm;
    x(2) = xp_init;
    x(3) = ym;
    x(4) = yp_init;
    x(5) = zm;
    x(6) = zp_init;
    
    % system matrix
    A = [1    dt     0     0     0     0;
         0     1     0     0     0     0;
         0     0     1    dt     0     0;
         0     0     0     1     0     0;
         0     0     0     0     1    dt;
         0     0     0     0     0     1];
     
    % observation matrix
    C = [1 0 0 0 0 0;
         0 0 1 0 0 0;
         0 0 0 0 1 0];
    
    % system covariance
    L = [0 0 0;
         1 0 0;
         0 0 0;
         0 1 0;
         0 0 0;
         0 0 1];
     % syms T q
     % Q = int((A*L)*q*(A*L)', T, 0, T);
     Q = [ (dt^3*q)/3, (dt^2*q)/2,          0,          0;
           (dt^2*q)/2,       dt*q,          0,          0;
                    0,          0, (dt^3*q)/3, (dt^2*q)/2;
                    0,          0, (dt^2*q)/2,       dt*q];
    
    
    % observation covariance
    R = r * [1 0; 
             0 1];
    
    % prior covariance
    V = [    alpha * w                0               0                0;
                     0        alpha * h               0                0;
                     0                0        beta * w                0;
                     0                0               0         beta * h];
end