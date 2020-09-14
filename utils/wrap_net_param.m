function net_param = wrap_net_param(mode, varargin)
% This function calculate and wrap the network parameters as a struct varable.
% input:
%   mode: decide whether to calculate the network's parameter or just wrap up.
%   if mode == 'wrap', three parameters need to be supplied in varargin:
%       m_expect: E{m}
%       mk_expect: E{m/k}
%       mk2_expect: E{m/k^2}
%   else if mode == 'cal', 
%       net: the network's adjacency matrix need to be supplied in varargin.

net_param = struct();
if strcmp(mode, 'wrap')
    if length(varargin) ~= 3
        error("Wrong number of arguements!")
    end
    net_param.m = varargin{1, 1};
    net_param.mk = varargin{1, 2};
    net_param.mk2 = varargin{1, 3};
elseif strcmp(mode, 'cal')
    % Given the raw adjacency matrix of the network, calculate the
    % network's parameter.
    if length(varargin) ~= 1
        error("Wrong number of arguments!")
    end
    net_stat = network_statistic(varargin{1, 1});
    net_param.mk2 = sum(net_stat(3, :) ./ (net_stat(1, :).^2) .* net_stat(2, :));
    net_param.mk = sum(net_stat(3, :)./net_stat(1, :) .* net_stat(2, :));
    net_param.m = sum(net_stat(3, :) .* net_stat(2, :));
else
    error('Unknown mode!')
end