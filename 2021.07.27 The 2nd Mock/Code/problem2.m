clear;
clc;
close all;

middle_point = 496;
districts = 1 : middle_point;  % 用于训练的地区
test_districts = middle_point + 1 : 506;  % 用于测试的地区
load data.mat;  % 加载数据
%load sorted_data.mat
%data = sorted_data;
data = data';  % 数据规整化

% 将前 districts 个数据作为训练数据
input = data(1:13, districts);
output = data(14:14, districts);

% 将后 test_districts 个数据作为测试数据
test_input = data(1:13, test_districts);
test_output = data(14:14, test_districts);

[pn,minp,maxp,tn,mint,maxt] = premnmx(input, output);  % 归一化
dx = [-1 1; -1 1; -1 1; -1 1; -1 1; -1 1; -1 1; -1 1; -1 1; -1 1; -1 1; -1 1; -1 1];  % 取值范围
TF1='tansig';TF2='logsig';TF3='purelin';  % 设置传输函数
net = newff(dx, [5, 10, 1], {TF1, TF2, TF3}, 'trainlm');  % 创建网络

% 设置网络参数
net.trainParam.epochs = 50000;
net.trainParam.show = 1000;
net.trainParam.lr   = 0.05;
net.trainParam.goal = 1e-4;
net.trainParam.mc = 0.9;
net.trainFcn = 'trainlm';

net = train(net, pn, tn);  % 利用归一化后的数据pn,tn训练网络
a = sim(net,pn);  % 仿真
answer = postmnmx(a,mint,maxt);  % 反归一化，即还原

% 进行训练数据比较，绘制图表
figure(1);
plot(districts, answer, 'r:o', districts, output, 'b--+');
legend('网络模拟值','实际观测值');
xlabel('地区编号');ylabel('拥有住房价值中位数（千美元）');
title('房价模拟值与观测值对比图');

% 预测后 test_districts 个地区的房价
test_pn = tramnmx(test_input, minp, maxp);  % 归一化
tmp = sim(net, test_pn);  % 仿真
test_answer = postmnmx(tmp, mint, maxt)  % 反归一化

% 进行测试数据比较，绘制图表
figure(2);
plot(test_districts, test_answer, 'r:o', test_districts, test_output, 'b--+');
legend('网络模拟值','实际观测值');
xlabel('地区编号');ylabel('拥有住房价值中位数（千美元）');
title('房价模拟值与观测值对比图');

% 计算预测出来的结果的均方误差
ssr = sum(test_output - test_answer).^2;  % 残差平方和
mse = ssr / (506 - middle_point)  % 均方误差