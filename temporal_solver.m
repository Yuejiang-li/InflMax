function [x, total_result] = temporal_solver(A, alph, p_ini, T, pm, is_zlt)
% This function theoretically calculate the state vector's dynamics.
% input:
%   A: N*N adjacency matrix of the graph.
%   alph: the selection intensity.
%   p_ini: 1 * ini_number vector, where each element represent the user
%   index who adopt strategy C at the initial state.
%   T: the iterations.
%   PM: wrapped payoff matrix.
%   is_zlt: whether the initial users are zealot.
% output:
%   x: N*1 vector. The state at iteration T.
%   total_result: 1 * T vector. The sum of each user's percentage with
%   action C at each time step.
% -------------------------------------------------------------------------

N = size(A, 1);
one_vec = ones(N, 1);
x = zeros(N, 1);
x(p_ini) = 1;
x0 = x;
total_result = zeros(1, T);
for t = 1:T
    Rc = pm.ucc * A * x + pm.ucd * A * (one_vec - x);
    Rd = pm.udc * A * x + pm.udd * A * (one_vec - x);
    Fc = one_vec + alph * Rc;
    Fd = one_vec + alph * Rd;
    Sc = A * (Fc .* x);
    Sd = A * (Fd .* (one_vec - x));
    x = Sc ./ (Sc + Sd);
    if is_zlt
        x = (one_vec - x0) .* x + x0;
    end
    % fprintf("Round %d:\t sum of x: %.4f\n", t, sum(x));  % Logging INFO
    total_result(t) = sum(x);
end

end
