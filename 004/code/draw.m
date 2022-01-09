%% 画第一题中理想抛物面、基准球面
clear; clc; close all;
[X,Y] = meshgrid(-300:1:300);
Z = (X.^2 + Y.^2) ./ 560.52 - 300.33;
sphere = (300.^2 - X.^2 - Y.^2) .^ 0.5 .* -1;
mesh(X,Y,Z);

%% 画附件一里的图
% 所有主索节点的三维散点图
clear; clc; close all;
[data,txt]=xlsread('附件1.csv');
x = data(:,1);
y = data(:,2);
z = data(:,3);
scatter3(x,y,z,30,'b','.');
figure(gcf);

%% 画附件二里的图
% 其中蓝圈是主索节点的下断点；红圈是主索节点上端点
clear; clc; close all;
[data txt] = xlsread('附件2.csv');
x1 = data(:,1);
y1 = data(:,2);
z1 = data(:,3);
x2 = data(:,4);
y2 = data(:,5);
z2 = data(:,6);
scatter3(x1,y1,z1,30,'b','o');
figure(gcf);
hold on;
scatter3(x2,y2,z2,30,'r','o');
hold off;