function [strategy_ratio, mean_ratio, strategy_each_iter, debug_info] = sim_DB_sync_ctrl_script_debug(pm, net_mat, alph, T, p_ini, repeat_num, is_zlt, varargin)
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
C2D_times = zeros(N, T);
D2C_times = zeros(N, T);
C2D_th = zeros(N, T);
D2C_th = zeros(N, T);
for i = 1:repeat_num
    if is_zlt
        [strategy_records(:, i), strategy_ratio(:, i), X, th_recs] = sim_DB_sync_with_zlt(pm, net_mat, alph, T, p_ini, is_zlt, zealots);
    else
        [strategy_records(:, i), strategy_ratio(:, i), X, th_recs] = sim_DB_sync_with_zlt(pm, net_mat, alph, T, p_ini, is_zlt);
    end
    strategy_each_iter = strategy_each_iter + X;
    % Calculate the strategy changing of each user at each time step.
    x0 = zeros(N, 1);
    x0(p_ini) = 1;
    X_ori = [x0, X(:, 1:T-1)];  % Shape: N * T
    X_now = X;
    % C2D statistics: x(t) = 1 while x(t+1) = 0.
    % Shape: N * T
    C2D_times = C2D_times + ((X_ori == 1) & (X_now == 0));
    D2C_times = D2C_times + ((X_ori == 0) & (X_now == 1));
    
    % Separate the strategy-C and strategy-D separately.
    % Shape: N * T;
    C2D_temp = zeros(N, T);
    D2C_temp = zeros(N, T);
    C2D_temp(X_ori == 1) = th_recs(X_ori == 1);
    D2C_temp(X_ori == 0) = th_recs(X_ori == 0);
    C2D_th = C2D_th + C2D_temp;
    D2C_th = D2C_th + D2C_temp;
end

% mean_strategy = mean(strategy_records(:, valid_exp_index), 2);
mean_ratio = mean(strategy_ratio, 2);

% Some debugging info.
debug_info = struct;
debug_info.C2D_times = C2D_times;
debug_info.D2C_times = D2C_times;
debug_info.C2D_th = C2D_th;
debug_info.D2C_th = D2C_th;
x0 = zeros(N, 1);
x0(p_ini) = 1;
strategy_ori = [x0 * repeat_num, strategy_each_iter(:, 1:T-1)];
debug_info.C2D_times_ratio = C2D_times ./ strategy_ori;
debug_info.D2C_times_ratio = D2C_times ./ (repeat_num - strategy_ori);
debug_info.C2D_th_ratio = C2D_th ./ strategy_ori;
debug_info.D2C_th_ratio = D2C_th ./ (repeat_num - strategy_ori);
debug_info.C2D_times_ratio = fillna(debug_info.C2D_times_ratio, 0);
debug_info.D2C_times_ratio = fillna(debug_info.D2C_times_ratio, 0);
debug_info.C2D_th_ratio = fillna(debug_info.C2D_th_ratio, 0);
debug_info.D2C_th_ratio = fillna(debug_info.D2C_th_ratio, 0);

end