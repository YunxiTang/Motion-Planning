function [success] = Setup_Functions(params,rbtmdl,cstmdl)
%SETUP_FUNCTIONS setup some important functions for solvers
%%% ARGS
%%% params           struct           set of params
%%% rbtmdl           class            robot model
%%% cstmdl           class            cost model
%%% success          int              1/0 (0->ERROR)
success = 0;
nx = params.nx;
nu = params.nu;
u = sym('u',[nu 1]','real');
x = sym('x',[nx 1]','real');
lambda = sym('lambda',[nx 1]','real'); % represent Vx_next here
Vxx = sym('Vxx',[nx nx],'real');

xf = params.xf;
dt = params.dt;
Q = cstmdl.Q;
R = cstmdl.R;
Qf = cstmdl.Qf;

%%% write cost function (any form) here
l = 1/2*(x-xf).'*Q*(x-xf) + 1/2*u.'*R*u;
l = l * dt;
lf = 1/2*(x-xf).'*Qf*(x-xf);

%%% introduce relax-log barrier function later
%%% compute derivatives of cost function
lx   = jacobian(l,x);   lu   = jacobian(l,u);
lxx  = jacobian(lx,x);  luu  = jacobian(lu,u);
lux  = jacobian(lu,x);  lxu  = jacobian(lx,u);
lfx  = jacobian(lf, x); lfxx = jacobian(lfx,x);

matlabFunction(l, 'vars',{x, u},'file','@cst_mdl/l_cost', 'optimize',1==1);
matlabFunction(lf,'vars',{x},'file','@cst_mdl/lf_cost','optimize',1==1);
matlabFunction(l,lx,lu,lxx,lux,lxu,luu, 'vars',{x, u},...
               'file','@cst_mdl/l_info','optimize',1==1);
matlabFunction(lf,lfx,lfxx,'vars',{x},'file','@cst_mdl/lf_info','optimize',1==1);

%%% derive Pendulum dynamics and compute anylytical dederivatives
f = rbtmdl.Dynamics(0, x, u);
fx_ctn = jacobian(f,x);
fu_ctn = jacobian(f,u);
fx = eye(nx) + fx_ctn .* dt;
fu = fu_ctn .* dt;
matlabFunction(fx, fu, 'vars',{x, u},'file','@rbt_mdl/getLinSys', 'optimize',1==1);

%%% derive Q_info
Qx = lx + fx.' * lambda;
Qu = lu + fu.' * lambda;
Qxx = lxx + fx.' * Vxx * fx;
Quu = luu + fu.' * Vxx * fu;
Qux = lux + fu.' * Vxx * fx;
Qxu = lxu + fx.' * Vxx * fu;
matlabFunction(Qx,Qu,Qxx,Quu,Qux,Qxu,'vars',{x,u,lambda,Vxx},'file','@cst_mdl/Q_info', 'optimize',1==1);
end

