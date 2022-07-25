% Growth function: Calculate a tree's DBH (in inches) and
% its height (in feet). 
function [d, h] = growth_fun(t)
    % t         Tree's age
    % d         Tree's diameter at breast height (DBH)
    % h         Tree's
    
    lifespan = 1000;  % Lifespan of the tree
    
    % Functions below are fitted with GeoGebra Calculator.
    % They are both logistics function.
    if t <= 100
        d = 36 / (1 + 1.2 ^ (-(t-30)));
        h = 148 / (1 + 1.1 ^ (-(t-45)));
    else
        d = 36 / (1 + 1.2 ^ (-(170-t)));
        h = 148 / (1 + 1.1 ^ (-(155-t)));
    end
    
    
end