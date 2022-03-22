function [out] = pso_objective_Unit_C(in)

global_var_declare;

% n = number of particles
% m = number of variables
[n_,m_] = size(in);
out = zeros(n_,1);

% % PSO is configured to minimize the output
% % Case1) In the case that properties of pole transfomer is known.
% %             We assume the amplitude of voltage at J-node who has 
% %             the pole-transfomer is known.
% % err1 : |Vp| - C = 0
% % err2 : |Vp| - |Vj1 + Zjp1*Ijp1| = 0
% 
% for i = 1:n_
%      g_V_Pt = complex(in(i,1),in(i,2));
%      g_Z_Pt = complex(in(i,3),in(i,4));
%     % g_Z_Pt = complex(0.0512,0.0267);
%     for j = 1:g_eq_count
%         err1 = abs( 1 - g_abs_V_Pt_const/abs(g_V_Pt));
%         err2 = abs( 1 - abs(g_V_J(1,j) + g_Z_Pt.*g_I_J(1,j))/g_abs_V_Pt_const);
%         %out(i) = out(i) + 10^10*(err1^2)+(err2^2); % the way of summation of all errors should be reconsider
%         %out(i) = out(i) + 10^10*(err1+err2)*(err1+err2);
%         out(i) = out(i) + 10^10*(err2*err2);
%     end
% end
% return


% PSO is configured to minimize the output
% Case2) In the case that properties of pole transfomer is unknown.
% err1 : |Vp - Vj1 - Zjp1*Ijp1|= 0
% err2 : |(Vj1 - Vj2)*conj(Ijp1) - Zjp1*|Ij12|^2| = 0

for i = 1:n_
     g_V_Pt = complex(in(i,1),in(i,2));
     g_Z_Pt = complex(in(i,3),in(i,4));
    % g_Z_Pt = complex(0.0512,0.0267);
    for j = 1:g_eq_count
        err1(j) = abs(  g_V_Pt - g_V_J(1,j) - g_Z_Pt.*g_I_J(1,j));
        %err2 = abs(  (g_V_Pt - g_V_J(1,j))*conj(g_I_J(1,j)) - g_Z_Pt*abs(g_I_J(1,j))*abs(g_I_J(1,j)));
        %out(i) = out(i) + 10^10*(err1^2)+(err2^2); % the way of summation of all errors should be reconsider
        %out(i) = out(i) + 10^10*(err1+err2)*(err1+err2);
        %out(i) = out(i) + 10^10*(err1*err1);
    end
    if abs(err1) < 0.01
        out(i) = max(abs(err1));
    else
        out(i) = max((1+err1).^4);
    end

end
return