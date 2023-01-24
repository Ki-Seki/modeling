% 获取所有三角形反射面板的中心点坐标
% 三角形的三个顶点分别为 A, B, C；中心点为 centre

function [cnt, centres] = get_centres()
    % 读取数据及预处理
    [data1, txt1] = xlsread('附件1.csv');
    [~, txt3] = xlsread('附件3.csv');
    txt1(1, :) = [];  % 删除首行，即表头
    txt1(:, 2:4) = [];  % 删除 2 到 4 列
    txt3(1, :) = [];  % 删除首行，即表头
    
    % 计算所有的中心点坐标
   cnt = size(txt3, 1);
   centres = zeros(cnt, 3);
   for i = 1 : cnt
       [~, a_no] = ismember(txt3(i,1), txt1);  % A 点在附件一中的序号，下同
       [~, b_no] = ismember(txt3(i,2), txt1);
       [~, c_no] = ismember(txt3(i,3), txt1);
       a = data1(a_no, :);  % A 点坐标，下同
       b = data1(b_no, :);
       c = data1(c_no, :);
       centres(i, :) = (a + b + c) ./ 3;
   end
end