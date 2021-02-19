function [lf,lfx,lfxx] = lf_info(in1)
%LF_INFO
%    [LF,LFX,LFXX] = LF_INFO(IN1)

%    This function was generated by the Symbolic Math Toolbox version 8.4.
%    19-Feb-2021 17:34:22

x1 = in1(1,:);
x2 = in1(2,:);
t2 = x1-1.57e+2./5.0e+1;
lf = t2.*(x1./2.0-1.57e+2./1.0e+2)+x2.^2./2.0;
if nargout > 1
    lfx = [t2,x2];
end
if nargout > 2
    lfxx = reshape([1.0,0.0,0.0,1.0],[2,2]);
end
