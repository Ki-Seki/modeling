% Calculate CO2 Sequestration of a tree
function cds = tree_cds(d, h)
    % d     Diameter of the trunk in inches
    % h     Height of the tree in feet
    % cds   Weight of CO2 sequestered in the tree in pounds
    
    % Step 1: Calculate the above-ground weight
    if d < 11
        w1 = 0.25 * d^2 * h;
    else
        w1 = 0.15 * d^2 * h;
    end
        
    % Step 2: Calculate the total weight
    w2 = 1.2 * w1;
    
    % Step 3: Calculate the dry weight
    w3 = 0.725 * w2;
    
    % Step 4: Calculate the C Sequestration
    cs = 0.5 * w3;
    
    % Step 5: Calculate the CO2 Sequestration
    cds = 3.6663 * cs;
end