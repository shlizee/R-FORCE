function f1 = plottting(index, repetition, repeat, ft,zt, ft2, zpt, M, simtime1, simtime2, per, radius, Testing_error, g, wf, wo, N, x)
eigVal = eig(M);
theta = linspace(0,2 * pi ,360);

f1 = figure((index - 1) * repetition + repeat );
% %
subplot 221
hold on

title({[num2str(per(1) * 100),'% r = ',num2str(radius(1)),' and ',num2str(per(2) * 100),'% r = ',num2str(radius(2)),...
    ' and ',num2str(per(3) * 100),'% r = ',num2str(radius(3)), 'and ',num2str(per(4) * 100),'% r = ',num2str(radius(4))];...,
    ['Testing Error = ', num2str(Testing_error(index)),' g = ', num2str(g)]});

p1 = plot(simtime1, ft, 'r','LineWidth',3);
p2 = plot(simtime1, zt, 'b','LineWidth',3);
p3 = plot(simtime2, zpt, 'g','LineWidth',3);
p4 = plot(simtime2, ft2, 'r','LineWidth',3);

subplot 222
hold on
                        title({[num2str(per(1) * 100),'% r = ',num2str(radius(1)),' and ',num2str(per(2) * 100),'% r = ',num2str(radius(2))],...
                            [' and ',num2str(per(3) * 100),'% r = ',num2str(radius(3)), 'and ',num2str(per(4) * 100),'% r = ',num2str(radius(4))]})
%         plot(sin(theta), cos(theta),'r','LineWidth', 3);
%         %         plot(sin(theta) * 1.5, cos(theta) * 1.5, 'k', 'LineWidth', 3);
scatter(real(eigVal), imag(eigVal));

        J_t = -eye(N) + (M +wf * wo') * diag(ones(N,1) - tanh(x).^2);
        d = eig(J_t);
        d_check = size(find(abs(d + 1)>1.00),1);
        per_outer = d_check / N;
        subplot 223
        hold on

        plot(sin(theta) - 1, cos(theta),'r', 'LineWidth', 3);

        scatter(real(d), imag(d),100,'filled','b');
        title(['J_t with ',num2str(per_outer * 100),' % outside the unit circle']);
        hold off

        M_titled = M + wf * wo';
        subplot 224
        hold on
        d = eig(M_titled);
        plot(sin(theta) * g, cos(theta) * g, 'k', 'LineWidth', 3);
        plot(sin(theta), cos(theta), 'LineWidth', 3);
        scatter(real(d), imag(d),100,'filled','b');
        title('M_{tiled}')
        pause(0.01)
        hold off
