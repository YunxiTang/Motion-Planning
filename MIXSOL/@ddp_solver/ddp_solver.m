classdef ddp_solver < handle
    %DDPSOLVER ddp solver
    
    properties
        Reg = 0.0,
        eps = 1.0,
        gamma = .5,
        lammda = .5,
        iter = 0,
        Jstore = []
    end
    
    methods
        function obj = ddp_solver()
            %DDP_SOLVER 
            disp('[INFO]: Calling DDP/SLQ solver.');
        end
        
        function [] = J_pushback(obj, J)
            obj.Jstore = [obj.Jstore J];
        end
        
        function [] = Update_iter(obj)
            obj.iter = obj.iter + 1;
        end
        
        function [xbar, ubar] = Init_Forward(obj,rbt,params)
            %METHOD1 Init rollout
            ubar = zeros(params.nu, params.N);
            xbar = zeros(params.nx, params.N);

            xbar(:,1) = params.x0;
            xi = params.x0;
            % Make initial Guess
            for i = 1:(params.N-1)
                % Option 1: PD Control
                ui = -[30 5] * (xi - params.xf);
                % Option 2: Zero
                % ui = 0;
                ubar(:,i) = ui;
                xi = rbt.rk45(xi,ui,params.dt);
                xbar(:,i+1) = xi;
            end
            plot(xbar(1,:));hold on;
            plot(xbar(2,:));
        end
        
        function [J,x,u] = ForwardPass(obj,rbt,cst,params,xbar,ubar,du,K)
            %%% forward rollout
            alpha = obj.eps;
            J = 0;
            x = 0*xbar;
            u = 0*ubar;
            x(:,1) = xbar(:,1);
            xi = xbar(:,1);
            for i=1:params.N-1
                dxi = xi - xbar(:,i);
                % Update with stepsize and feedback
                ui = ubar(:,i) + alpha*du(:,i) + K(:,:,i)*dxi;
                u(:,i) = ui;
                % Add up cost
                J = J + cst.l_cost(xi, ui);
                % Propagate dynamics
                xi = rbt.rk45(xi, ui, params.dt);
                x(:,i+1) = xi;
            end
            J = J + cst.lf_cost(x(:,params.N));
            obj.J_pushback(J);
        end
        
        function [dV,Vx,Vxx,du,K,success] = BackwardPass(obj,rbt,cst,xbar,ubar,params)
            %%% backward pass
            success = 1;
            % Initialization
            dV = 0.0;
            Vx = zeros(params.nx, params.N);
            Vxx = zeros(params.nx, params.nx, params.N);
            du = zeros(params.nu, params.N);
            K = zeros(params.nu, params.nx, params.N);
            
            xf = xbar(:,params.N);
            [lf,lfx,lfxx] = cst.lf_info(xf);
            Vx(:,params.N) = lfx;
            Vxx(:,:,params.N) = lfxx;
            for i = (params.N-1):-1:1
                xi = xbar(:,i);
                ui = ubar(:,i);
                Vxi = Vx(:,i+1);
                Vxxi = Vxx(:,:,i+1);
                [Qx,Qu,Qxx,Quu,Qux,Qxu] = cst.Q_info(xi,ui,Vxi,Vxxi);
                % regularization
                Quu = Quu + eye(params.nu)*obj.Reg;
                % Make sure Quu is PD, if not, exit and increase regularization
                [~, FLAG] = chol(Quu-eye(params.nu)*1e-9);
                if FLAG ~= 0 
                    % Quu is not PD, then break out to increase Reg factor
                    success = 0;
                    if params.Debug == 1
                        disp('    [SubSubInfo]: Break BP to increase Reg. \n');
                    end
                    break
                end
                % Standard equations
                kff = -Quu\Qu;
                kfb = -Quu\Qux;
                du(:,i)  = kff;
                K(:,:,i) = kfb;
                Vx(:,i)  = Qx + kfb'*Qu + Qux*kff + kfb'*Quu*kff;
                Vxx(:,:,i) = Qxx + Qux*kfb + kfb'*Qxu + kfb'*Quu*kfb;
                dV = dV + 1/2*kff'*Quu*kff + kff'*Qu;
            end   
        end
        
        function outputArg = ForwardIteration(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
        
        function [] = Solve(obj,rbt,cst,params)
            % init rolling out
            [xbar, ubar] = obj.Init_Forward(rbt,params);
            du = zeros(params.nu, params.N);
            K = zeros(params.nu, params.nx, params.N);
            [Jbar,xbar,ubar] = obj.ForwardPass(rbt,cst,params,xbar,ubar,du,K);
            obj.Update_iter();
            
            %%% start iteration
            while obj.iter <= params.Max_iter
                if params.Debug == 1
                    fprintf('[INFO]: Iteration %3d   ||  Cost %5f \n',obj.iter, Jbar);
                end
                success = 0;
                while success == 0
                    if params.Debug == 1
                        fprintf('  [SubInfo]: Reg=%5f\n',obj.Reg);
                    end
                    [dV,Vx,Vxx,du,K,success] = obj.BackwardPass(xbar, ubar, params,regularization);
                    if success == 0
                        % need increase Reg factor (max incremental is 1e-3)
                        obj.Reg = max(obj.Reg*4, 1e-3);
                    end
                    
                end
            end
        end
    end
end

