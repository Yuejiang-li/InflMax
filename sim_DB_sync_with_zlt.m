function [x, result, X] = sim_DB_sync_with_zlt(pm, net_mat, alph, T, p_ini)
% DB update process in sychronization way. The chosen intial seed user will
% act as zealot, they do not update their strategy. Other users still use
% DB update rule to update strategy.
% input:
%   pm: wrapped payoff matrix struct, with ucc, ucd, udc, udd.
%   net_mat: adjacency matrix form of the given network.
%   alph: selection intensity.
%   T: the number of iterations.
%   p_ini: 1 * ini_number vector, where each element represent the user
%   index who adopt strategy C at the initial state. They are also the
%   zealot user.
% output:
%   x: N * 1 strategy vector w.r.t each user at time T.
%   X: N*T strategy vector w.r.t each user at each time t.
%   result: 1*T vector, each entry repr. the ratio who take strategy C.

% Shuffle the random seed
rng('shuffle')

N = size(net_mat, 1);
% Initialize the strategy vector of each user.
x = zeros(N, 1);
X = zeros(N, T);
x(p_ini) = 1;

one_vec = ones(N, 1);

result = zeros(1, T);

for i = 1:T
    % If the focal user use strategy-c, then the fitness is
    fit_c = (1 - alph) + alph * net_mat * (pm.ucc * x + pm.ucd * (1 - x));
    fit_d = (1 - alph) + alph * net_mat * (pm.udc * x + pm.udd * (1 - x));
    fit_vec = fit_c .* x + fit_d .* (1 - x);

    % Calculate the sum fitness of C-neighbors and D-neighbors.
    sum_fit_c = net_mat * (x .* fit_vec);
    sum_fit_d = net_mat * ((one_vec - x) .* fit_vec);
    % Neighbors total fitness.
    sum_fit = sum_fit_c + sum_fit_d;

    x_new = x;
    % Decide whether each C-user change to D
    change_th = (x .* sum_fit_d) ./ sum_fit;
    % Zealots should never change their strategy to D, thus th = 0 forever.
    change_th(p_ini) = 0;
    rand_vec = rand(N, 1);
    x_new(rand_vec <= change_th) = 0;
    % Decide whether each D-user change to C
    change_th = ((one_vec - x) .* sum_fit_c) ./ sum_fit;
    rand_vec = rand(N, 1);
    x_new(rand_vec <= change_th) = 1;
    % Update x
    x = x_new;
    result(i) = sum(x);
    X(:, i) = x;
end

end
