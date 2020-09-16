function [valid_exp_index, invalid_exp_index] = find_valid_exp(records, dir, valid_exp_num_th, is_unified, N, repeat_num)
% Find the valid simulation experiments index in the given simulation
% records.
% input:
%   records: an N * M matrix recording the simulation results.
%   dir: an experiment series is arranged along which axis. 1 means along
%   row-axis, 2 means along column-axis.
%   valid_exp_num_th: the threshold of tolerated #simulations that reach extreme (0, 1).
%   is_unified: whether the records are unified to 1.
%   N: total number of user.
%   repeat_num: the number of repeated simulation times.
% output:
%   valid_exp_index: 1 * x vector, the valid experiments index.
%   invalid_exp_index: 1 * x vector, the invalid experiments index.
% -------------------------------------------------------------------------

% Try exclude extreme simulation run (converge to 0 and 1).
valid_exp_index = [];
invalid_exp_index =[];
for i = 1:repeat_num
    if dir == 1
        if is_unified
            find_max = find(records(i, :)==1, 1);
        else
            find_max = find(records(i, :)==N, 1);
        end
        find_min = find(records(i, :)==0, 1);
    else
        if is_unified
            find_max = find(records(:, i)==1, 1);
        else
            find_max = find(records(:, i)==N, 1);
        end
        find_min = find(records(:, i)==0, 1);
    end
    if (isempty(find_max))&&(isempty(find_min))
        valid_exp_index = [valid_exp_index, i];
    else
        invalid_exp_index = [invalid_exp_index, i];
    end
end

if length(valid_exp_index) <= valid_exp_num_th
    gap = valid_exp_num_th - length(valid_exp_index);
    valid_exp_index = [valid_exp_index, invalid_exp_index(1:gap)];
end
end

