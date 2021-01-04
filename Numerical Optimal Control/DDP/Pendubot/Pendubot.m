classdef Pendubot < Robot
    % Class for robot creation
    
    properties
        % model struct
        Name = 'Pendubot'
        l1 = 1.0;
        l2 = 1.0;
        m1 = 1.0;
        m2 = 1.0;
        lc1 = 0.5;
        lc2 = 0.5;
        
        b1 = 0.1;
        b2 = 0.1;
        
        I1 = 0.33;
        I2 = 0.33;
        
        g = 9.81;
    end
    
    methods
        function obj = Pendubot()
            % model parameters
            disp('Creating A Pendubot Model...');
        end
        
        function [M,C,G,F,B] = Sim_EoM(obj,x)
            % INPUTS:
            %    model: struct
            %    x: [4,1] = [q1; q2; q1d; q2d]
            %
            % OUTPUTS:
            %    M: [2,2] = inertia matrix
            %    C: [2,2] = coriolis and centrifugal term
            %    G: [2,1] = gravitational term
            %    F: [2,1] = Fiction force term
                q1 = x(1,:); q2 = x(2,:);
                dq1 = x(3,:); dq2 = x(4,:);

                M11 = obj.I1 + obj.I2 + obj.m2*obj.l1*obj.l1 + 2*obj.m2*obj.l1*obj.lc2*cos(q2);
                M12 = obj.I2 + obj.m2*obj.l1*obj.lc2*cos(q2);
                M21 = M12; M22 = obj.I2;
                M = 1.0*[M11 M12;
                     M21 M22];

                C11 = -2*obj.m2*obj.l1*obj.lc2*sin(q2)*dq2;
                C12 = -obj.m2*obj.l1*obj.lc2*sin(q2)*dq2;
                C21 = obj.m2*obj.l1*obj.lc2*sin(q2)*dq1;
                C22 = 0;
                C = 1.0*[C11 C12;
                     C21 C22];

                G1 = obj.m1*obj.g*obj.lc1*sin(q1)+obj.m1*obj.g*(obj.l1*sin(q1)+obj.lc2*sin(q1+q2));
                G2 = obj.m2*obj.g*obj.lc2*sin(q1+q2);
                G = [G1;G2];
                F = 1.0*[obj.b1 0;
                         0 obj.b2];
                B = [1;0];
        end
        
        function dxdt = Dynamics(obj,t,x,u)
            % nonlinear dynamics
            dq = x(3:4,:);
            [M,C,G,F,B] = obj.Sim_EoM(x);

            ddq = M \ (B*u - G - C*dq - F*dq); 
            dxdt = [dq;
                    ddq];
        end
        
        function [A, B] = getLinSys(obj,x,u)
            % This function was generated by the Symbolic Math Toolbox
            x1 = x(1,:);
            x2 = x(2,:);
            x3 = x(3,:);
            x4 = x(4,:);
            
            t2 = cos(x1);
            t3 = cos(x2);
            t4 = sin(x1);
            t5 = sin(x2);
            t6 = x1+x2;
            t7 = x3.^2;
            t8 = x4.^2;
            t13 = x3.*6.0e+1;
            t16 = u.*6.0e+2;
            t9 = t3.^2;
            t10 = t5.^2;
            t11 = cos(t6);
            t12 = sin(t6);
            t14 = -t13;
            t15 = t3.*1.0e+2;
            t18 = t2.*8.829e+3;
            t19 = t4.*8.829e+3;
            t20 = t5.*x3.*6.0e+2;
            t21 = t5.*x4.*6.0e+2;
            t22 = t3.*t8.*3.0e+2;
            t23 = t5.*t8.*3.0e+2;
            t24 = t3.*x3.*x4.*6.0e+2;
            t28 = t3.*t5.*x3.*1.0e+3;
            t29 = t3.*t5.*x4.*1.0e+3;
            t17 = t9.*2.5e+1;
            t25 = t20.*x4;
            t26 = -t19;
            t27 = t11.*1.2753e+4;
            t30 = t5.*t12.*4.905e+3;
            t31 = t3.*t11.*4.905e+3;
            t33 = t3.*t12.*4.905e+3;
            t32 = t17-3.9e+1;
            t34 = -t30;
            t35 = 1.0./t32;
            t36 = t35.^2;
            A = reshape([0.0,0.0,(t35.*(t18-t31))./2.0e+1,t35.*(t18-t27-t31+t2.*t3.*1.4715e+4).*(-1.0./2.0e+1),0.0,0.0,t35.*(t22+t24+t31+t34+t3.*t7.*3.0e+2+t7.*t9.*5.0e+2-t7.*t10.*5.0e+2-t5.*x4.*1.0e+2).*(-1.0./2.0e+1)-t3.*t5.*t36.*(t14+t16+t23+t25+t26+t33+x4.*6.0e+1+t5.*t7.*3.0e+2+t15.*x4+t3.*t5.*t7.*5.0e+2).*(5.0./2.0),(t35.*(t22+t24+t27+t31+t34+t4.*t5.*1.4715e+4+t3.*t7.*1.6e+3+t7.*t9.*1.0e+3-t7.*t10.*1.0e+3+t8.*t9.*5.0e+2-t8.*t10.*5.0e+2-t5.*u.*1.0e+3+t5.*x3.*1.0e+2-t5.*x4.*2.0e+2+t9.*x3.*x4.*1.0e+3-t10.*x3.*x4.*1.0e+3))./2.0e+1+t3.*t5.*t36.*(t12.*1.2753e+4+t14+t16+t23+t25+t26+t33+x4.*3.2e+2-t3.*t4.*1.4715e+4+t5.*t7.*1.6e+3+t3.*u.*1.0e+3-t3.*x3.*1.0e+2+t3.*x4.*2.0e+2+t28.*x4+t3.*t5.*t7.*1.0e+3+t3.*t5.*t8.*5.0e+2).*(5.0./2.0),1.0,0.0,t35.*(t20+t21+t28-6.0e+1).*(-1.0./2.0e+1),(t35.*(-t15+t21+t29+t5.*x3.*3.2e+3+t3.*t5.*x3.*2.0e+3-6.0e+1))./2.0e+1,0.0,1.0,t35.*(t15+t20+t21+6.0e+1).*(-1.0./2.0e+1),(t35.*(t3.*2.0e+2+t20+t21+t28+t29+3.2e+2))./2.0e+1],[4,4]);
            if nargout > 1
                B = [0.0;0.0;t35.*-3.0e+1;(t35.*(t3.*1.0e+3+6.0e+2))./2.0e+1];
            end
        end
        % Linearized equations of motion 
        function Phi = Phi(obj, x, u, dt)
                [A, ~] = obj.getLinSys(x,u);
                Phi = eye(numel(x)) + A .* dt;
        end
        
        function beta = beta(obj, x, u, dt)
                [~, B] = obj.getLinSys(x,u);
                beta = B .* dt;
        end
    end
end
