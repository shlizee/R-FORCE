
function [zt, wo, wo_len, x ] = training(simtime, simtime_len, ft, x, dt, M, r, wf, z, learn_every, P,dw, wo, zt, wo_len, N)

tic
% Using Forward Euler
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
    
    wo_len(ti) = sqrt(wo'*wo);
end


% %% Using ode45
% x0 = x;
% V =zeros(N,N);
% counter = 0;
% theta = linspace(0, 2*pi, 360);
% Training_eig_val = zeros(length(simtime) / eig_frequency, N);
% r_record = zeros(N, simtime_len);
% r_record(:,1) = tanh(x0);
% wo_record = zeros(N, round(simtime_len / learn_every));
% for ti = 1: length(simtime) - 1
%     tspan = [simtime(ti), simtime(ti +1)];
%     M_r = M * r;
%     wf_z = wf * z;
%     [t,x] = ode45(@(t,x) myode(x, M_r, wf_z), tspan, x0);
%     x0 = x(end,:)';
%     r = tanh(x0);
%     r_record(:,ti + 1) = r;
%     z = wo'*r;
%     if(ti == 300)
%         M_tiled = (M +wf * wo');
%         d = eig(M_tiled);
%         figure(100)
%         scatter(real(d), imag(d),100,'filled','b');
%     end
% %     %% Eigvalue Evolution
% %     if (mod(ti, eig_frequency) == 0)
% %         counter = counter + 1;
% %         J_t = -eye(N) + (M +wf * wo') * diag(ones(N,1) - tanh(x0).^2);
% %         
% %         Training_eig_val(counter,:) = EigenEvolution(J_t);
% %         figure(11)
% %         
% %         plot(sin(theta) - 1, cos(theta), 'LineWidth', 3);
% %         hold on
% %         scatter(real(Training_eig_val(counter,:)), imag(Training_eig_val(counter,:)))
% %         hold off
% %         pause(0.5)
% %         
% %     end
% %     %% leave the NN untrain for the 1st period
% %     if ti == 1200
% %         r_temp = r_record(:,2:1201);
% %         [U, S, V] = svd(r_temp');
% %     end
% %     if (ti >= 1201)
% %         %%
% if mod(ti, learn_every) == 0
%     % update inverse correlation matrix
%     k = P*r;
%     rPr = r'*k;
%     c = 1.0/(1.0 + rPr);
%     P = P - k*(k'*c);
%     
%     % update the error for the linear readout
%     e = z-ft(ti);
%     
%     % update the output weights
%     dw = -e*k*c;
%     wo_record(:,ti) = wo;
%     wo = wo + dw;
% end
% %     end
%     
%     
%     % Store the output of the system.
%     zt(ti) = z;
%     wo_len(ti) = sqrt(wo'*wo);
% end
% tic;