function [zpt, Testing_eig_val, r_record] = testing(simtime2,N, x, dt, wo, M, r, wf, z, zpt, eig_frequency)

%% Using Forward Euler
% ti = 0;
% for t = simtime2
%     ti =  ti + 1;
%     
%     % sim, so x(t) and r(t) are created.
%     x = (1 - dt) * x + M*(r*dt) + wf*(z*dt);
%     r = tanh(x);
%     z = wo'*r;
%     zpt(ti) = z;
% end
simtime_len = length(simtime2);
%% Using ode45
counter = 0;
theta = linspace(0, 2*pi, 360);
Testing_eig_val = zeros(length(simtime2) / eig_frequency, N);
x0 = x;

r_record = zeros(N, simtime_len);
r_record(:,1) = tanh(x0);

for ti = 1: length(simtime2) - 1
    tspan = [simtime2(ti), simtime2(ti +1)];
    M_r = M * r;
    wf_z = wf * z;
    [t,x] = ode45(@(t,x) myode(x, M_r, wf_z), tspan, x0);
    x0 = x(end,:)';
    r = tanh(x0);
    r_record(:,ti + 1) = r;
    z = wo'*r;
    zpt(ti) = z;
    
%     %% Eigvalue Evolution
%     if (mod(ti, eig_frequency) == 0)
%         counter = counter + 1;
%         J_t = -eye(N) + (M +wf * wo') * diag(ones(N,1) - tanh(x0).^2);
%         
%         Testing_eig_val(counter,:) = EigenEvolution(J_t);
%         figure(12)
%         
%         plot(sin(theta) - 1, cos(theta), 'LineWidth', 3);
%         hold on
%         scatter(real(Testing_eig_val(counter,:)), imag(Testing_eig_val(counter,:)))
%         hold off
%         pause(0.5)
%     end
end