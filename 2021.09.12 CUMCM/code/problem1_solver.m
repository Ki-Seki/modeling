% 问题一求解器 
% 基于模拟退火算法求理想抛物线，该求解器会算出抛物线方程的两个参数 f 和 h
% 此求解器调用自定义函数：cal_delta_l

clear;
clc;
close all;

% 模拟退火参数
rand_type = 'state';  % 随机生成器类型
rand_seed = 1;  % 随机数种子
begin_t = 90;  % 初始温度
end_t = 89.9;  % 结束温度
a = 0.99;  % 温度下降比例
times = 3000;  % 退火次数

% 固定常数
R = 300;
F = 0.466 * R;
 
% 生成初始解
f = 139.2;
h = F - f;
curr_f = f;
curr_h = h;
best_f = f;
best_h = h;

curr_e = inf;  % 当前热量
best_e = inf;  % 最低热量
best_occured_time = 0;  % 最优解出现在第几次

rand(rand_type, 1);  % 随机数种子

while begin_t >= end_t  % 结束条件
    for i = 1 : times  % 退火次数
        
        % 产生新解
        f = 139.2 + rand * 1.2;
        h = F - f;
        
        % 若不满足约束条件，生成一组必定满足条件的
        if ~(139.2<=f && f<=140.4 && -0.6<=h && h<=0.6 && f + h == F)
            f = 139.2 + rand * 1.2;
            h = F - f;
        end
        
        % 退火
        new_e = 0.5 * cal_delta_l(f, h);  % 目标函数
        if new_e < curr_e  % 接受准则
            curr_e = new_e;
            curr_f = f;
            curr_h = h;
            if new_e < best_e  % 保存冷却过程中最好的解
                best_e = new_e;
                best_f = f;
                best_h = h;
                best_occured_time = i;
            end
        else
            if rand < exp(-(new_e-curr_e)/begin_t)  % 代价函数差
                curr_e = new_e;
                curr_f = f;
                curr_h = h;
            else
                f = curr_f;
                h = curr_h;
            end
        end
        plot(i, best_e, '.');
        hold on;
    end
    begin_t = begin_t * a;  % 降温
end

disp('最优解 f 和 h 分别为：')
disp(best_f)
disp(best_h)
disp('目标表达式的最小值等于：')
disp(best_e)
disp('最小值出现的位置：')
disp(best_occured_time)