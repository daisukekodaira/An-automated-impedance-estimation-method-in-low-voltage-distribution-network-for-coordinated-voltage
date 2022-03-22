% all global values are represented as g_*

global g_eq_count;  % equation count (patterns of load profile)
global g_max_resistance;    % maximum search area of resistance in Ohm for PSO
global g_max_reactance;     % maximum search area of reanctance in Ohm for PSO
global g_min_resistance;    % minimum search area of resistance in Ohm for PSO
global g_min_reactance;     % minimum search area of reanctance in Ohm for PSO

global g_N;   % N is the number of the T-node
global g_Z_flag; % to distiguish pso_objecive file (UnitA, UnitB, UnitC)
global g_Z_num;   % to distiguish which impedance is calculated in Unit-B (using pso_objective_after_the_second)

% teminal node parameters
global g_Z_T;
global g_Z_comb;
global g_V_T;
global g_I_T;
global g_S_T;
global g_abs_I_T;
global g_abs_V_T;

% junction node parameters
global g_Z_J;
global g_V_J;
global g_I_J;
global g_S_J;
global g_abs_I_J;
global g_abs_V_J;

% junction node with Pole-trans parameters
global g_Z_Pt
global g_S_Pt
global g_V_Pt
global g_abs_V_Pt_const % the magnitude of V_Pt is known as 100V
global g_I_Pt

% graph plot
global g_x
global g_y
global g_z