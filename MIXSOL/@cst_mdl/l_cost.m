function l = l_cost(in1,u1)
%L_COST
%    L = L_COST(IN1,U1)

%    This function was generated by the Symbolic Math Toolbox version 8.4.
%    23-Feb-2021 21:14:27

x1 = in1(1,:);
x2 = in1(2,:);
l = ((x1./2.0-1.57e+2./1.0e+2).*(x1-1.57e+2./5.0e+1))./5.0e+1+u1.^2./1.0e+2+x2.^2./1.0e+2;
