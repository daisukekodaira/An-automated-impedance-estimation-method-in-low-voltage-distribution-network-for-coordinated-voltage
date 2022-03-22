function [out] = pso_objective_Unit_B(in)

global_var_declare;

% n = number of particles
% m = number of variables
[n_,m_] = size(in);
out = zeros(n_,1);

for i = 1:n_
    g_Z_T(g_Z_num) = complex(in(i,1),in(i,2));
    g_Z_J(g_Z_num,g_Z_num+1) = complex(in(i,3),in(i,4));
       for j = 1:g_eq_count     
        % calculate error. C means g_I_T(Znum).
        C = conj((g_S_J(g_Z_num+1,j) + g_Z_J(g_Z_num,g_Z_num+1)*g_abs_I_J(g_Z_num+1,j)*g_abs_I_J(g_Z_num+1,j) + g_S_T(g_Z_num,j) + g_Z_T(g_Z_num)*g_abs_I_T(g_Z_num,j)*g_abs_I_T(g_Z_num,j)) / (g_V_J(g_Z_num+1,j) + g_Z_J(g_Z_num,g_Z_num+1)*g_I_J(g_Z_num+1,j))) - g_I_J(g_Z_num+1,j);
        err1(j) =  abs( g_abs_V_T(g_Z_num,j) - abs(g_V_J(g_Z_num+1,j) + g_Z_J(g_Z_num,g_Z_num+1)*g_I_J(g_Z_num+1,j) - g_Z_T(g_Z_num)*C));
        %err1(j) =  abs( 1 - abs(g_V_J(g_Z_num+1,j) + g_Z_J(g_Z_num,g_Z_num+1)*g_I_J(g_Z_num+1,j) - g_Z_T(g_Z_num)*C)/g_abs_V_T(g_Z_num,j));
        % err2 =  abs( 1 - real((g_V_J(g_Z_num+1,j) + g_Z_J(g_Z_num,g_Z_num+1)*g_I_J(g_Z_num+1,j) - g_Z_T(g_Z_num)*C)*conj(C))/real(g_S_T(g_Z_num,j)));
        % err3 =  abs( 1 - imag((g_V_J(g_Z_num+1,j) + g_Z_J(g_Z_num,g_Z_num+1)*g_I_J(g_Z_num+1,j) - g_Z_T(g_Z_num)*C)*conj(C))/imag(g_S_T(g_Z_num,j)));
        % out(i) = out(i) + 10^10*(err1^2)+(err2^2)+(err3^2); % the way of summation of all errors should be reconsider
        % out(i) = out(i) + 10^10*(err1+err2+err3)*(err1+err2+err3);
       end
       if abs(err1) < 0.01
         out(i) = max(abs(err1));
       else
         out(i) = max((1+err1).^4);
       end

end

return