% 问题二求解器
% 此求解器分为两个部分，分别求最佳伸缩量，保存在变量 answer_delta_s 中；和调节后主索节点坐标值，保存在变量 answer_new_coord 中
% 此求解调用自定义函数：cal_new_coord

clear; clc; close all;

%% 求解出每个主索节点对应的促动器的最佳伸缩量；并画出前 6 个主索节点求解时的图像

focus = [-26.302,-19.673,-156.796];  % 焦点坐标
coeff = [46.014, 34.416, 274.306, 123442.94066];  % 准线平面方程的各系数
[data1,txt] = xlsread('附件1.csv');  % 主索节点坐标 和 主索节点的对应编号
txt(1, :) = [];  % 删除首行，即表头
txt(:, 2:4) = [];  % 删除 2 到 4 列
data2 = xlsread('附件2.csv');
data2 = data2(:,4:6);  % 促动器基准态时上端点坐标

cnt = size(data1, 1);  % 主索节点个数
answer_delta_s = zeros(cnt, 1);  % 所有主索节点对应的促动器的最佳 Δs

for i = 1 : cnt  % 对于每一个主索节点：
    min_d = inf;  % 最小距离差
    % 原始的主索节点坐标值
    old_x = data1(i, 1);
    old_y = data1(i, 2);
    old_z = data1(i, 3);
    
    % 绘制子图相关代码
    if i <= 6
        subplot(2, 3, i);
    end
    
    for delta_s = -0.6 : 0.001 : 0.6  % 对于所有的 Δs
        % 计算伸缩后主索节点坐标
        [new_x, new_y, new_z] = cal_new_coord(old_x, old_y, old_z, delta_s);
        % 计算主索节点坐标到焦点坐标距离 h1
        h1 = ((focus(1)-new_x)^2 + (focus(2)-new_y)^2 + (focus(3)-new_z)^2) ^ 0.5;
        % 计算主索节点坐标到准线平面距离 h2
        tmp1 = abs(coeff(1)*new_x + coeff(2)*new_y + coeff(3)*new_z + coeff(4));
        tmp2 = (coeff(1)^2 + coeff(2)^2 + coeff(3)^2) ^ 0.5;
        h2 = tmp1 / tmp2;
        % 计算距离差的绝对值 d
        d = abs(h1 - h2);
        % 判断是否更小
        if d < min_d
            min_d = d;
            answer_delta_s(i) = delta_s;
        end
        
        % 绘制前 6 张图
        if i <= 6
            plot(delta_s, d, '.');
            hold on;
        end
    end
    
    % 绘制图像的说明信息
    if i <= 6
        title(['主索节点 ',cell2mat(txt(i)),' 求解过程图']);
        xlabel('促动器伸缩量 Δs');
        ylabel('距离差的绝对值 d = |h2 - h1|');
        hold off;
    end
    
    disp(min_d);  % 查看每一个最小距离差
end
disp(answer_delta_s);

%% 求解出主索节点变换后的坐标值 (x', y', z')

answer_new_coord = zeros(cnt, 3);  % 主索节点变换后的坐标值 (x', y', z')
for i = 1 : cnt
    old_x = data1(i, 1);
    old_y = data1(i, 2);
    old_z = data1(i, 3);
    [new_x, new_y, new_z] = cal_new_coord(old_x, old_y, old_z, answer_delta_s(i));
    answer_new_coord(i, 1) = new_x;
    answer_new_coord(i, 2) = new_y;
    answer_new_coord(i, 3) = new_z;
end
disp(answer_new_coord);