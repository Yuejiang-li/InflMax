function [u1, u2, b] = initial_u_b(pm1, pm2, b, alph)
% Intialize payoff values and baselien fitness.
% For each payoff value we multiply it by alph; while for baseline fitness we mutliply it by (1 - alph).
% input:
%   pm1: a struct. the payoff matrix 1.
%   pm2: a struct. the payoff matrix 2.
%   b: 1 * 2 vector. baseline value.
%   alph: selection intensity.
% output:
%   u1: payoff matrix 1, alph*[uff1, ufn1, unf1, unn1];
%   u2: payoff matrix 2, alph*[uff2, ufn2, unf2, unn2];
%   b: baseline fitness (1 - alph)*[b1, b2];
% =========================================================================
u1 = [pm1.uff * alph, pm1.ufn * alph, pm1.unf * alph, pm1.unn * alph];
u2 = [pm2.uff * alph, pm2.ufn * alph, pm2.unf * alph, pm2.unn * alph];
b = b * (1 - alph);
end