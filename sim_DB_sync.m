function [x, result] = sim_DB_sync(pm, net_mat, alph, T, p_ini)
% DB update process in sychronization way. All agents update their strategy
% according to DB update rule at the same time.
% input:
%   pm: wrapped payoff matrix struct, with ucc, ucd, udc, udd.
%   net_mat: adjacency matrix form of the given network.
%   alph: selection intensity.
%   T: the number of iterations.
%   p_ini: 1 * ini_number vector, where each element represent the user
%   index who adopt strategy C at the initial state.
% output:
%   x: N*1 strategy vector w.r.t each user at time T.
%   result: 1*T vector, each entry repr. the ratio who take strategy C.

N = size(net_mat, 1);
% Initialize the strategy vector of each user.
x = zeros(N, 1);
x(p_ini) = 1;

one_vec = ones(N, 1);
% Calculate the fitness of each user.
temp_vec_1 = zeros(N, 1);
temp_vec_2 = zeros(N, 1);

result = zeros(1, T);

for i = 1:T
    is_c_vec = x == 1;
    temp_vec_1(is_c_vec) = alph * (pm.ucc - pm.ucd);
    temp_vec_1(~is_c_vec) = alph * (pm.udc - pm.udd);
    temp_vec_2(is_c_vec) = alph * pm.ucd;
    temp_vec_2(~is_c_vec) = alph * pm.udd;
    fit_vec = one_vec * (1 - alph) + (net_mat * x) .* temp_vec_1 + (net_mat * one_vec) .* temp_vec_2;

    % Calculate the sum fitness of C-neighbors and D-neighbors.
    sum_fit_c = net_mat * (x .* fit_vec);
    sum_fit_d = net_mat * ((one_vec - x) .* fit_vec);
    % Neighbors total fitness.
    sum_fit = sum_fit_c + sum_fit_d;

    x_new = x;
    % Decide whether each C-user change to D
    change_th = (x .* sum_fit_d) ./ sum_fit;
    rand_vec = rand(N, 1);
    x_new(rand_vec <= change_th) = 0;
    % Decide whether each D-user change to C
    change_th = ((one_vec - x) .* sum_fit_c) ./ sum_fit;
    rand_vec = rand(N, 1);
    x_new(rand_vec <= change_th) = 1;
    % Update x
    x = x_new;
    result(i) = sum(x);
end

end
