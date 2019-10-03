function [ft,ft2,wo_len,zt, zpt, x, r, z, P, wo, dw, wf] = Initialization(simtime, simtime_len, simtime2,dt, nsecs, N, alpha)

%% Periodic 
amp = 1;
freq = 1/60;
ft = (amp/1.0)*sin(1.0*pi*freq*simtime) + ...
    (amp/2.0)*sin(2.0*pi*freq*simtime) + ...
    (amp/6.0)*sin(3.0*pi*freq*simtime) + ...
    (amp/3.0)*sin(4.0*pi*freq*simtime);
scale = max(ft);
ft = ft/ (1 * scale);
ft2 = (amp/1.0)*sin(1.0*pi*freq*simtime2) + ...
    (amp/2.0)*sin(2.0*pi*freq*simtime2) + ...
    (amp/6.0)*sin(3.0*pi*freq*simtime2) + ...
    (amp/3.0)*sin(4.0*pi*freq*simtime2);
ft2 = ft2/ (1 * scale);


% % Complicated periodic
% % Example 1
% amp = 1.3;
% freq = 1/60;
% ft = (amp/1.0)*sin(1.0*pi*freq*simtime) + ...
%     (amp/2.0)*sin(2.0*pi*freq*simtime) + ...
%     (amp/6.0)*sin(3.0*pi*freq*simtime) + ...
%     (amp/3.0)*sin(4.0*pi*freq*simtime) + ...
%     (amp/4.0)*sin(5.0*pi*freq*simtime);
% scale = max(ft);
% ft = ft/ (1 * scale);
% ft2 = (amp/1.0)*sin(1.0*pi*freq*simtime2) + ...
%     (amp/2.0)*sin(2.0*pi*freq*simtime2) + ...
%     (amp/6.0)*sin(3.0*pi*freq*simtime2) + ...
%     (amp/3.0)*sin(4.0*pi*freq*simtime2) + ...
%     (amp/4.0)*sin(5.0*pi*freq*simtime2);
% ft2 = ft2/ (1 * scale);

% % Example 2
% amp = 1.3;
% freq = 1/80;
% ft = (amp/1.0)*sin(1.0*pi*freq*simtime) + ...
%     (amp/2.0)*sin(2.0*pi*freq*simtime) + ...
%     (amp/6.0)*sin(3.0*pi*freq*simtime) + ...
%     (amp/3.0)*sin(4.0*pi*freq*simtime) + ...
%     (amp/4.0)*sin(5.0*pi*freq*simtime) + ...
%     (amp/2.0)*sin(6.0*pi*freq*simtime2);
% ft = ft/ 2.0;
% ft2 = (amp/1.0)*sin(1.0*pi*freq*simtime2) + ...
%     (amp/2.0)*sin(2.0*pi*freq*simtime2) + ...
%     (amp/6.0)*sin(3.0*pi*freq*simtime2) + ...
%     (amp/3.0)*sin(4.0*pi*freq*simtime2) + ...
%     (amp/4.0)*sin(5.0*pi*freq*simtime2) + ...
%     (amp/2.0)*sin(6.0*pi*freq*simtime2);
% ft2 = ft2/ 2.0;


% %% Extremely Noisy target
% 
% amp = 1.3;
% freq = 1/60;
% ft = (amp/1.0)*sin(1.0*pi*freq*simtime) + ...
%     (amp/2.0)*sin(2.0*pi*freq*simtime) + ...
%     (amp/6.0)*sin(3.0*pi*freq*simtime) + ...
%     (amp/3.0)*sin(4.0*pi*freq*simtime);
% scale = max(ft);
% ft = ft/ (1 * scale);
% Noise = randn(1, simtime_len) *0.2;
% ft = ft + Noise;
% ft2 = (amp/1.0)*sin(1.0*pi*freq*simtime2) + ...
%     (amp/2.0)*sin(2.0*pi*freq*simtime2) + ...
%     (amp/6.0)*sin(3.0*pi*freq*simtime2) + ...
%     (amp/3.0)*sin(4.0*pi*freq*simtime2);
% 
% ft2 = ft2/ (1 * scale);

% %% Discontinous target
% % Example 1
% k = 3;
% amp = 1.;
% freq = 1/120;
% % ft = zeros(1, simtime_len);
% % ft2 = zeros(1, simtime_len);
% ft = zeros(1,1200);
% ft2 = zeros(1,1200);
% for i = 1:k
%     ft = ft + sin((2 * i -1) * 2 * pi * freq * simtime(1:1200)) / (2*i - 1);
% end
% scale = max(ft);
% ft = ft/ (1 * scale);
% for i = 1:k
%     ft2 = ft2 + sin((2 * i -1) * 2 * pi * freq * simtime2(1:1200)) / (2*i - 1);
% end
% ft2 = ft2/ (1 * scale);
% ft = repmat(ft, 1,12);
% ft2 = repmat(ft2, 1,12);

% Example 2
% k = 40;
% amp = 0.9;
% freq = 1/60;
% ft = zeros(1, simtime_len);
% ft2 = zeros(1, simtime_len);
% for i = 1:k
%     ft = ft + sin(2 * pi * i * simtime * freq) .* sin(pi * i / 2)/ i^2;
% end
% ft = ft * amp;
% 
% for i = 1:k
%     ft2 = ft2 + sin(2 * pi * i * simtime2 * freq) .* sin(pi * i / 2)/ i^2;
% end
% ft2 = ft2 * amp;
% % hold on
% % plot(ft)
% % plot(ft2)

% % Example 3
% ft = 0.5 * ones(1, simtime_len);
% ft2 = 0.5 * ones(1, simtime_len);
% L= 60;
% for i = 1: 5
%     ft = ft - sin(i * pi * simtime / L) / (i * pi);
% end
% 
% for i = 1: 5
%     ft2 = ft2 - sin(i * pi * simtime2 / L) / (i * pi);
% end
%%
wo_len = zeros(1,simtime_len);
zt = zeros(1,simtime_len);
zpt = zeros(1,simtime_len);
x0 = 0.5*randn(N,1);

x = x0;
r = tanh(x);
z0 = 0.5*randn(1,1);
z = z0;
P = (1.0/alpha)*eye(N);

wo = zeros(N,1);
dw = zeros(N,1);
wf = 2.0*(rand(N,1)-0.5);



