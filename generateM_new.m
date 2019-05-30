function [M, Var] = generateM_new(N, g)

p = 0.7;
q = 0.3;

a =  p * N/2;
b = q * N/2;
c = N/2  - a - b;

g_1 = g;
g_2 = 1.4;
g_3 = g;

theta_1 = linspace(0, 2 * pi, a);
theta_1 = theta_1';
theta_2 = linspace(0, 2 * pi, b) + 0.1 * rand(1,1) * 2 * pi;
theta_2 = theta_2';
% theta_1 = randn(a,1) * 2 * pi;
% theta_2 = randn(b,1) * 2 * pi;
theta_3 = linspace(0, 2 * pi, c) + 0.1 * rand(1,1) * 2 * pi;
theta_3 = theta_3';

real_part_1 = g_1 * sin(theta_1);
imag_part_pos_1 = g_1 * cos(theta_1);
imag_part_neg_1 = - imag_part_pos_1;

real_part_2 = g_2 * sin(theta_2);
imag_part_pos_2 = g_2 * cos(theta_2);
imag_part_neg_2 = - imag_part_pos_2;

real_part_3 = g_3 * sin(theta_3);
imag_part_pos_3 = g_3 * cos(theta_3);
imag_part_neg_3 = - imag_part_pos_3;

real_part = [real_part_1; real_part_2; real_part_3];
imag_part_pos = [imag_part_pos_1; imag_part_pos_2; imag_part_pos_3];
imag_part_neg = [imag_part_neg_1; imag_part_neg_2; imag_part_neg_3];

per = 0.1;
temp = sprandn(N,N,per) / sqrt(N);
temp = full(temp);
temp = temp - temp';
[V, D] = eig(temp);
eig_val = zeros(N,1);

for i = 1:N/2
    eig_val(2*i -1) = real_part(i) + 1i * imag_part_pos(i);
    eig_val(2*i) = real_part(i) + 1i * imag_part_neg(i);
end

M = real(V * diag(eig_val) * inv(V));

figure(20)
d = eig(M);
scatter(real(d), imag(d))
pause(0.5)

Mean = 0;
Var = 0;
for i = 1 : N
    for j = 1:N
        Mean = Mean + M(i,j);
    end
end

Mean = Mean / (N ^ 2);

for i = 1:N
    for j = 1:N
        Var = Var + M(i,j)^2;
    end
end

Var = Var / (N ^2)
