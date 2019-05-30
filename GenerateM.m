function [M, Var] = GenerateM(g, N)
%% EigenSpectra 1
% J = zeros(N,N);
% p = 0.1;
% for i = 1:N
%     temp =   g * sprandn(1,N,p) /sqrt(N);
%     Mean = mean(temp);
%     while(abs(Mean) > 10^(-5))
%         temp =   g * sprandn(1,N,p) /sqrt(N);
%         Mean = mean(temp);
%     end
%     J(i,:) = temp;
% end
%
% f = 0.7;
% num_one = N * f;
% ue = 0.01;
% ui = f * ue / (f - 1);
% temp = [ones(1, num_one), zeros(1, N - num_one)];
% m = temp(randperm(length(temp)));
%
% for i = 1: N
%     if (m(i) == 0)
%         m(i) = ui;
%     else
%         m(i) = ue;
%     end
% end
%
% M_rep = repmat(m, N ,1) / sqrt(N);


% %% Unit circle
% M_real = (randn(N / 2,1)) ;
% upper = find(M_real > 1);
% lowwer = find(M_real < (-1));
% M_real(upper) = 1;
% M_real(lowwer) = -1;
% M_imag_pos = sqrt(1 - (M_real).^2);
% M_imag_neg = -M_imag_pos;
%
%
% M_eigval = [M_real + 1i * M_imag_pos; M_real + 1i * M_imag_neg];
%
%
% Q_half =  randn(N,N/2) + 1i * randn(N, N/2);
% Q = [Q_half, conj(Q_half)];
%
% M_unit = real(Q * diag(M_eigval)* inv(Q));



% Final = M_rep + J;
% d = eig(Final);
% theta = linspace(0,2 * pi ,360);
% figure(1)
% plot(sin(theta), cos(theta));
% hold on
% scatter(real(d), imag(d))
% Mean = mean(mean(Final))
% Var = 0;
% for i = 1 : N
%     for j = 1 : N
%         Var = Var + Final(i,j)^2;
%     end
% end
% Var = Var / (N^2)
% M = Final;
Var = 10;
while (Var > 1)
    Ori = rand(N/2,1) * 2 * pi;
    eigen_real = sin(Ori);
    
    % hist(eigen_real)
    eigen_imag_pos = cos(Ori);
    eigen_imag_neg = -cos(Ori);
    
%     theta = linspace(0, 2* pi, 360);
    
    % figure(1)
    % hold on
    % plot(sin(theta), cos(theta));
    % scatter(eigen_real, eigen_imag_pos);
    % scatter(eigen_real, eigen_imag_neg);
    
    eigen_value = [eigen_real + 1i * eigen_imag_pos; eigen_real + 1i * eigen_imag_neg];
    Q_half = orth(rand(N,N/2)) + 1i * orth(rand(N,N/2));
    Q = [Q_half, conj(Q_half)];
    M = real(Q * diag(eigen_value) * inv(Q));
%     d = eig(M);
%     scatter(real(d),imag(d))
    
    Var = 0.0
    for i = 1: N
        for j = 1:N
            Var = Var + M(i,j) ^2;
        end
    end
    
    Var = Var / (N^2)
end
