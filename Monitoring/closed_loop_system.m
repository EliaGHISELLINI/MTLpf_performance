% Spring-mass system with controller and saturation.

% Model from Pierre-Loîc GAROCHE,
% Formal Verification of Control System Software, 
% ISBN: 978-0-691-18130-1

clear; clc;

%% Discretization
% the system is in discrete time, discretized at 100Hz
Ts = 1/100 ; 

%% Plant ODE

Ap = [1 0.01
    -0.01 1];
Bp = [0.00005
    0.01];
Cp = [1 0];

%% Controller ODE

Ac = [0.4990 -0.05
    0.01 1];
Bc = [1
    0];
Cc = [564.48 0];
Dc = -1280;

%% Closed loop ODE

A = [Ac 0*Ac 
    Bp*Cc Ap];
B = [Bc 
    Bp*Dc];
C = [0 0 Cp];

%% Closed loop dynamics - example of an execution
% the dyanamics are in the form:
% x_n = A*x_o + B*SAT(C*x_o - inp);


nb_iterations = 200; % number of timesteps, 1 step = 0.01 seconds
x = zeros(size(A,1),nb_iterations); % initialization state variable 
ref = 1.5 ; % value of the reference at 1
inp = ref * ones(1,nb_iterations); % constant reference signal

% execution for nb_iterations time steps
for k = 1:(nb_iterations-1)
    x(:,k+1) = A*x(:,k) + B*SAT(C*x(:,k) - inp(k));
end

%% plot of the execution

figure
hold on 
plot (x(3,:))
plot (inp)
hold off
title (sprintf('Sample execution of the system, for input %f', inp(1))) ;
xlabel('Time step');
ylabel('Value') ;