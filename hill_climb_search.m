function seed_user_index = hill_climb_search(k, net_mat, pm, alph, T, is_zlt)
% This function finds the intial users that can "maiximize" the spread a
% certain strategy with hill climbing greedy search method.
% The basic idea is the same as introduced in "Maximizing the spread of
% influence through a social network".
% input:
%   k: the number of the seed user set.
%   net_mat: the network structure.
%   pm: the wrapped payoff matrix.
%   alph: the selection intensity.
%   T: the iterations.
%   is_zlt: whether the initial users are zealot.
% output:
%   seed_user_index: the result intial users given by this greedy method.
N = size(net_mat, 2);

% Indicate whether the user is selected as seed users.
seed_user_index = [];

for num_seed_user = 1:k
    ess_result = zeros(1, N);
    fprintf("Finding the No.%d nodes\n", num_seed_user);
    parfor sel_node = 1:N
        % Going through each selection can be down in a parallel mannar.
        % Inner loop: find the node which haven't been chosen and can
        % maximize the marginal gain.
        if ~ismember(sel_node, seed_user_index)
            % This node haven't been chosen yet.
            p_ini = [seed_user_index, sel_node];
            % Obtain the result
            if is_zlt
                zealots = p_ini;
                [~, total_result] = temporal_solver(net_mat, alph, p_ini, T, pm, is_zlt, zealots);
            else
                [~, total_result] = temporal_solver(net_mat, alph, p_ini, T, pm, is_zlt);
            end
            theo_dyn = sum(total_result);
            ess_result(sel_node) = mean(theo_dyn(end - 50:end));
        else
            ess_result(sel_node) = 0;
        end
        % Logging Info.
        if mod(sel_node, 100) == 0
            fprintf("Trying node #%d\n", sel_node);
        end
    end
    [~, node_idx] = max(ess_result);
    seed_user_index = [seed_user_index, node_idx];
end
end