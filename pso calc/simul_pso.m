function [result, err] = simul_pso()
% Include base modules for PSO
addpath(genpath('./pso_base'));

% Include custom simulation base modules
addpath('./custom_code');

% include the simulation root for data configuration (price, h/w params)
addpath('../');

% Declare the global variables
global_var_declare;

% Load parameters
simul_1_data_config;

% Essential paramerters for PSO performance
particlesize = 200;  % number of particles
mvden = 300;    % Bigger value makes the search area wider
epoch   = 2000;  % max iterations

% run the PSO from run_calc_impedence_pso
% Z_T(g_N-1) is impedance of (N-1)th of T-nodes
% impedance of (N)th of T-nodes is represented as Z_comb
% g_Z_flag=0 : calculate Z_comb and Z_T_N-1 (Unit-A)
% g_Z_flag=1 : calculate the others (Unit-B)


%%%%%%%% Unit-A
g_Z_flag=0;
run_calc_impedence_pso; % "run_calc_impedence_pso" returns optimum impedance pso_out(1)~(4) based on "simul_1_data_config"

% If you want to set the correct value to each impedace, use this part
% and comment "pso_out(1),pso_out(2),pso_out(3) and pso_out(4)" out
% ----------------------------------------------------------------------
% g_Z_T(g_N-1) = complex(0.04360,0.00206);
% g_Z_comb = complex(0.0948,0.02876);
% -----------------------------------------------------------------------

g_Z_T(g_N-1) = complex(pso_out(1),pso_out(2));
g_Z_comb = complex(pso_out(3),pso_out(4));


% Calculate parameters of J-node(N-1) based on Z_comb and Z_T(g_N-1)
% these parameters will be utilized in Unit-B
% Current from J-node(2) to J-node(3) is represented as g_I_J(3)
g_S_J(g_N-1,:) = g_S_T(g_N,:) + g_Z_comb.*g_abs_I_T(g_N,:).*g_abs_I_T(g_N,:) + g_S_T(g_N-1,:) + g_Z_T(g_N-1).*g_abs_I_T(g_N-1,:).*g_abs_I_T(g_N-1,:);
g_V_J(g_N-1,:) = g_V_T(g_N,:) + g_Z_comb.*g_I_T(g_N,:);
g_I_J(g_N-1,:) = conj((g_S_T(g_N,:) + g_Z_comb.*g_abs_I_T(g_N,:).*g_abs_I_T(g_N,:) + g_S_T(g_N-1,:) + g_Z_T(g_N-1).*g_abs_I_T(g_N-1,:).*g_abs_I_T(g_N-1,:))./ (g_V_T(g_N,:)+g_Z_comb.*g_I_T(g_N,:)));
g_abs_I_J(g_N-1,:) = abs(g_I_J(g_N-1,:));
%%%%%%%%

%%%%%%%% Unit-B iterates
g_Z_flag=1;
for i = 1 : g_N-2
    g_Z_num = g_N-2 - (i-1);
    run_calc_impedence_pso;
    g_Z_T(g_Z_num) = complex(pso_out(1),pso_out(2));
    g_Z_J(g_Z_num,g_Z_num+1) = complex(pso_out(3),pso_out(4));
    % Calculate parameters of J-node
    g_S_J(g_Z_num,:) = g_S_J(g_Z_num+1,:) + g_Z_J(g_Z_num,g_Z_num+1).*g_abs_I_J(g_Z_num+1,:).*g_abs_I_J(g_Z_num+1,:) + g_S_T(g_Z_num,:) + g_Z_T(g_Z_num).*g_abs_I_T(g_Z_num,:).*g_abs_I_T(g_Z_num,:);
    g_V_J(g_Z_num,:) = g_V_J(g_Z_num+1,:) + g_Z_J(g_Z_num,g_Z_num+1).*g_I_J(g_Z_num+1,:);
    g_I_J(g_Z_num,:) = conj(g_S_J(g_Z_num,:)./g_V_J(g_Z_num,:));
    g_abs_I_J(g_Z_num,:) = abs(g_I_J(g_Z_num,:));
end
%%%%%%%%

%%%%%%%% Unit-C iterates
g_Z_flag=2;
run_calc_impedence_pso;
g_V_Pt = complex(pso_out(1),pso_out(2));
g_Z_Pt = complex(pso_out(3),pso_out(4));
%%%%%%%%

result = {real(g_Z_Pt) imag(g_Z_Pt) ... % Z(2)
              real(g_Z_T(g_N-4)) imag(g_Z_T(g_N-4)) ... % Z(3)
              real(g_Z_J(g_N-4,g_N-3)) imag(g_Z_J(g_N-4,g_N-3)) ... % Z(4)
              real(g_Z_T(g_N-3)) imag(g_Z_T(g_N-3)) ... % Z(5)
              real(g_Z_J(g_N-3,g_N-2)) imag(g_Z_J(g_N-3,g_N-2)) ... % Z(6)
              real(g_Z_T(g_N-2)) imag(g_Z_T(g_N-2)) ... % Z(7)
              real(g_Z_J(g_N-2,g_N-1)) imag(g_Z_J(g_N-2,g_N-1)) ... % Z(8)
              real(g_Z_T(g_N-1)) imag(g_Z_T(g_N-1)) ... % Z(9)
              real(g_Z_comb) imag(g_Z_comb) ... % Z(10)
              };
result = cell2mat(result);
actual = [0.05120 0.02670 ... % Z(2)
              0.04360 0.00206 ... % Z(3) 
              0.05120 0.02670 ... % Z(4)
              0.04360 0.00206 ... % Z(5)
              0.05120 0.02670 ... % Z(6)
              0.04360 0.00206 ... % Z(7)
              0.05120 0.02670 ... % Z(8)
              0.04360 0.00206 ... % Z(9)
              0.09480 0.02876 ... % Z(10)
              ];
err = result - actual;
end





