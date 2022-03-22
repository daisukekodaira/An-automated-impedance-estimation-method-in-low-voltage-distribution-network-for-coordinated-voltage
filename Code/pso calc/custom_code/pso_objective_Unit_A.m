function [out] = pso_objective_Unit_A(in)

global_var_declare;

% n = number of particles
% m = number of variables
[n_,m_] = size(in);
out = zeros(n_,1);
data=zeros(n_,n_);

% PSO is configured to minimize the output
% err1 is related to voltage of T-node_(N-1)
% err2 is related to active power of T-node_(N-1)
% err3 is related to reactive power of T-node_(N-1)

for i = 1:n_ % n_ means "particle"
%     g_Z_T(g_N-1) = complex(0.04360,0.00206);
     g_Z_T(g_N-1) = complex(in(i,1),in(i,2));
%     g_Z_comb = complex(0.0948,0.02876);
    g_Z_comb = complex(in(i,3),in(i,4));
    
    for j = 1:g_eq_count
        g_abs_I_T(g_N,j) = abs(g_I_T(g_N,j));
        A = conj((g_S_T(g_N,j) + g_Z_comb*g_abs_I_T(g_N,j)*g_abs_I_T(g_N,j)+g_S_T(g_N-1,j) + g_Z_T(g_N-1)*g_abs_I_T(g_N-1,j)*g_abs_I_T(g_N-1,j)) / (g_V_T(g_N,j) + g_Z_comb*g_I_T(g_N,j))) - g_I_T(g_N,j);
        err1(j) = abs( g_abs_V_T(g_N-1,j) - abs(g_V_T(g_N,j) + g_Z_comb*g_I_T(g_N,j) - g_Z_T(g_N-1)*A));
        %err1(j) = abs( 1 - abs(g_V_T(g_N,j) + g_Z_comb*g_I_T(g_N,j) - g_Z_T(g_N-1)*A)/g_abs_V_T(g_N-1,j));
        % err2(j) = abs( 1 - real((g_V_T(g_N,j) + g_Z_comb*g_I_T(g_N,j) - g_Z_T(g_N-1)*A)*conj(A))/real(g_S_T(g_N-1,j)));
        % err3(j) = abs( 1 - imag((g_V_T(g_N,j) + g_Z_comb*g_I_T(g_N,j) - g_Z_T(g_N-1)*A)*conj(A))/imag(g_S_T(g_N-1,j)));
    end
    
     if abs(err1) < 0.01
         out(i) = max(abs(err1));
     else
         out(i) = max((1+err1).^4);
     end
    
end

% %% Make a 3D graph 
% g_x = in(:,1);
% g_y = in(:,2);
% g_z = out;
% 
% % plot3(g_x/(10^10),g_y/(10^10),g_z/(10^10),'.','MarkerSize',20); %nonuniform
% % hold on
% % axis([0 0.1 0 0.01 0.01])
% 
% F = TriScatteredInterp(g_x,g_y,g_z);
% xlin = linspace(0, 1 ,100);
% ylin = linspace(0, 1 ,100);
% [qx,qy] = meshgrid(xlin,ylin);
% qz = F(qx,qy);
% mesh(qx,qy,qz); %interpolated
% hold on

% %% Labels of graph
% % xlabel('Z_{t} Real part','FontSize',17,'FontWeight','bold') % x-axis label
% % ylabel('Z_{t} Imaginary part','FontSize',17,'FontWeight','bold') % y-axis label
% % zlabel('cost function 1','FontSize',17,'FontWeight','bold') % z-axis label
% set(gca, 'FontName','Times','FontSize',20,'FontWeight','bold' ); 

return