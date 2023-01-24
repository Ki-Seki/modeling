% Logging function: Decide when and which trees to be cut.
% In this case, the oldest fifth of the trees will be cut once five years.
function [cut, uncut] = logging(d, T)
    % d     A distribution of tree's age
    % T     Observing year
    % cut   Distribution of cut tree's age
    % uncut Distribution of uncut tree's age
    
    rotation_period = 5;
    logging_rate = 0.1;
    
    if T == 0
        cut = [];
        uncut = d;
    elseif mod(T, rotation_period) == 0
        d = sort(d);
        cut_num = round(numel(d) * logging_rate);
        
        cut = d(end-cut_num+1 : end);
        uncut = d(1 : end-cut_num);
    else
        cut = [];
        uncut = d;
    end
end