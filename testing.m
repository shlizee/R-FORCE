function [zpt] = testing(simtime2, x, dt, wo, M, wf, z, zpt)

ti = 0;
r = tanh(x);
for t = simtime2
    ti =  ti + 1;
    % sim, so x(t) and r(t) are created.
    x = (1 - dt) * x + M*(r*dt) + wf*(z*dt);
    r = tanh(x);
    
    z = wo'*r;
    zpt(ti) = z;
end