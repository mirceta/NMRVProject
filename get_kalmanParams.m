function [A, C, Q, R, V] = get_kalmanParams(alpha, beta, gamma, w ,h, r, q)
% returns the kalman parameters fitting to a NCV model
    % x,y = initial observations
    % xp, yp init = initial velocity
    % alpha, beta = prior covariance matrix parameters
    % w, h = width, height used in initial estimate of prior covariance
    dt = 1.0;
    
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
    Q =  [(dt^3*q)/3, (dt^2*q)/2,          0,          0,          0,          0;
          (dt^2*q)/2,       dt*q,          0,          0,          0,          0;
                   0,          0, (dt^3*q)/3, (dt^2*q)/2,          0,          0;
                   0,          0, (dt^2*q)/2,       dt*q,          0,          0;
                   0,          0,          0,          0, (dt^3*q)/3, (dt^2*q)/2;
                   0,          0,          0,          0, (dt^2*q)/2,       dt*q];
     
    
    % observation covariance
    R = r * [1 0 0; 
             0 1 0;
             0 0 1];
    
    % prior covariance
    V = [    alpha * w                0               0                0               0                0;
                     0        alpha * h               0                0               0                0;
                     0                0        beta * w                0               0                0;
                     0                0               0         beta * h               0                0;
                     0                0               0                0       gamma * w                0;
                     0                0               0                0               0        gamma * h];
end