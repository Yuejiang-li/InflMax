function [opt_seed_index, opt_spread] = SA_solver(Temp0, Temp_final, k, delta_T, q, simu_param)
% A simulated annealing solver for cooperation maximization problem on
% graph.
% input:
%   Temp0: the initial temperature.
%   Temp_final: the final temperature.
%   k: the seed set size.
%   delta_T: the decrease of temperature in each iteration.
%   q: the inner loop number.
%   simu_param: wrapped parameters for simulation.
% ouput:
%   opt_seed_index: the seed user index list which maximize the
%   cooperation.
%   opt_spread: the maxima of spread of cooperation.
% -------------------------------------------------------------------------

% TODO: Initialize the seed user set with specific heurisitics.
seed_user = randperm(simu_param.N, k);
opt_spread = calculate_spread(simu_param, seed_user);
temperature_count = length(Temp0 : delta_T: Temp_final);
spread_records = zeros(1, temperature_count);
spread_count = 1;
f = figure();

% Outer loop of temperature
for Temp = Temp0 : delta_T: Temp_final
    fprintf("Current Temperature is %.5f\n", Temp)
    for i = 1:q
        % Perturb seed_user
        seed_user_new = perturb_seed_user(seed_user, simu_param.N, k);
        new_spread = calculate_spread(simu_param, seed_user);
        judge_result = judge_anneal(opt_spread - new_spread, Temp);
        if judge_result
            % Adopt new solution
            seed_user = seed_user_new;
            opt_spread = new_spread;
        end
    end
    spread_records(spread_count) = opt_spread;
    clf(f);
    plot(1:spread_count, spread_records(1:spread_count));
    pause(0.01);
    spread_count = spread_count + 1;
end
opt_seed_index = seed_user;
end
