function [x, total_result] = temporal_solver(A, alph, p_ini, T, pm, is_zlt, varargin)
% This function theoretically calculate the state vector's dynamics.
% input:
%   A: N*N adjacency matrix of the graph.
%   alph: the selection intensity.
%   p_ini: 1 * ini_number vector, where each element represent the user
%   index who adopt strategy C at the initial state.
%   T: the iterations.
%   PM: wrapped payoff matrix.
%   is_zlt: whether the initial users are zealot.
%   if is_zlt is ture, then varargin should contain one element, that is,
%   zealots: the index of zealots. Note that p_ini must contain zealots.
% output:
%   x: N*1 vector. The state at iteration T.
%   total_result: N * T vector. Each user's percentage with
%   action C at each time step.
% -------------------------------------------------------------------------

if is_zlt
    zealots = varargin{1, 1};
end
if sum(ismember(zealots, p_ini)) ~= length(zealots)
    error("p_ini must contains zealots.")
end

N = size(A, 1);
one_vec = ones(N, 1);
x = zeros(N, 1);
x(p_ini) = 1;
total_result = zeros(N, T);
for t = 1:T
    Rc = pm.ucc * A * x + pm.ucd * A * (one_vec - x);
    Rd = pm.udc * A * x + pm.udd * A * (one_vec - x);
    Fc = one_vec * (1 - alph) + alph * Rc;
    Fd = one_vec * (1 - alph) + alph * Rd;
    Sc = A * (Fc .* x);
    Sd = A * (Fd .* (one_vec - x));
    x = Sc ./ (Sc + Sd);
    if is_zlt
        x(zealots) = 1;
    end
    % fprintf("Round %d:\t sum of x: %.4f\n", t, sum(x));  % Logging INFO
    total_result(:, t) = x;
end

end
