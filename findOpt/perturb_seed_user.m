function perturbed_seed_users = perturb_seed_user(seed_users, N, k)
% Perturb the choices of each node.
% input:
%   seed_users: the choices of the current user set.
%   N: the total of users
%   k: the size of seed user set.
% output:
%   perturbed_seed_users: the perturbed seed users.
% -------------------------------------------------------------------------
new_seeds = randperm(N, k);
rands = rand(1, k);
perturbed_seed_users = zeros(1, k);
update_index = rands > 0.5;
perturbed_seed_users(~update_index) = seed_users(~update_index);
perturbed_seed_users(update_index) = new_seeds(update_index);
end

