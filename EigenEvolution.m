function eigenvalue_train = EigenEvolution(J_t)

theta = linspace(0, 2 * pi, 360);
eigenvalue_train = eig(J_t);
% real_part = real(eigenvalue_train);
% imag_part = imag(eigenvalue_train);
% figure(10)
% plot(sin(theta) - 1, cos(theta));
% hold on
% scatter(real_part, imag_part);
% hold off