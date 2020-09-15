function judge_result = judge_anneal(dE, temperature)
% This function judge whether annealing is needed in this iteration.
% Note the here we focus on the maximization problem, thus the adoption
% only happens when
% (1) dE < 0, i.e., y_ori < y_new; or
% (2) dE > 0, but random result forcing adopt new solution.
% input:
%   dE: the gap between original solution and new solution (y_ori - y_new).
%   temperature: the temperature in current iteration.
% output:
%   judge_result: a bool variable, showing whether annealing is adopted
%   (adopt the new solution).
%--------------------------------------------------------------------------
if(dE < 0)
    judge_result = true;
else
    d = exp(-(dE / temperature));
    if(d > rand)
        judge_result = true;
    else
        judge_result = false;
    end
end
end

