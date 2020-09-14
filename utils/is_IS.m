function flag = is_IS(user_idx, type_start, type_end)
% Judge whether a user is a IS (insusceptible) user based on 8 type scenario.
%   input:
%       user_index: the index of the user.
%       type_start: 1*8 vector, the start index of 8 types.
%       type_end: 1*8 vector, the end index of 8 types.
%   output:
%       flag: a bool variable, show whether the users is an IS user.
%  ========================================================================
flag = ((type_start(2) <= user_idx) && (user_idx <= type_end(2))) || ...
((type_start(4) <= user_idx) && (user_idx <= type_end(4))) || ...
((type_start(6) <= user_idx) && (user_idx <= type_end(6))) || ...
((type_start(8) <= user_idx) && (user_idx <= type_end(8)));
end