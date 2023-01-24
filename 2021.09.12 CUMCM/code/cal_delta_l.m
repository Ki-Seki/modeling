% 根据给定参数 f 和 h，计算出Δl径
function delta_l = cal_delta_l(f, h)
    R = 300;  % 常量
    min_y = -R + h;  % 抛物线顶点
    max_y = (R/2)^2 / (4*f) - (300-h);  % 即当 x = (R/2) 时，抛物线函数的对应函数值
    y = min_y : 0.001 : max_y;  % 每 0.001 间隔就采样一个 y
    l = (4 * f * (y+R-h) + y.^2) .^ 0.5;  % 计算工作抛物线上每一个点到球心的距离
    delta_l = max(l) - min(l);  % 计算出Δl
end

