% function [M, A, B, C, D, gRange,real_part,imag_part_pos]= RForceDistribution(N, g, index);
function  [M,per, radius,theta] = RForceDistribution(N, g, index)



radius = [0.82, 0.91,  0.99, 1.28] * g* 0.90;
num_circles = length(radius);
partition_out = 0.01;
partition_in = 1 - partition_out;
distance_threshold = 1.15;
if radius(num_circles) > 1.6
    per_out = partition_out * N/2;
    per_in = zeros(1,num_circles - 1);
    radius_in = radius(1:num_circles - 1);
    
    distance = abs(radius_in - distance_threshold);
    percentage = tanh(-2 * distance)+1;
    percentage_normalized = percentage / sum(percentage);
    for i = 1: num_circles - 2
        per_in(i) = max(floor(percentage_normalized(i) * N/2),0.1 * N/2);
    end
    per_in(end) = partition_in * (N/2) - sum(per_in);
    per = [per_in, per_out];
else
    radius_in = radius(1:num_circles);
    per = zeros(1,num_circles);
    distance = abs(radius_in - distance_threshold);
    percentage = tanh(-2 * distance)+1;
    percentage_normalized = percentage / sum(percentage);
    
    for i = 1: num_circles - 1
        per(i) = floor(percentage_normalized(i) * N/2);
    end
    per(end) = (N/2) - sum(per);
end
radius

count = 0;
theta = zeros(1, N/2);
real_part = theta;
imag_part_pos = theta;
% shifting = rand(1,num_circles);
Theta_range = [pi/3 , 2 * pi/3, 0.02, pi / 3, 2*pi/3 , pi - 0.02];
for i = 1:num_circles-1
    theta(count+1: count + per(i)) = linspace(Theta_range(2 * i-1),Theta_range(2 * i), per(i));
%     theta(count+1: count + per(i)) = rand(1,per(i)) * (Theta_range(2 * i)-Theta_range(2 * i - 1)) + Theta_range(2 * i-1);
    real_part(count+1: count + per(i)) = radius(i) * cos(theta(count+1: count + per(i)));
    imag_part_pos(count+1: count + per(i)) = radius(i) * sin(theta(count+1: count + per(i)));
    count = count + per(i);
end


for i = 4:4
    theta(count+1: count + per(i)) = linspace(0.05, 0.3 * pi / (num_circles-1), per(i));
%     theta(count+1: count + per(i)) = rand(1,per(i)) * 0.3 * pi / (num_circles-1);
    real_part(count+1: count + per(i)) = radius(i) * cos(theta(count+1: count + per(i)));
    imag_part_pos(count+1: count + per(i)) = radius(i) * sin(theta(count+1: count + per(i)));
    count = count + per(i);
end


imag_part_neg = - imag_part_pos;

Temp = randn(N,N);
Temp = Temp - Temp';
[V, D] = eig(Temp);
eig_val = zeros(N,1);


for i = 1:N/2
    eig_val(2*i -1) = real_part(i) + 1i * imag_part_pos(i);
    eig_val(2*i) = real_part(i) + 1i * imag_part_neg(i);
end

M = real(V * diag(eig_val) / V);
% per = 2* per/N;
% gRange = radius;
% A = per(1);
% B = per(2);
% C = per(3);
% D = per(4);