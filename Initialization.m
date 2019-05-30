function [ft,ft2,wo_len,zt, zpt, x, r, z, P, wo, dw, wf] = Initialization(simtime, simtime_len, simtime2,dt, nsecs, N, alpha)

amp = 1.3;
freq = 1/60;
ft = (amp/1.0)*sin(1.0*pi*freq*simtime) + ...
    (amp/2.0)*sin(2.0*pi*freq*simtime) + ...
    (amp/6.0)*sin(3.0*pi*freq*simtime) + ...
    (amp/3.0)*sin(4.0*pi*freq*simtime);
ft = ft/1.5;
ft2 = (amp/1.0)*sin(1.0*pi*freq*simtime2) + ...
    (amp/2.0)*sin(2.0*pi*freq*simtime2) + ...
    (amp/6.0)*sin(3.0*pi*freq*simtime2) + ...
    (amp/3.0)*sin(4.0*pi*freq*simtime2);
ft2 = ft2/1.5;

wo_len = zeros(1,simtime_len);
zt = zeros(1,simtime_len);
zpt = zeros(1,simtime_len);
x0 = 0.5*randn(N,1);
x = x0;
r = tanh(x);
z0 = 2*randn(1,1);
z = z0;
P = (1.0/alpha)*eye(N);

% wo = zeros(N,1);
wo = 0.05*(rand(N,1)-0.5);
dw = zeros(N,1);
wf = 2.0*(rand(N,1)-0.5);



