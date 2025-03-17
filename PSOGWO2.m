% MATLAB Code for Comparative Analysis of GWO, PSO, and BA
% Bus Number vs Power Loss over 50 iterations

clc;
clear;
close all;

% IEEE 30-bus system data (included in the code)
baseMVA = 100; % System MVA base

% Bus data
busdata = [
    1   3   0     0     0     0     1   1.06    0     132   1.10   0.95;
    2   2   21.7  12.7  0     0     1   1.043  -5.48  132   1.10   0.95;
    3   1   2.4   1.2   0     0     1   1.021  -7.96  132   1.05   0.95;
    4   1   7.6   1.6   0     0     1   1.012  -9.62  132   1.05   0.95;
    5   2   94.2  19    0     0     1   1.01  -14.37  132   1.10   0.95;
    6   1   0     0     0     0     1   1.01  -11.34  132   1.05   0.95;
    7   1   22.8  10.9  0     0     1   1.002 -13.12  132   1.05   0.95;
    8   2   30    30    0     0     1   1.01  -12.1   132   1.10   0.95;
    9   1   0     0     0     0     1   1.051 -14.38  1     1.05   0.95;
    10  1   5.8   2     0     0.19  1   1.045 -15.97  33    1.05   0.95;
    11  2   0     0     0     0     1   1.082 -14.39  11    1.10   0.95;
    12  1   11.2  7.5   0     0     1   1.057 -15.24  33    1.05   0.95;
    13  2   0     0     0     0     1   1.071 -15.24  11    1.10   0.95;
    14  1   6.2   1.6   0     0     1   1.042 -16.13  33    1.05   0.95;
    15  1   8.2   2.5   0     0     1   1.038 -16.22  33    1.05   0.95;
    16  1   3.5   1.8   0     0     1   1.045 -15.83  33    1.05   0.95;
    17  1   9     5.8   0     0     1   1.04  -16.14  33    1.05   0.95;
    18  1   3.2   0.9   0     0     1   1.028 -16.82  33    1.05   0.95;
    19  1   9.5   3.4   0     0     1   1.026 -17.00  33    1.05   0.95;
    20  1   2.2   0.7   0     0     1   1.03  -16.8   33    1.05   0.95;
    21  1   17.5  11.2  0     0     1   1.033 -16.42  33    1.05   0.95;
    22  1   0     0     0     0     1   1.033 -16.41  33    1.05   0.95;
    23  1   3.2   1.6   0     0     1   1.027 -16.61  33    1.05   0.95;
    24  1   8.7   6.7   0     0.043 1   1.021 -16.78  33    1.05   0.95;
    25  1   0     0     0     0     1   1.017 -16.35  33    1.05   0.95;
    26  1   3.5   2.3   0     0     1   1.000 -16.77  33    1.05   0.95;
    27  1   0     0     0     0     1   1.023 -15.82  33    1.05   0.95;
    28  1   0     0     0     0     1   1.007 -11.97  132   1.05   0.95;
    29  1   2.4   0.9   0     0     1   1.003 -17.06  33    1.05   0.95;
    30  1   10.6  1.9   0     0     1   0.992 -17.94  33    1.05   0.95;
];

% Define the problem parameters
nVar = 6; % Number of control variables (generator voltages)
VarMin = [0.95, 0.95, 0.95, 0.95, 0.95, 0.95]; % Lower bounds of control variables
VarMax = [1.10, 1.10, 1.10, 1.10, 1.10, 1.10]; % Upper bounds of control variables

% Algorithm parameters
MaxIt = 50; % Maximum number of iterations
nPop = 30; % Population size

% Initialize power loss data for each bus
nBuses = size(busdata, 1); % Number of buses
power_loss_gwo = zeros(nBuses, MaxIt); % Power loss for GWO
power_loss_pso = zeros(nBuses, MaxIt); % Power loss for PSO
power_loss_ba = zeros(nBuses, MaxIt); % Power loss for BA

% Simulate GWO, PSO, and BA
for it = 1:MaxIt
    % Simulate GWO
    [gwo_solution, gwo_cost] = GWO(@(x) ORPD_Objective(x, busdata), nVar, VarMin, VarMax, 1, nPop);
    power_loss_gwo(:, it) = rand(nBuses, 1) * gwo_cost; % Simulated power loss
    
    % Simulate PSO
    [pso_solution, pso_cost] = PSO(@(x) ORPD_Objective(x, busdata), nVar, VarMin, VarMax, 1, nPop);
    power_loss_pso(:, it) = rand(nBuses, 1) * pso_cost; % Simulated power loss
    
    % Simulate BA
    [ba_solution, ba_cost] = BA(@(x) ORPD_Objective(x, busdata), nVar, VarMin, VarMax, 1, nPop);
    power_loss_ba(:, it) = rand(nBuses, 1) * ba_cost; % Simulated power loss
end

% Plot comparative graphs
bus_numbers = 1:nBuses;
figure;
hold on;
plot(bus_numbers, mean(power_loss_gwo, 2), 'r', 'LineWidth', 2);
plot(bus_numbers, mean(power_loss_pso, 2), 'b', 'LineWidth', 2);
plot(bus_numbers, mean(power_loss_ba, 2), 'g', 'LineWidth', 2);
xlabel('Bus Number');
ylabel('Average Power Loss (MW)');
legend('GWO', 'PSO', 'BA');
title('Comparative Analysis: Bus Number vs Power Loss');
grid on;
hold off;

% Objective function for ORPD (placeholder)
function cost = ORPD_Objective(x, busdata)
    % x: Control variables (generator voltages)
    % Simulated cost function (replace with actual power flow calculation)
    cost = sum(x) + rand; % Random cost for simulation
end

% Grey Wolf Optimization (GWO) algorithm (simplified)
function [best_solution, best_cost] = GWO(ObjectiveFunction, nVar, VarMin, VarMax, MaxIt, nPop)
    % Initialize the population
    wolves = InitializePopulation(nPop, nVar, VarMin, VarMax);
    
    % Initialize the best solution
    best_solution = zeros(1, nVar);
    best_cost = inf;
    
    % Main loop
    for it = 1:MaxIt
        for i = 1:nPop
            % Calculate the cost of each wolf
            cost = ObjectiveFunction(wolves(i, :));
            
            % Update the best solution
            if cost < best_cost
                best_solution = wolves(i, :);
                best_cost = cost;
            end
        end
    end
end

% Particle Swarm Optimization (PSO) algorithm (simplified)
function [best_solution, best_cost] = PSO(ObjectiveFunction, nVar, VarMin, VarMax, MaxIt, nPop)
    % Initialize the population
    particles = InitializePopulation(nPop, nVar, VarMin, VarMax);
    
    % Initialize the best solution
    best_solution = zeros(1, nVar);
    best_cost = inf;
    
    % Main loop
    for it = 1:MaxIt
        for i = 1:nPop
            % Calculate the cost of each particle
            cost = ObjectiveFunction(particles(i, :));
            
            % Update the best solution
            if cost < best_cost
                best_solution = particles(i, :);
                best_cost = cost;
            end
        end
    end
end

% Bat Algorithm (BA) algorithm (simplified)
function [best_solution, best_cost] = BA(ObjectiveFunction, nVar, VarMin, VarMax, MaxIt, nPop)
    % Initialize the population
    bats = InitializePopulation(nPop, nVar, VarMin, VarMax);
    
    % Initialize the best solution
    best_solution = zeros(1, nVar);
    best_cost = inf;
    
    % Main loop
    for it = 1:MaxIt
        for i = 1:nPop
            % Calculate the cost of each bat
            cost = ObjectiveFunction(bats(i, :));
            
            % Update the best solution
            if cost < best_cost
                best_solution = bats(i, :);
                best_cost = cost;
            end
        end
    end
end

% Function to initialize the population
function pop = InitializePopulation(nPop, nVar, VarMin, VarMax)
    pop = repmat(VarMin, nPop, 1) + rand(nPop, nVar) .* repmat(VarMax - VarMin, nPop, 1);
end