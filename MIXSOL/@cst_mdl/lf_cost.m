function lf = lf_cost(in1)
%LF_COST
%    LF = LF_COST(IN1)

%    This function was generated by the Symbolic Math Toolbox version 8.4.
%    23-Feb-2021 21:14:28

x1 = in1(1,:);
x2 = in1(2,:);
lf = (x1./2.0-1.57e+2./1.0e+2).*(x1-1.57e+2./5.0e+1)+x2.^2./2.0;
