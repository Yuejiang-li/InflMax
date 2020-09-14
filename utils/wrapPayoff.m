function payoff = wrapPayoff(ucc, ucd, udc, udd)
% wrap the payoff values as a struct var.
% Inputs are four payoff values
    payoff = struct();
    payoff.ucc = ucc;
    payoff.ucd = ucd; 
    payoff.udc = udc;
    payoff.udd = udd;
end
