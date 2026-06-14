%% REACHABILITY ANALYSIS DISCRETE-TIME LINEAR SPRING MASS SYSTEM
% rechability analysis with CORA, we use a 2-step approach:
% 1 - reachability analysis for the Controller, with input
%   [-1,1]
% 2 - reachability analysis for the Plant, with as input the
%   reachability analysis of "force"

clear; clc;

%% System modelling
% the system discrete time

Ts = 100 ; % discretized at 100Hz
Delta_t = 1/Ts;

% Plant ODE

Ap = [1 0.01
    -0.01 1];
Bp = [0.00005
    0.01];
Cp = [1 0];

% Controller ODE

Ac = [0.4990 -0.05
    0.01 1];
Bc = [1
    0];
Cc = [564.48 0];
Dc = -1280;

%% initialization parameters

% controller
x1c_lb = -0.0 ;
x1c_ub = 0.0 ;
for_lb = -0.0 ;
for_ub = 0.0 ;
% plant
pos_lb = -2 ;
pos_ub = 2 ;
speed_lb = -0 ;
speed_ub = 0 ;

% input_controller - saturated
input_lb = -1.0;
input_ub = 1.0;

time_run = 2 ; % seconds we run the system for

%% reachability analysis - Controller

sys = linearSysDT(Ac,Bc,Delta_t);  % subsystem dynamics

% parameter for reachability analysis
params.tFinal = time_run; % duration
params.R0 = zonotope(interval([x1c_lb; for_lb],[x1c_ub; for_ub])); % initialization
params.U = zonotope(interval(input_lb,input_ub)); % input

% reachability settings
options.zonotopeOrder = 25;

% reachability analysis
R_controller = reach(sys,params,options);

title_graph_controller = sprintf('Controller. Time = %d s, input bounds = [%d, %d]', params.tFinal, input_lb, input_ub);

%% Bounds computation on state-space : force

e1 = [1; 0];   % unit vector for dimension 1
e2 = [0; 1];   % unit vector for dimension 2

for k = 1:size((R_controller.timePoint.set),1)
    ub(k) =  supportFunc(R_controller.timePoint.set{k},  e2);   % max in dim 2
    lb(k) = -supportFunc(R_controller.timePoint.set{k}, -e2);   % min in dim 2
    ub_x1(k) =  supportFunc(R_controller.timePoint.set{k},  e1);   % max in dim 1
    lb_x1(k) = -supportFunc(R_controller.timePoint.set{k}, -e1);   % min in dim 1
end

% bounds obtained 
min_force = min(lb);
max_force = max(ub);
min_x1 = min(lb_x1);
max_x1 = max(ub_x1);

%% reachability analysis - Plant

sys = linearSysDT(Ap,Bp,Delta_t); % subsystem dynamics


% parameter for reachability analysis
params.tFinal = time_run; 
params.R0 = zonotope(interval([pos_lb; speed_lb],[pos_ub; speed_ub]));
params.U = zonotope(interval(min_force,max_force));

% reachability settings
options.zonotopeOrder = 25;

% reachability analysis
R_plant = reach(sys,params,options);

title_graph_plant = sprintf('Plant. Time = %d s, input bounds = [%d, %d]', params.tFinal, min_force, max_force);

%% Bounds on state-space : position + speed

for k = 1:size((R_plant.timePoint.set),1)
    ub_p(k) =  supportFunc(R_plant.timePoint.set{k},  e1);   % max in dim 1
    lb_p(k) = -supportFunc(R_plant.timePoint.set{k}, -e1);   % min in dim 1
    ub_s(k) =  supportFunc(R_plant.timePoint.set{k},  e2);   % max in dim 2
    lb_s(k) = -supportFunc(R_plant.timePoint.set{k}, -e2);   % min in dim 2
end

% bounds computed
min_pos = min(lb_p);
max_pos = max(ub_p);
min_speed = min(lb_s);
max_speed= max(ub_s);

%% plot the results


figure 

hold on;
n = size((R_controller.timePoint.set),1);
colors = lines(n);
% rectangle vertices (closed polygon)
x_min = min_x1 ; 
x_max = max_x1 ;
y_min = min_force ; 
y_max = max_force ;
vx = [x_min, x_max, x_max, x_min, x_min];
vy = [y_min, y_min, y_max, y_max, y_min];
patch(vx, vy, [1, 0.5, 0])
% plot zonotopes
plot(R_controller)
hold off;
set(gca,'FontSize',22);
yaxis_graph_cont = sprintf('Force in [%d, %d]', min_force, max_force);
xlabel('x_{1} controller','fontsize',20);
ylabel(yaxis_graph_cont,'fontsize',20);
title(title_graph_controller);

figure 
hold on;
n = size((R_plant.timePoint.set),1);
colors = lines(n);
x_min = min_pos ; 
x_max = max_pos ;
y_min = min_speed ; 
y_max = max_speed ;
vx = [x_min, x_max, x_max, x_min, x_min];
vy = [y_min, y_min, y_max, y_max, y_min];
patch(vx, vy, [1, 0.5, 0])
plot(R_plant) % plot zonotopes
hold off;
xaxis_graph_plant = sprintf('Position in [%d, %d]', min_pos, max_pos);
yaxis_graph_plant = sprintf('Speed in [%d, %d]', min_speed, max_speed);
set(gca, 'FontSize', 22);
xlabel(xaxis_graph_plant, 'FontSize', 20);
ylabel(yaxis_graph_plant, 'FontSize', 20);
xlabel(xaxis_graph_plant);
ylabel(yaxis_graph_plant);
title(title_graph_plant);