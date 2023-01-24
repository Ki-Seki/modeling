% Planting function: Decide when and how many trees to be planted.
% In this case, new saplings will be planted in the first year 
% after the rotation. The number of trees planted is the same as 
% the number of trees cut down
function planted = planting(d, T)
    % d         A distribution of tree's age
    % T         Observing year
    % planted   Distribution of planted tree's age
    
    years_before = 1;
    cut = logging(d, T-years_before);
    cnt = numel(cut);
    
    sapling_age = 10;
    
    if cnt ~= 0
        planted = ones(1, cnt) * sapling_age;
    else
        planted = [];
    end
end