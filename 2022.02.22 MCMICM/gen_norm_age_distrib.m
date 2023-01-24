function distrib = gen_norm_age_distrib(youngest, oldest, n)
    distrib = randn(1, n);
    m = min(distrib);
    M = max(distrib);
    
    % Interval transformation: [m, M] → [youngest, oldest]
    distrib = (oldest-youngest)/(M-m)*(distrib-m) + youngest;
    
    % Change fractions to integers
    distrib = round(distrib);
end