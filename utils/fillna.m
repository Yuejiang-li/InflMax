function obj_mat = fillna(obj_mat, fill_num)
% Given a matrix, fill the nan with a specific number.
% input:
%   obj_mat: the objective matrix to be filled.
%   fill_num: the number to replace in nan.
% output:
%   obj_mat: the filled matrix.
obj_mat(isnan(obj_mat)) = fill_num;
end

