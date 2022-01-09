% 给定 θ 度数，判断点 p(x, y, z) 是否在照明区域内

function [flag, degree] = is_in_illumination(p, theta)
    % 常量
    focus = [-26.302,-19.673,-156.796];  % 理想抛物面焦点坐标
    vertex = [-49.309, -36.881, -293.949];  % 理想抛物面顶点坐标
    f = 140.13;  % 焦距

    tmp1 = sum((p-focus).^2) ^ 0.5;
    tmp2 = sum((p-vertex).^2) ^ 0.5;
    cos_val = (tmp1^2 + f^2 - tmp2^2) / (2 * f * tmp1);

    % 返回结果，即是否夹角小于 θ
    degree = acos(cos_val) * 180 / pi;
    flag = (0 <= degree && degree <= theta);
end