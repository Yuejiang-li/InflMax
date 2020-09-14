function sf_graph = create_sf_graph(N, k)
% A naive way to build scale-free network with average degree = k
% input:
%   N: total vertex number.
seed = seed_produce(k+1);
sf_graph = sf_gen(N, k/2, seed);
end