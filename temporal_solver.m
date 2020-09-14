function x = temporal_solver(A, alph, p_ini, T, PM)
% This function theoretically calculate the state vector's dynamics.
% input:
%   A: N*N adjacency matrix of the graph.
%   alph: the selection intensity.
%   p_ini: 1 * ini_number vector, where each element represent the user
%   index who adopt strategy C at the initial state.
%   T: the iterations.
%   PM: wrapped payoff matrix.
% output:
%   x: N*1 vector. The state at iteration T.
% -------------------------------------------------------------------------

N = size(A, 1);
one_vec = ones(N, 1);
x = zeros(N, 1);
x(p_ini) = 1;
for t = 1:T
    Rc = PM.ucc * A * x + PM.ucd * A * (one_vec - x);
    Rd = PM.udc * A * x + PM.udd * A * (one_vec - x);
    Fc = one_vec + alph * Rc;
    Fd = one_vec + alph * Rd;
    Sc = A * (Fc .* x);
    Sd = A * (Fd .* (one_vec - x));
    x = Sc ./ (Sc + Sd) ;
    % fprintf("Round %d:\t sum of x: %.4f\n", t, sum(x));  % Logging INFO
end

end
