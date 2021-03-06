function [mean_strategy, mean_ratio, strategy_ratio, strategy_each_iter] = sim_DB_sync_ctrl_script(pm, net_mat, alph, T, p_ini, repeat_num, is_zlt, varargin)
% Repeating the simulation for `sim_DB_sync`.
% input:
%   pm: wrapped payoff matrix struct, with ucc, ucd, udc, udd.
%   net_mat: adjacency matrix form of the given network.
%   alph: selection intensity.
%   T: the number of iterations.
%   p_ini: 1 * ini_number vector, where each element represent the user
%   repeat_num: how many time the simulations are repeated.
%   is_zlt: a bool var, show that whether this simulation has zealots.
%   if is_zlt is ture, then varargin should contain one element, that is,
%   zealots: the index of zealots. Note that p_ini must contain zealots.
% output:
%   mean_strategy: N * repeat_num matrix, the strategy at T for each simulation run.
%   mean_ratio: T * repeat_num, the mean ratio of strategy C at each time step.

if is_zlt
    zealots = varargin{1, 1};
    if sum(ismember(zealots, p_ini)) ~= length(zealots)
        error("p_ini must contains zealots.")
    end
else
    zealots = [];
end

N = size(net_mat, 1);
strategy_records = zeros(N, repeat_num);
strategy_ratio = zeros(T, repeat_num);
strategy_each_iter = zeros(N, T);
parfor i = 1:repeat_num
    if is_zlt
        [strategy_records(:, i), strategy_ratio(:, i), X] = sim_DB_sync_with_zlt(pm, net_mat, alph, T, p_ini, is_zlt, zealots);
    else
        [strategy_records(:, i), strategy_ratio(:, i), X] = sim_DB_sync_with_zlt(pm, net_mat, alph, T, p_ini, is_zlt);
    end
    strategy_each_iter = strategy_each_iter + X;
end

if is_zlt
    strategy_each_iter = strategy_each_iter / repeat_num;
end

[valid_exp_index, ~] = find_valid_exp(strategy_ratio, 2, round(repeat_num * 0.7), false, N, repeat_num);

mean_strategy = mean(strategy_records(:, valid_exp_index), 2);
mean_ratio = mean(strategy_ratio(:, valid_exp_index), 2);
end