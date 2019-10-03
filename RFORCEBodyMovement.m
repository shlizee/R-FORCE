clear;
close all;
clc;
load bodyMovementTrainingData.mat
skel = period_data;
[d1, d2, d3] = size(skel);
theta = linspace(0,2 * pi ,360);
interception = 15;
dt = 1 / interception;
simtime1 = 0:dt:d3-dt;
simtime_len = length(simtime1);
simtime2 = 1*d3:dt:2*d3-dt;

g_range = linspace(1.2,1.2,5);             % Chaos degree

N = 1000;
learn_every = 1;
Simulation_skel = zeros(length(g_range), d1, d2, d3 * (1/ dt));
alpha = 1.0;
trainingErrorRecord = zeros(1,simtime_len);
testingErrorRocord = trainingErrorRecord;
Training_error = zeros(length(g_range),d1,d2);
Testing_error = Training_error;





for index = 1:length(g_range)
    g = g_range(index)
    
    rng(index+10)
    wf = 2.0*(rand(N,1)-0.5);
    x0 = 0.5*randn(N,1);
    z0 = 0.5*randn(1,1);
    [M,per, radius] = MR(N, g, index);
    %     [M, a, b, c, d, gRange] = generateM_newDistribution_fourCircles(N, g, index);
%     [M, a, b, c, d, e, gRange] = generateM_newDistribution_fiveCircles(N, g, index);
    %     [M, a, b, gRange] = generateM_newDistribution_twoCircles(N, g, index);
    for iteration_Joint = 1:22
        tic
        iteration_Joint
        %         p = .1;
        %         M = sprandn(N,N,p)*g / sqrt(p*N);
        %         M = full(M);
        
        %         [M, a, b, c, d, gRange] = generateM_newDistribution_fourCircles(N, g, index);
        %         [M, p, q, g_1, g_2] = generateM_new(N, g);
        %             ;
        
        parfor iteration_axis = 1:d2
            
            ft = reshape(skel(iteration_Joint, iteration_axis, :),d3 ,1, 1);
            % Normalization
            min_value = min(ft);
            max_value = max(ft);
            nsecs = size(ft, 2);
            transformation = (min_value + max_value) / 2;
            
            ft = ft - transformation;
            min_value = min(ft);
            max_value = max(ft);
            ratio = (max_value - min_value) / 2;
            ft = ft / ratio;
            min_value = min(ft);
            max_value = max(ft);
            
            ft = interp(ft,1 / dt);
            
            %             ft = smooth(ft,50);
            ft = ft';
            ft2 = ft;
            
            zt = zeros(1,simtime_len);
            zpt = zeros(1,simtime_len);
            wo_len = zeros(1,simtime_len);
            wo = zeros(N,1);
            dw = zeros(N,1);
            
            tic
            x = x0;
            r = tanh(x);
            ti = 0;
            
            z = z0;
            P = (1.0/alpha)*eye(N);
            
            %% Initialization
            
            
            
            
            for t = simtime1
                ti = ti+1;
                % sim, so x(t) and r(t) are created.
                x = (1.0-dt)*x + M*(r*dt) + wf*(z*dt);
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
                
                % Store the output of the system.
                zt(ti) = z;
                wo_len(ti) = sqrt(wo'*wo);
                %             trainingErrorRecord(ti) = sum(abs(zt(1:ti)-ft(1:ti)))/ti;
            end
            
            
            error_avg = sum(abs(zt-ft))/simtime_len;
            Training_error(index, iteration_Joint, iteration_axis) = error_avg;
            disp(['Training MAE: ' num2str(error_avg,3)]);
            
            % Now test.
            ti = 0;
            for t = simtime2				% don't want to subtract time in indices
                ti = ti+1;
                % sim, so x(t) and r(t) are created.
                x = (1.0-dt)*x + M*(r*dt) + wf*(z*dt);
                r = tanh(x);
                
                z = wo'*r;
                
                zpt(ti) = z;
                %             testingErrorRocord(ti) = sum(abs(zpt(1:ti)-ft2(1:ti)))/ti;
            end
            
            error_avg = sum(abs(zpt-ft2))/simtime_len;
            Testing_error(index, iteration_Joint, iteration_axis) = error_avg;
            disp(['Testing MAE: ' num2str(error_avg,3)]);
            
            
            Simulation_skel(index, iteration_Joint, iteration_axis, :) = zpt * ratio + transformation;
            
%             d = eig(M);
            figure((iteration_Joint - 1) *3 + iteration_axis)
%             subplot(2,2,[1,2]);
            hold on
            %                     title({[num2str(a * 100),'% r = ',num2str(gRange(1)),' and ',num2str(b * 100),'% r = ',num2str(gRange(2)),' and ',num2str(c * 100),'% r = ',num2str(gRange(3))];... ,
            %                         ['Testing Error = ', num2str(Testing_error(iteration_Joint, iteration_axis)),' g = ', num2str(g)]});
            p1 = plot(simtime1, ft, 'r','LineWidth',3);
            p2 = plot(simtime1, zt, 'b','LineWidth',3);
            p3 = plot(simtime2, zpt, 'g','LineWidth',3);
            p4 = plot(simtime2, ft2, 'r','LineWidth',3);
            
            %                     subplot 312
            %
            %                     hold on
            %                     p5 = plot(simtime1, trainingErrorRecord, 'b');
            %                     p6 = plot(simtime2, testingErrorRocord, 'g');
%             
%             subplot 223
%             hold on
%             plot(sin(theta), cos(theta),'r','LineWidth', 3);
%             plot(sin(theta) * g, cos(theta) * g, 'k', 'LineWidth', 3);
%             scatter(real(d), imag(d));
%             %                     pause(0.2)
%             J_t = -eye(N) + (M +wf * wo') * diag(ones(N,1) - tanh(x).^2);
%             d = eig(J_t);
%             d_check = size(find(abs(d + 1)>1.00),1);
%             per_outer = d_check / N;
%             subplot 224
%             hold on
%             
%             plot(sin(theta) - 1, cos(theta),'r', 'LineWidth', 3);
%             %                     plot(sin(theta) * g - 1 , cos(theta) * g, 'k', 'LineWidth', 3);
%             scatter(real(d), imag(d),100,'filled','b');
%             title(['J_t with ',num2str(per_outer * 100),' % outside the unit circle']);
%             hold off
            pause(0.01)
        end
        toc
    end
end
