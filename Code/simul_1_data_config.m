% the patterns of load
g_eq_count = 6;

% the number of T-node
g_N=5;

% search area of impedance for PSO
g_max_resistance = 1;
g_max_reactance = 1; 
g_min_resistance = 0; 
g_min_reactance = 0;
g_max_voltage = 100;
g_min_voltage = 0;

% define objective vaiables
g_Z_T=zeros(g_N-1,1);       % impedance from J-nodes to T-nodes
g_Z_J=zeros(g_N-1,g_N-1);   % e.g.) imnpendace from J-node_2 to J-node_3 is represented as g_Z_J(2,3)
g_Z_Pt=zeros(1,1);          % impedance from J-node at Pole-trans to J-node_1
g_V_Pt=zeros(1,1);          % voltage at J-node with Pole-trans

% define node parameters matrix
g_V_T=zeros(g_N,g_eq_count);   % voltage of T-nodes           
g_I_T=zeros(g_N,g_eq_count);   % injencted current of T-nodes
g_S_T=zeros(g_N,g_eq_count);   % apparent power of T-nodes
g_abs_I_T=zeros(g_N,g_eq_count);    % absolute injected current of T-nodes
g_abs_V_T=zeros(g_N,g_eq_count);    % absolute voltage of T-nodes

g_S_J=zeros(g_N-1,g_eq_count);    % apparent power of J-nodes
g_V_J=zeros(g_N-1,g_eq_count);    % voltage of J-nodes
g_I_J=zeros(g_N-1,g_eq_count);    % e.g.) injected current from J-node_2 to J-node_3 is represented as g_I_J(3)

g_S_Pt=zeros(1,g_eq_count);       % apparent power at J-node with Pole-trans
g_V_Pt=zeros(1,g_eq_count);       % voltage at J-node with Pole-trans
g_I_Pt=zeros(1,g_eq_count);       % current from J-node at Pole-trans to J-node_1

% p.u. base setting
S_base = 10000;
V_base = 100;
I_base = S_base / V_base;
Z_base = V_base*V_base / S_base;

%%% Parameter setting at each terminal node
% In this case, we assumed 5 T-nodes and 6 loads patterns
% g_S_T : any apparent power can be set
% g_V_T : this is calculated by "power flow analysis" based on g_S_T and actual impedance
% g_I_T : It's same as g_V_T
% g_N : farest node from pole transformer e.g.) g_S_T(g_N,:) means paarent power of T-node_N (six patterns) 
% g_N-5 : nearest node from pole trans former
% T-node_N parameters need information of phase, so they are represented as complex number 
g_S_T(g_N,:) = [0.2000 + 0.1000i ; 0.2700 + 0.1500i ; 0.1200 + 0.0300i ; 0.3100 + 0.0300i ; 0.2300 + 0.1300i ; 0.3500 + 0.2100i] * S_base;
g_V_T(g_N,:) = [0.7674 - 0.0398i ; 0.7598 - 0.0140i ; 0.8838 - 0.0241i ; 0.8112 - 0.0480i ; 0.8106 - 0.0088i ; 0.7829 + 0.0043i] * V_base;
g_I_T(g_N,:) = [0.2532 - 0.1435i ; 0.3516 - 0.2039i ; 0.1347 - 0.0376i ; 0.3786 - 0.0594i ; 0.2820 - 0.1634i ; 0.4485 - 0.2658i] * I_base;
g_abs_I_T(g_N,:) = abs(g_I_T(g_N,:));

g_S_T(g_N-1,:)= [0.2500 + 0.0300i ; 0.1000 + 0.0200i ; 0.0700 + 0.0100i ; 0.1100 + 0.0300i ; 0.1340 + 0.0450i ; 0.0300 + 0.0050i] * S_base;
g_abs_V_T(g_N-1,:) = [0.7828 ; 0.7938 ; 0.8946 ; 0.8442 ; 0.8351 ; 0.8315] * V_base;
g_abs_I_T(g_N-1,:) = [0.3216 ; 0.1285 ; 0.0790 ; 0.1351 ; 0.1693 ; 0.0366] * I_base;

g_S_T(g_N-2,:)= [0.2000 + 0.0100i ; 0.3000 + 0.0500i ; 0.1500 + 0.0200i ; 0.1300 + 0.0200i ; 0.0550 + 0.0260i ; 0.1100 + 0.0200i] * S_base;
g_abs_V_T(g_N-2,:) = [0.8204 ; 0.8137 ; 0.9029 ; 0.8716 ; 0.8678 ; 0.8595] * V_base;
g_abs_I_T(g_N-2,:) = [0.2441 ; 0.3738 ; 0.1676 ; 0.1509 ; 0.0701 ; 0.1301] * I_base;

g_S_T(g_N-3,:)= [0.2000 + 0.0150i ; 0.1000 + 0.0400i ; 0.0800 + 0.0300i ; 0.0300 + 0.0150i ; 0.1250 + 0.0130i ; 0.1000 + 0.0150i] * S_base;
g_abs_V_T(g_N-3,:) = [0.8681 ; 0.8760 ; 0.9276 ; 0.9134 ; 0.8970 ; 0.8995] * V_base;
g_abs_I_T(g_N-3,:) = [0.2310 ; 0.1230 ; 0.0921 ; 0.0367 ; 0.1401 ; 0.1124] * I_base;

g_S_T(g_N-4,:)= [0.0400 + 0.0050i ; 0.0350 + 0.0150i ; 0.2300 + 0.1000i ; 0.1200 + 0.0250i ; 0.3000 + 0.0050i ; 0.0800 + 0.0150i] * S_base;
g_abs_V_T(g_N-4,:) = [0.9359 ; 0.9377 ; 0.9473 ; 0.9482 ; 0.9291 ; 0.9461] * V_base;
g_abs_I_T(g_N-4,:) = [0.0431 ; 0.0406 ; 0.2648 ; 0.1293 ; 0.3229 ; 0.0860] * I_base;

%%% Parameter setting at J-node at Pole-trans
g_abs_V_Pt_const = V_base; % The voltage at J-node with Pole-trans is assumed as stable 100V




