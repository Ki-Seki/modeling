% 判断在允许误差为 ε 时，点 p 是否能够成功将信号返回到馈源舱

function flag = is_received(p, epsilon)
% 常量
focus = [-26.302,-19.673,-156.796];  % 焦点坐标
f = 140.13;  % 理想抛物面的焦距

% 计算距离
d = sum((focus - p) .^ 2) .^ 0.5;

% 计算距离差的绝对值
delta = abs(d - f);

% 返回结果
flag = (delta < epsilon);
end