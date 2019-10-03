function x = Integrating(simtime0, x, M, r, dt, z, wf)

ti = 0;
for t = simtime0
    ti = ti+1;
    
    x = (1.0-dt)*x + M*(r*dt) + wf*(z*dt);
    r = tanh(x);
end
