
function [M, per, radius,theta] = RForceDistribution(N, g, index);


radius = [0.9, 0.7, 0.72, 1.2] * g;
num_circles = length(radius);
partition_out = 0.01;
partition_in = 1 - partition_out;
distance_threshold = 1.15;
if radius(num_circles) > 1.55
    per_out = partition_out * N/2;
    per_in = zeros(1,num_circles - 1);
    radius_in = radius(1:num_circles - 1);
    
    distance = abs(radius_in - distance_threshold);
    percentage = (1 ./ distance).^(2 * g);
    percentage_normalized = percentage / sum(percentage);
    for i = 1: num_circles - 2
        per_in(i) = max(floor(percentage_normalized(i) * N/2),0.1 * N/2);
    end
    per_in(end) = partition_in * (N/2) - sum(per_in);
    per = [per_in, per_out];
else
    radius_in = radius(1:num_circles);
%     per = double(zeros(1,num_circles));
    distance = abs(radius_in - distance_threshold);
    percentage = tanh(-2 * distance)+1;
    percentage_normalized = percentage / sum(percentage);
    
    for i = 1: num_circles - 1
        per(i) = floor(percentage_normalized(i) * N/2);
    end
    per(end) = (N/2) - sum(per);
end

count = 0;
theta = zeros(1, N/2);
real_part = theta;
imag_part_pos = theta;
% shifting = rand(1,num_circles);
if g < 1.8
    Theta_range = [0.02, pi / 3, pi/3 , 2 * pi/3, 2*pi/3 , pi - 0.02];
else
    Theta_range = [4*pi/5 , pi - 0.02, 2 * pi/5 , 4 * pi/5, 0.02, 2 * pi / 5];
end


for i = 1:num_circles-1
    theta(count+1: count + per(i)) = linspace(Theta_range(2 * i-1),Theta_range(2 * i), per(i));
    real_part(count+1: count + per(i)) = radius(i) * cos(theta(count+1: count + per(i)));
    imag_part_pos(count+1: count + per(i)) = radius(i) * sin(theta(count+1: count + per(i)));
    count = count + per(i);
end


for i = 4:4
    if g < 1.4
        theta(count+1: count + per(i)) = linspace(0.0, 1.2 * pi / (g^2* (num_circles - 1)), per(i));
    else
        theta(count+1: count + per(i)) = linspace(0.4 * pi, 0.6 * pi,  per(i));
    end
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
per = per ./(N/2);
M = real(V * diag(eig_val) / V);
