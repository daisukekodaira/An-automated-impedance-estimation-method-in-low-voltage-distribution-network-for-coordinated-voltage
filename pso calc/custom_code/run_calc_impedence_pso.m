% PSO performance related parameters
ismaximize = 0;
errgrad = 1;%1e-99;   % lowest error gradient tolerance
errgraditer=1000; % max # of epochs without error change >= errgrad

% define functname
if g_Z_flag==0
    functname = 'pso_objective_Unit_A';
elseif g_Z_flag==1
    functname = 'pso_objective_Unit_B';
elseif g_Z_flag==2
    functname = 'pso_objective_Unit_C';
end

% Max particle velocity, either a scalar or a vector of length D
% (This allows each component to have it's own max velocity),
% dfault = 4, set if not input or input as NaN
dims = 4;   % 4 variables (two pairs of resistance+reactance)

% Upper & Lower bound for each variable
% Z=R+jX (resistance and reactance)
% the value is defined in "simul_1_data_config"
if g_Z_flag==0 | g_Z_flag==1
    varrange= [
        g_min_resistance   g_max_resistance    
        g_min_reactance   g_max_reactance      
        g_min_resistance   g_max_resistance     
        g_min_reactance   g_max_reactance       
        ];
elseif g_Z_flag==2
    varrange= [
        g_min_voltage   g_max_voltage   
        g_min_voltage   g_max_voltage      
        g_min_resistance   g_max_resistance     
        g_min_reactance   g_max_reactance       
        ];
end  
    
mv=[];
for i=1:dims
    mv=[mv;(varrange(i,2)-varrange(i,1))/mvden];
end

% Graphicla Illustration Option
% plotfcn=1 Intense graphics, shows error topology and surfing particles');
% plotfcn=2 Default PSO graphing, shows error trend and particle dynamics');
% plotfcn=3 no plot, only final output shown, fastest');
plotfcn = 3;

if plotfcn == 1
    plotfcn = 'goplotpso4demo';
    shw     = 1;   % how often to update display
elseif plotfcn == 2
    plotfcn = 'goplotpso';
    shw     = 1;   % how often to update display
else
    plotfcn = 'goplotpso';
    shw     = 0;   % how often to update display
end

% Other parameters
modl = 0;       % 0 = Common PSO w/intertia (default) / 1,2 = Trelea types 1,2 / 3= Clerc's Constricted PSO, Type 1"
ac      = [2.1,2.1];% acceleration constants, only used for modl=0
Iwt     = [0.9,0.6];  % intertia weights, only used for modl=0
wt_end  = 100; % iterations it takes to go from Iwt(1) to Iwt(2), only for modl=0
PSOseed = 0;    % if=1 then can input particle starting positions, if= 0 then all random
% starting particle positions (first 20 at zero, just for an example)
PSOseedValue = repmat([0],particlesize-10,1);

psoparams=...
    [shw epoch particlesize ac(1) ac(2) Iwt(1) Iwt(2) ...
    wt_end errgrad errgraditer NaN modl PSOseed];

% tic;
% run pso
% vectorized version
[pso_out,tr,te]=pso_Trelea_vectorized(functname, dims,...
    mv, varrange, ismaximize, psoparams,plotfcn,PSOseedValue);
% toc;

% %--------------------------------------------------------------------------
% % display best params, this only makes sense for static functions, for dynamic
% % you'd want to see a time history of expected versus optimized global best
% % values.
% disp(' ');
% disp(' ');
% disp(['Best fit parameters: ']);
% disp(['        cost = ',num2str(pso_out(dims+1))]);
% disp(['   mean cost = ',num2str(mean(te))]);
% disp([' # of epochs = ',num2str(tr(end))]);
% 
% %--------------------------------------------------------------------------



