function [x, result, X, th_recs] = sim_DB_sync_with_zlt(pm, net_mat, alph, T, p_ini, is_zlt, varargin)
% DB update process in sychronization way. The chosen intial seed user will
% act as zealot, they do not update their strategy. Other users still use
% DB update rule to update strategy.
% input:
%   pm: wrapped payoff matrix struct, with ucc, ucd, udc, udd.
%   net_mat: adjacency matrix form of the given network.
%   alph: selection intensity.
%   T: the number of iterations.
%   p_ini: 1 * ini_number vector, where each element represent the user
%   index who adopt strategy C at the initial state.
%   is_zlt: whether this simulation contains zealots.
%   if is_zlt is true, then varargin should contain one element, that is,
%   zealots: the zealots' index. Note that p_ini must contain zealots.
% output:
%   x: N * 1 strategy vector w.r.t each user at time T.
%   X: N*T strategy vector w.r.t each user at each time t.
%   result: 1*T vector, each entry repr. the ratio who take strategy C.
%   th_recs: the strategy changing threshold for each user at each time
%   step.

if is_zlt
    zealots = varargin{1, 1};
    if sum(ismember(zealots, p_ini)) ~= length(zealots)
        error("p_ini must contains zealots.")
    end
end

% Shuffle the random seed
rng('shuffle')

N = size(net_mat, 1);
% Initialize the strategy vector of each user.
x = zeros(N, 1);
X = zeros(N, T);
x(p_ini) = 1;

result = zeros(1, T);
th_recs = zeros(N, T);

for i = 1:T
    % If the focal user use strategy-c, then the fitness is
    fit_c = (1 - alph) + alph * net_mat * (pm.ucc * x + pm.ucd * (1 - x));
    fit_d = (1 - alph) + alph * net_mat * (pm.udc * x + pm.udd * (1 - x));
    fit_vec = fit_c .* x + fit_d .* (1 - x);

    % Calculate the sum fitness of C-neighbors and D-neighbors.
    sum_fit_c = net_mat * (x .* fit_vec);
    sum_fit_d = net_mat * ((1 - x) .* fit_vec);
    % Neighbors total fitness.
    sum_fit = sum_fit_c + sum_fit_d;

    x_new = x;
    change_th_recs = zeros(N, 1);
    % Decide whether each C-user change to D
    change_th = (x .* sum_fit_d) ./ sum_fit;
    if is_zlt
        % Zealots should never change their strategy to D, thus th = 0 forever.
        change_th(zealots) = 0;
    end
    rand_vec = rand(N, 1);
    x_new(rand_vec <= change_th) = 0;
    change_th_recs(x == 1) = change_th(x == 1);
    % Decide whether each D-user change to C
    change_th = ((1 - x) .* sum_fit_c) ./ sum_fit;
    rand_vec = rand(N, 1);
    x_new(rand_vec <= change_th) = 1;
    change_th_recs(x == 0) = change_th(x == 0);
    % Update x
    x = x_new;
    result(i) = sum(x);
    X(:, i) = x;
    th_recs(:, i) = change_th_recs;
end

end
