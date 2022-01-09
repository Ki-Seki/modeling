function [S, D] = gen_random_S(D)
% 用于随机生成一份满足约束条件的分配方案
% D 是需求量表

% 储备量
W = [10074	10074	286	41	0	699
14892	14892	152	566	820	667
0	0	376	207	252	179
33951	33951	261	325	585	306
5768	6128	730	421	556	1000
4200	3665	706	723	799	0];

% 分配方案
S = zeros(10, 6, 6);

% 遍历储存量表，进行随机化分配
for i = 1 : 6
    for k = 1 : 6
        for j = 1 : 10  % 为第 j 个受灾点分配物资
            volume = randi([0, W(i, k)], 1);
            while (volume > D(j, k))
                volume = randi([0, W(i, k)], 1);
            end
            S(j, k, i) = S(j, k, i) + volume;
            D(j, k) = D(j, k) - volume;
        end
    end
end

end