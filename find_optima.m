clear; clc;
% Load net_mat from existing file.
load('networks\scale-free-N1000-k10')
alph = 0.01;
is_zlt = true;
T = 60;
repeat_num = 12;
simu_param = wrap_simu_param(0.4, 0.6, 0.6, 0.9, net_mat, alph, T, repeat_num, is_zlt);
[opt_seed_index, opt_spread, spread_records] = SA_solver(20, 1, 3, -5, 20, simu_param);