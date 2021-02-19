function [fx,fu] = getLinSys(in1,u1)
%GETLINSYS
%    [FX,FU] = GETLINSYS(IN1,U1)

%    This function was generated by the Symbolic Math Toolbox version 8.4.
%    19-Feb-2021 14:52:41

x1 = in1(1,:);
fx = reshape([1.0,cos(x1).*(-1.691379310344828e-1),1.0./5.0e+1,7.22e+2./7.25e+2],[2,2]);
if nargout > 1
    fu = [0.0;1.0./2.9e+1];
end