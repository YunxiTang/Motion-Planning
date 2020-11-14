open('ROA.fig');
hold on;
% h=gcf();
gamma_star = 0.48165;
beta = 0.2682;
q1 = linspace(-1.5,1.5,50);
q2 = q1;
[Q1,Q2] = meshgrid(q1,q2);
Lya = 1.5*Q1.^2+Q2.^2-Q1.*Q2;
P = (Q1.^2 + Q2.^2);
h = gamma_star;
t = value(beta);
[M1,c1] = contour(Q1,Q2,Lya,[h,h]);
c1.LineWidth = 2.0;
c1.Color = 'blue';
% c1.ShowText = 'on';
hold on;
[M2,c2] = contour(Q1,Q2,P,[t,t]);
c2.Color = 'black';
c2.LineWidth = 2.0;
% c2.ShowText = 'on';

f1 = -Q2;
f2 = Q1-Q2+Q2.^3;
quiver(Q1,Q2,f1,f2);
grid on;
axis equal;
%%
% V_c = nn;
% q1 = linspace(-1.5,1.5,50);
% q2 = q1;
% [x1,x2] = meshgrid(q1,q2);
% P = x1.^2 + x2.^2;
% V = V_c(1)+x1*V_c(2)+x2*V_c(3)+x1.^2*V_c(4)+x1.*x2*V_c(5)+x2.^2*V_c(6)+x1.^3*V_c(7)+x1.^2.*x2*V_c(8)+x1.*x2.^2*V_c(9)+x2.^3*V_c(10)+x1.^4.*V_c(11)+x1.^3.*x2*V_c(12)+x1.^2.*x2.^2*V_c(13)+x1.*x2.^3*V_c(14)+x2.^4*V_c(15);
% % surf(x1,x2,V);hold on;
% [M3,c3] = contour(x1,x2,P,[0.3118,0.3118]);hold on;
% [M4,c4] = contour(x1,x2,V,[0.48165,0.48165]);
% c3.Color = 'b';
% c3.LineWidth = 4.0;
% % c3.ShowText = 'on';
% c4.Color = 'r';
% c4.LineWidth = 4.0;
% % c4.ShowText = 'on';
% axis equal;