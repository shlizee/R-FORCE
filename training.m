
function [zt, wo, x ] = training(simtime, ft, x, dt, M, r, wf, z, learn_every, P, wo, zt)

ti = 0;
for t = simtime
    ti = ti+1;
    % sim, so x(t) and r(t) are created.
    x = (1 - dt) * x + M*(r*dt) + wf*(z*dt);
    r = tanh(x);
    z = wo'*r;
    
    if mod(ti, learn_every) == 0
        % update inverse correlation matrix
        k = P*r;
        rPr = r'*k;
        c = 1.0/(1.0 + rPr);
        P = P - k*(k'*c);
        
        % update the error for the linear readout
        e = z-ft(ti);
        
        % update the output weights
        dw = -e*k*c;
        wo = wo + dw;
    end
    
    zt(ti) = z;
end
