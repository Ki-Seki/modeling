% 根据正互反阵得到权重列向量
function [weight, flag, CR] = AHP(matrix)
    % matrix 正互反阵
    % weight 权重，列向量
    % flag 是否通过一致性检验，通过为 true
    % CR 层次分析法中的一致性比率

    n = size(matrix, 1);
    
    %% 求最大特征值及其对应的特征向量
    [vec, val] = eig(matrix);
    [max_eigval, index] = max(diag(val));  % 最大特征值及其下标
    max_eigvec = vec(:, index);  % 最大特征值对应的特征向量
    
    %% 求权重
    
    weight = max_eigvec / sum(max_eigvec);
    
    %% 一致性检验
    CI = (max_eigval - n) / (n - 1);
    RI = [0,0,0.58,0.9,1.12,1.24,1.32,1.41,1.45,1.49,1.52,1.54,1.56,1.58,1.59];
    CR = CI / RI(n);
    flag = (CR <= 0.1);
end