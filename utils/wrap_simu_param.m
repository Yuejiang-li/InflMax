function simu_param = wrap_simu_param(ucc, ucd, udc, udd, net_mat, alph, T, repeat_num, is_zlt)
% Wrap up the parameters for simulation
% input:
%   ucc, ucd, udc, udd: the payoff values of the game.
%   net_mat: adjacency matrix form of the given network.
%   alph: selection intensity.
%   T: the iteration time.
%   repeat_num: how many times of repeatance.
%   is_zlt: whether the seed nodes are zealot.
% output:
%   simu_param: the wrapped simulation parameter struct.
% -------------------------------------------------------------------------
simu_param = struct();
simu_param.pm = wrapPayoff(ucc, ucd, udc, udd);
simu_param.net_mat = net_mat;
simu_param.N = size(net_mat, 1);
simu_param.alph = alph;
simu_param.T = T;
simu_param.repeat_num = repeat_num;
simu_param.is_zlt = is_zlt;
end

