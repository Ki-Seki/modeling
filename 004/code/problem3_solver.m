% 问题三求解器
% 此求解器包括两个部分，分别求调节后馈源舱接收比和基准球面馈源舱接收比
% 此求解器调用以下自定义函数：
% get_centres
% is_in_illumination
% is_received

clear; clc; close all;

%% 求解调节后馈源舱接收比

% 需要设置的参数，允许误差 ε
epsilon = 1.2;
theta = 56.41366;

% 获取所有三角形反射面板的总量 及 中心点坐标
[cnt, centres] = get_centres();

total = 0;  % 照明区域内反射面板的总数量
valid = 0;  % 照明区域内成功将信号反射到馈源舱内的反射面板的总数量
for i = 1 : cnt
    if is_in_illumination(centres(i, :), theta)  % 如果在照明区域内
        total = total + 1;
        if is_received(centres(i), epsilon)  % 如果成功反射信号到馈源舱
            valid = valid + 1;
        end
    end
end

disp('调节后馈源舱接收比')
fprintf('%f%%\n', valid / total * 100);

%% 求解基准球面馈源舱接收比

% 常量
boundary = [-200.081, 93.546];

total = 0;  % 照明区域内反射面板的总数量
valid = 0;  % 照明区域内成功将信号反射到馈源舱内的反射面板的总数量

for k = boundary(1) : 0.0001 : boundary(2)
    tmp1 = (32.845 + k) / (143.147 - 0.01 * k - 0.00175 * k ^2);
    tmp2 = 0.5 * cos( atan(tmp1));
    tmp3 = 32.845 + 2 * k;
    
    % 合理情况下的取值范围
    left = tmp3 - tmp2;
    right = tmp3 + tmp2;
    
    total = total + 1;
    % 如果成功反射信号到馈源舱
    if left <= k && k <= right
        valid = valid + 1;
    end
end

disp('基准球面馈源舱接收比')
fprintf('%f%%\n', valid / total * 100);