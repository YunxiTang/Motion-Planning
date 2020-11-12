clc;clear all
syms x1 x2 x3;
vars = [x1;x2;x3];

% f = dx / dt
f = [-x1^3-x1*x3^2;
     -x2-x1^2*x2;
     -x3+3*x1^2*x3-3*x3/(x3^2+1)];

prog = sosprogram(vars);
[prog, V] = sospolyvar(prog, [x1^2;x2^2;x3^2],'wscoeff');

% Constraint 1 : V(x) - (x1^2 + x2^2 + x3^2) >= 0
prog = sosineq(prog,V-(x1^2+x2^2+x3^2));

% Constraint 2: -dV/dx*(x3^2+1)*f >= 0
expr = -(diff(V,x1)*f(1)+diff(V,x2)*f(2)+diff(V,x3)*f(3))*(x3^2+1);
prog = sosineq(prog,expr);

solver_opt.solver = 'sedumi';
prog = sossolve(prog,solver_opt);

% =============================================
% Finally, get solution
SOLV = sosgetsol(prog,V);
