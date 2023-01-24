% 求解问题一的主程序文件

clear;
clc;
close all;

%% 输入参数设置
unit_demand = [6, 3, 0.25, 1, 0.998, 2];  % 根据论文和经验所设置的每人的单位物资需求量 依次是饮用水,食品,帐篷,棉被,绷带,药品
injury_rate = 6/100;  % 伤员比例
homeless_rate = 30/100;  % 无家可归人员比例
n = 10000;  % 运行次数
rand_type = 'state';  % 随机数生成器类型
coeffT = 2;  % 运输时间系数

%% 蒙特卡洛算法
D = cal_demand(unit_demand, injury_rate, homeless_rate);  % 计算需求量详情
minI = 1;  % 最小成本对应的下标
allC = zeros(1, n);  % 每次的对应成本
for i = 1 : n
    rand(rand_type, i);  % 设置随机数种子
    S = gen_random_S(D);  % 获取分配方案，及分配后未满足量
    allC(i) = cal_cost(S, D, coeffT);
    if allC(i) < allC(minI)
        minI = i;
    end
end

%% 结果获取
rand(rand_type, minI);  % 重获最优方案的种子
[S, U] = gen_random_S(D);
[C, TC, PC1, PC2] = cal_cost(S, D, coeffT);
plot(allC,'DisplayName','allC','YDataSource','allC');figure(gcf);