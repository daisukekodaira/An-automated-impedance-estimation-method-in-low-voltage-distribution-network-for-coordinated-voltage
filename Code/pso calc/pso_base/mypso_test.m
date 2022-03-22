clear;
functname = 'mypso_test_objective';
dims=2;
particlesize = 25;
varrange=[-40 40; -40 40];
%varrange=[-30 30];
mvden = 20;    % Bigger value makes the search area wider
ismaximize = 0; 
epoch   = 100; % max iterations
errgrad = 1e-99;   % lowest error gradient tolerance
errgraditer=50; % max # of epochs without error change >= errgrad

% plotfcn=1 Intense graphics, shows error topology and surfing particles');
% plotfcn=2 Default PSO graphing, shows error trend and particle dynamics');
% plotfcn=3 no plot, only final output shown, fastest');
plotfcn = 1;

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

mv=[];
for i=1:dims
  mv=[mv;(varrange(i,2)-varrange(i,1))/mvden];
end

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

global g_Hole;
g_Hole = 5;
% run pso
% vectorized version
[pso_out,tr,te]=pso_Trelea_vectorized(functname, dims,...
  mv, varrange, ismaximize, psoparams,plotfcn,PSOseedValue);
%-------------------------------------------------------------------------- 
% display best params, this only makes sense for static functions, for dynamic
% you'd want to see a time history of expected versus optimized global best
% values.
disp(' ');
disp(' ');
disp(['Best fit parameters: ']);
disp([' cost = ',functname,'( [ input1, input2 ] )']);
disp(['---------------------------------']);
for i = 1:dims
    fprintf('      input%d = %f\n',i,pso_out(i));
end
disp(['        cost = ',num2str(pso_out(dims+1))]);
disp(['   mean cost = ',num2str(mean(te))]);
disp([' # of epochs = ',num2str(tr(end))]);