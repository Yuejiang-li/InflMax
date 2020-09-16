function [spread, strategy_ratio] = calculate_spread(simu_param, seed_users)
% This function calculate the expected spread given the simulation
% parameters and seed users.
% input:
%   simu_param: the wrapped simulation parameters.
%   seed_users: the index of selected seed users.
% output:
%   spread: the spread of cooperation action.
% -------------------------------------------------------------------------
[~, mean_ratio, strategy_ratio] = sim_DB_sync_ctrl_script(simu_param.pm, simu_param.net_mat, simu_param.alph, simu_param.T, seed_users, simu_param.repeat_num, simu_param.is_zlt);
spread = mean(mean_ratio(end-50:end));
end
