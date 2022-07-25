% Calculate CO2 Sequestration of a Harvested Wood Product (HWP)
function cds = hwp_cds(d, h)
    % d      Diameter of the trunk in inches
    % h      Height of the tree in feet
    % cds    Weight of CO2 sequestered in the tree in pounds
    
    r_loss = 0.001;
    cds = (1 - r_loss) * tree_cds(d, h);
end