clear;
close all;
clc;
% rng(4396)
% Hyper Parameters
dt = 0.1;          % time interval
nsecs = 1440;      % time span
N = 1000;           % # of neurons
alpha = 1;         % Learning rate
g_range = linspace(1.25, 1.25, 1);             % Chaos degree
learn_every = 1;   % Parameter updating frequency
eig_frequency = 5;

Training_error = zeros(1, length(g_range));
Testing_error = Training_error;
Variance = Training_error;

simtime = 0:dt:nsecs-dt;
simtime_len = length(simtime);
simtime2 = 1*nsecs:dt:2*nsecs-dt;
Training_eig_val = zeros(length(g_range), length(simtime) / eig_frequency, N);
Testing_eig_val = zeros(length(g_range), length(simtime) / eig_frequency, N);

Training_zt = zeros(length(g_range), length(simtime));
Testing_zpt = zeros(length(g_range), length(simtime));

r_record_training = zeros(length(g_range), N, simtime_len);
r_record_testing = r_record_training;
wo_record = zeros(length(g_range), N);

for index = 1: length(g_range)
    rng(4397 + index)
    g = g_range(index)
    [ft,ft2,wo_len,zt, zpt, x, r, z, P, wo, dw, wf] = Initialization(simtime, simtime_len, simtime2,dt, nsecs, N, alpha);
    [M, Var] = generateM_new(N, g);
    
    Variance(index) = Var;
    [zt, wo, wo_len, Training_eig_val(index,:,:), r_record_training(index, :,:)] = training(simtime, simtime_len, ft, x, dt, M, r, wf, z, learn_every, P,dw, wo, zt, wo_len, N, eig_frequency);
    Training_zt(index, :) = zt;
    wo_record(index, :) = wo;
    error_avg = sum(abs(zt-ft))/simtime_len;
    Training_error(index) = error_avg;
    disp(['Training MAE: ' num2str(error_avg,3)]);
    
    [zpt, Testing_eig_val(index,:,:),r_record_testing(index, :,:)] = testing(simtime2,N, x, dt, wo, M, r, wf, z, zpt, eig_frequency);
    Testing_zpt(index, :) = zpt;
    error_avg = sum(abs(zpt-ft2))/simtime_len;
    Testing_error(index) = error_avg;
    disp(['Testing MAE: ' num2str(error_avg,3)]);
    
    figure(index)
    subplot 311
    plot(simtime, ft, 'r');
    hold on
    plot(simtime, zt, 'b');
    
    subplot 312
    plot(simtime, ft2, 'r');
    hold on
    plot(simtime, zpt, 'b');
    
    subplot 313
    plot(simtime, wo_len);
    title(['g = ',num2str(g)]);
end