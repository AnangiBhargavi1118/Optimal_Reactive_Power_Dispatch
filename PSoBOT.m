clc;
clear;
close all;

%% system MVA base
baseMVA = 100;

%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
bus_data = [
	1	3	0       0       0	0	1	1	0	135     1	1.10 	0.95;
	2	2	21.7	12.7	0	0	1	1	0	135     1	1.10    0.95;
	3	1	2.4     1.2     0	0	1	1	0	135     1	1.05	0.95;
	4	1	7.6     1.6     0	0	1	1	0	135     1	1.05	0.95;
	5	2	94.2    19      0	0	1	1	0	135     1	1.10	0.95;
	6	1	0       0       0   0	1	1	0	135     1	1.05	0.95;
	7	1	22.8	10.9	0	0	1	1	0	135     1	1.05	0.95;
	8	2	30      30      0	0	1	1	0	135     1	1.10	0.95;
	9	1	0       0       0	0	1	1	0	135     1	1.05	0.95;
	10	1	5.8     2       0	0	3	1	0	135     1	1.05	0.95;
	11	2	0       0       0	0	1	1	0	135     1	1.10	0.95;
	12	1	11.2	7.5     0	0	2	1	0	135     1	1.05	0.95;
	13	2	0       0       0	0	2	1	0	135     1	1.10    0.95;
	14	1	6.2     1.6     0	0	2	1	0	135     1	1.05	0.95;
	15	1	8.2     2.5     0	0	2	1	0	135     1	1.05	0.95;
	16	1	3.5     1.8     0	0	2	1	0	135     1	1.05	0.95;
	17	1	9       5.8     0	0	2	1	0	135     1	1.05	0.95;
	18	1	3.2     0.9     0	0	2	1	0	135     1	1.05	0.95;
	19	1	9.5     3.4     0	0	2	1	0	135     1	1.05	0.95;
	20	1	2.2     0.7     0	0	2	1	0	135     1	1.05	0.95;
	21	1	17.5	11.2	0	0	3	1	0	135     1	1.05	0.95;
	22	1	0       0       0	0	3	1	0	135     1	1.05    0.95;
	23	1	3.2     1.6     0	0	2	1	0	135     1	1.05     0.95;
	24	1	8.7     6.7     0	0	3	1	0	135     1	1.05	0.95;
	25	1	0       0       0	0	3	1	0	135     1	1.05	0.95;
	26	1	3.5     2.3     0	0	3	1	0	135     1	1.05	0.95;
	27	1	0       0       0	0	3	1	0	135     1	1.05    0.95;
	28	1	0       0       0	0	1	1	0	135     1	1.05	0.95;
	29	1	2.4     0.9     0	0	3	1	0	135     1	1.05	0.95;
	30	1	10.6	1.9     0	0	3	1	0	135     1	1.05	0.95;
];

%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf
branch_data = [
	1    99.211     -3.99	150.0	-20     1.0     100	1	200	50 0 0 0 0 0 0 0 0 0 0;
	2    80.00      50.0	60.0    -20     1.0     100	1	80	20 0 0 0 0 0 0 0 0 0 0;
	5    50.00      37.0	62.5   	-15 	1.0     100	1	50	15 0 0 0 0 0 0 0 0 0 0;
	8    20.00      37.3	48.7   	-15 	1.0 	100	1	35	10 0 0 0 0 0 0 0 0 0 0;
	11   20.00      16.2 	40.0    -10 	1.0     100	1	30	10 0 0 0 0 0 0 0 0 0 0;
	13   20.00      10.6	44.7  	-15 	1.0     100	1	40	12 0 0 0 0 0 0 0 0 0 0;
];

%% branch data
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
branch_data = [
1	2	0.0192	0.0575	0.0264	130	130	130	0	0	1	-360	360;
1	3	0.0452	0.1852	0.0204	130	130	130	0	0	1	-360	360;
2	4	0.0570	0.1737	0.0184	65	65	65	0	0	1	-360	360;
3	4	0.0132	0.0379	0.0042	130	130	130	0	0	1	-360	360;
2	5	0.0472	0.1983	0.0209	130	130	130	0	0	1	-360	360;
2	6	0.0581	0.1763	0.0187	65	65	65	0	0	1	-360	360;
4	6	0.0119	0.0414	0.0045	90	90	90	0	0	1	-360	360;
5	7	0.0460	0.116	0.0102	70	70	70	0	0	1	-360	360;
6	7	0.0267	0.082	0.0085	130	130	130	0	0	1	-360	360;
6	8	0.0120	0.042	0.0045	32	32	32	0	0	1	-360	360;
6	9	0.00	0.208	0.00	65	65	65	0	0	1	-360	360;
6	10	0.00	0.556	0.00	32	32	32	0	0	1	-360	360;
9	11	0.00	0.208	0.00	65	65	65	0	0	1	-360	360;
9	10	0.00	0.110	0.00	65	65	65	0	0	1	-360	360;
4	12	0.00	0.256	0.00	65	65	65	0	0	1	-360	360;
12	13	0.00	0.140	0.00	65	65	65	0	0	1	-360	360;
12	14	0.1231	0.2559	0.00	32	32	32	0	0	1	-360	360;
12	15	0.0662	0.1304	0.00	32	32	32	0	0	1	-360	360;
12	16	0.0945	0.1987	0.00	32	32	32	0	0	1	-360	360;
14	15	0.2210	0.1997	0.00	16	16	16	0	0	1	-360	360;
16	17	0.0824	0.1932	0.00	16	16	16	0	0	1	-360	360;
15	18	0.1070	0.2185	0.00	16	16	16	0	0	1	-360	360;
18	19	0.0639	0.1292	0.00	16	16	16	0	0	1	-360	360;
19	20	0.0340	0.0680	0.00	32	32	32	0	0	1	-360	360;
10	20	0.0936	0.2090	0.00	32	32	32	0	0	1	-360	360;
10	17	0.0324	0.0845	0.00	32	32	32	0	0	1	-360	360;
10	21	0.0348	0.0749	0.00	32	32	32	0	0	1	-360	360;
10	22	0.0727	0.1499	0.00	32	32	32	0	0	1	-360	360;
21	22	0.0116	0.0236	0.00	32	32	32	0	0	1	-360	360;
15	23	0.100	0.2020	0.00	16	16	16	0	0	1	-360	360;
22	24	0.115	0.179	0.00	16	16	16	0	0	1	-360	360;
23	24	0.132	0.270	0.00	16	16	16	0	0	1	-360	360;
24	25	0.1885	0.3292	0.00	16	16	16	0	0	1	-360	360;
25	26	0.2544	0.380	0.00	16	16	16	0	0	1	-360	360;
25	27	0.1093	0.2087	0.00	16	16	16	0	0	1	-360	360;
28	27	0.00	0.396	0.00	65	65	65	0	0	1	-360	360;
27	29	0.2198	0.4153	0.00	16	16	16	0	0	1	-360	360;
27	30	0.3202	0.6027	0.00	16	16	16	0	0	1	-360	360;
29	30	0.2399	0.4533	0.00	16	16	16	0	0	1	-360	360;
8	28	0.0636	0.200	0.0214	32	32	32	0	0	1	-360	360;
6	28	0.0169	0.0599	0.0065	32	32	32	0	0	1	-360	360;
];

%%-----  OPF Data  -----%%
%% generator cost data
%	1	startup	shutdown	n	x1	y1	...	xn	yn
%	2	startup	shutdown	n	c(n-1)	...	c0
gen_data = [
	2	0	0	3	0.0     2.00	0.00375;
	2	0	0	3	0.0     1.75	0.0175;
	2	0	0	3	0.0     1.00	0.0625;
	2	0	0	3	0.0     3.25	0.00834;
	2	0	0	3	0.0     3.00	0.025;
	2	0	0	3	0.0 	3.00	0.025;
];
%% Optimization Settings
num_particles = 30;
num_iterations = 100;

%% Run Optimization Algorithms
[pso_best, pso_convergence] = PSO_Optimization(bus_data, branch_data, gen_data, num_particles, num_iterations);
[psogwo_best, psogwo_convergence] = PSOGWO_Optimization(bus_data, branch_data, gen_data, num_particles, num_iterations);
[psoboa_best, psoboa_convergence] = PSOBOA_Optimization(bus_data, branch_data, gen_data, num_particles, num_iterations);

%% Convergence Plot
figure;
plot(pso_convergence, 'r', 'LineWidth', 2); hold on;
plot(psogwo_convergence, 'g', 'LineWidth', 2);
plot(psoboa_convergence, 'b', 'LineWidth', 2);
legend('PSO', 'PSOGWO', 'PSOBOA');
xlabel('Iterations'); ylabel('Power Loss');
title('Convergence Plot');
grid on;

%% Power Loss Comparison Plot
figure;
bars = bar([pso_best, psogwo_best, psoboa_best]);
set(gca, 'xticklabel', {'PSO', 'PSOGWO', 'PSOBOA'});
ylabel('Power Loss (MW)');
title('Power Loss Comparison');
grid on;

%% Results Table
results = table({'PSO'; 'PSOGWO'; 'PSOBOA'}, [pso_best; psogwo_best; psoboa_best], ...
    'VariableNames', {'Algorithm', 'Best Power Loss'});
disp(results);

%% Functions for Optimization (Define PSO, PSOGWO, PSOBOA)
function [best_solution, convergence] = PSO_Optimization(bus_data, branch_data, gen_data, num_particles, num_iterations)
    % PSO Algorithm for Power Loss Optimization
    best_solution = rand() * 100; % Placeholder calculation
    convergence = linspace(100, best_solution, num_iterations);
end

function [best_solution, convergence] = PSOGWO_Optimization(bus_data, branch_data, gen_data, num_particles, num_iterations)
    % PSOGWO Algorithm for Power Loss Optimization
    best_solution = rand() * 100; % Placeholder calculation
    convergence = linspace(100, best_solution, num_iterations);
end

function [best_solution, convergence] = PSOBOA_Optimization(bus_data, branch_data, gen_data, num_particles, num_iterations)
    % PSOBOA Algorithm for Power Loss Optimization
    best_solution = rand() * 100; % Placeholder calculation
    convergence = linspace(100, best_solution, num_iterations);
end
