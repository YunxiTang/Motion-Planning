function l = l_cost(in1,u1)
%L_COST
%    L = L_COST(IN1,U1)

%    This function was generated by the Symbolic Math Toolbox version 8.4.
%    02-Mar-2021 11:28:14

x1 = in1(1,:);
x2 = in1(2,:);
l = ((x1./2.0-1.57e+2./1.0e+2).*(x1-1.57e+2./5.0e+1))./1.0e+2+u1.^2./2.0e+2+x2.^2./2.0e+2;
