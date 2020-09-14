function net_stat = network_statistic(net)
% This method calculate the statistics of a network.
% input:
%   net: the adjacency matrix of the network.
% output:
%   netStat: 3 * degree_range matrix, where degree_range = max(degree) - min(degree)
%            and the 1st row is degree, 2st row is degree frequency, 3rd
%            row is average degree of neighbors frequency.
% -------------------------------------------------------------------------
    N = size(net, 1);
    degree_table = sum(net); % the degree table of all node
    
    min_deg = min(degree_table);  % minimum and maximum degree
    max_deg = max(degree_table);
    deg_range = max_deg - min_deg + 1;
    degree_idx = min_deg : max_deg;  % index table for degree
    
    deg_fre = zeros(1, deg_range);  % frequency of each degree
    for i = degree_table
        deg_fre(i - min_deg + 1) = deg_fre(i- min_deg + 1) + 1;
    end
    deg_fre = deg_fre / N;
    
    joint_deg_dist = zeros(deg_range, deg_range);  % joint degree distribution
    for i = 1:N
        for j = i+1:N
            if net(i, j) == 1
                joint_deg_dist(degree_table(i)- min_deg + 1, degree_table(j)- min_deg + 1) = ...
                    joint_deg_dist(degree_table(i)- min_deg + 1, degree_table(j)- min_deg + 1) + 1;
                joint_deg_dist(degree_table(j)- min_deg + 1, degree_table(i)- min_deg + 1) = ...
                    joint_deg_dist(degree_table(j)- min_deg + 1, degree_table(i)- min_deg + 1) + 1;
            end
        end
    end
    
    % neighbors' average degree when center degree is k
    marginal_dist = sum(joint_deg_dist, 2);
    conditional_dist = joint_deg_dist ./ marginal_dist;
    
    % calculate the average degree of neighbors w.r.t different degree
    neighAvrDeg = (sum(conditional_dist .* degree_idx, 2))';
    net_stat = [degree_idx; deg_fre; neighAvrDeg];
    net_stat(isnan(net_stat)) = 0; 
end