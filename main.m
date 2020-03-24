clear;
close all;
clc;
% Hyper Parameters

dt = .1;          % time interval
nsecs = 120 * 12;      % time span
N = 1000;           % # of neurons
alpha = 1;         % Learning rate
LineWidth = 12;
p = 1;

g_range = linspace(1.0,2.0,11);
learn_every = 2;   % Parameter updating frequency
repetition = 8;
Training_error = zeros(length(g_range), repetition);
Testing_error = Training_error;

simtime0 = 0:dt:nsecs-dt;
simtime1 = 1*nsecs:dt:2*nsecs-dt;
simtime_len_train = length(simtime0);
simtime_len_test = length(simtime1);

for index = 1: length(g_range)


    g = g_range(index)
    tic
    for repeat = 1: repetition
        rng(repeat)
        %% Generating parameters
        [ft,ft2,wo_len,zt, zpt, x, r, z, P, wo, dw, wf] = Initialization(simtime0, simtime_len_train, simtime_len_test, simtime1,dt, nsecs, N, alpha);

        %% Generating connexion matrix MR
        [M, per, radius,theta] = RForceDistribution(N, g, index);

        %% Training
        [zt, wo, x ] = training(simtime0, ft, x, dt, M, r, wf, z, learn_every, P, wo, zt);
        
        error_avg = sum(abs(ft -zt))/simtime_len_train;
        Training_error(index, repeat) = error_avg;
%         disp(['Training MAE: ' num2str(error_avg,3)]);
        
        
        %% Testing
        [zpt] = testing(simtime1, x, dt, wo, M, wf, z, zpt);
        error_avg = sum(abs(ft2 -zpt))/simtime_len_test;
        Testing_error(index, repeat) = error_avg;
        disp(['Testing MAE: ' num2str(error_avg,3)]);

        %% Plotting (Comment out this line of code if you use parfor)
        f1 = plottting(index, repetition, repeat, ft,zt, ft2, zpt, M, simtime0, simtime1, per, radius, Testing_error, g, wf, wo, N, x);
        
        
    end
    toc
end