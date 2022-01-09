% 给定原始主索节点坐标 (x, y, z)，计算当伸缩量为 Δs 时的新的坐标 (x', y', z')
function [new_x, new_y, new_z] = cal_new_coord(x, y, z, delta_s)
    distance = (x^2 + y^2 + z^2) ^ 0.5;  % 主索节点距离球心的距离
    new_x = x * (distance - delta_s) / distance;
    new_y = y * (distance - delta_s) / distance;
    new_z = z * (distance - delta_s) / distance;
end