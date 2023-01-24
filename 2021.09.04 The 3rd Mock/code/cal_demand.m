function demand = cal_demand(unit_demand, injury_rate, homeless_rate)
% 计算单位需求量下的详细需求量信息
total = [3418,3521,2212,98,1655,2122,1352,986,4109,2150];  % 各受灾点总人数
injury = round(total * injury_rate);  % 各受灾点总受伤人数
homeless = round(total * homeless_rate);  % 各受灾点无家可归人数
demand = ones(6, 10);  % 6 种物资各受灾点的需求量
tmp = [total; total; homeless; homeless; injury; injury];
for i = 1 : 6
    demand(i, :) = round(tmp(i, :) * unit_demand(i));  % 第 i 个物资各地区需求量
end
demand = demand';
end