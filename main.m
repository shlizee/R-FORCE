clear;
close all;
clc;
% Hyper Parameters

dt = 0.1;          % time interval
nsecs = 120 * 12;      % time span
N = 1000;           % # of neurons
alpha = 1;         % Learning rate
LineWidth = 12;

% g_range = linspace(1.0,2.0,11);
g_range = 1.5;
learn_every = 1;   % Parameter updating frequency
repetition = 4;
Training_error = zeros(length(g_range), repetition);
Testing_error = Training_error;


simtime0 = 0:dt:nsecs-dt;
simtime1 = 1*nsecs:dt:2*nsecs-dt;
simtime2 = 2*nsecs:dt:3*nsecs-dt;
simtime_len = length(simtime1);


for index = 1: length(g_range)

%     rng(4)
    g = g_range(index)
    tic
    for repeat = 1: repetition
%         rng(1)
                %% Parallel
        
                %% Generating parameters
                [ft,ft2,wo_len,zt, zpt, x, r, z, P, wo, dw, wf] = Initialization(simtime1, simtime_len, simtime2,dt, nsecs, N, alpha);
                
                %% Generating connexion matrix MR
                [M,per, radius,theta] = RForceDistribution(N, g, index);
%                 [M,per, radius] = MR(N, g, index);

%                 %% Integrating w/o training
%                 x = Integrating(simtime0, x, M, r, dt, z, wf);
                
                %% Training
                [zt, wo, wo_len, x0 ] = training(simtime1, simtime_len, ft, x, dt, M, r, wf, z, learn_every, P,dw, wo, zt, wo_len, N);
        
                error_avg = sum(abs(ft -zt))/simtime_len;
                Training_error(index, repeat) = error_avg;
                disp(['Training MAE: ' num2str(error_avg,3)]);
                
                %% Testing
                [zpt] = testing(simtime2,N, x0, dt, wo, M, r, wf, z, zpt,ft2);
        
                error_avg = sum(abs(ft2 -zpt))/simtime_len;
                Testing_error(index, repeat) = error_avg;
                disp(['Testing MAE: ' num2str(error_avg,3)]);
                
                %% Plotting (Comment out this line of code if you use parfor)
                f1 = plottting(index, repetition, repeat, ft,zt, ft2, zpt, M, simtime1, simtime2, per, radius, Testing_error, g, wf, wo, N, x);


    end
    toc
end