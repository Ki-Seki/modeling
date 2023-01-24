"""
TOPSIS法(优劣解距离法)介绍及 python3 实现 - Suranyi的文章 - 知乎
https://zhuanlan.zhihu.com/p/37738503
"""

import pandas as pd
import numpy as np


# 以下三个函数均为数据正向化处理函数

def dataDirection_1(datas, offset=0):
    """
    极小型指标正向化

    :param datas: 迭代器
    :param offset: 防止出现除以 0 的错误
    """
    def normalization(data):
        return 1 / (data + offset)

    return list(map(normalization, datas))


def dataDirection_2(datas, x_min, x_max):
    """
    中间型指标正向化：越靠近正中间越好

    :param datas: 迭代器
    :param x_min: 全部数据的最小值
    :param x_max: 全部数据的最大值
    """
    def normalization(data):
        if data <= x_min or data >= x_max:
            return 0
        elif data < (x_min + x_max) / 2:
            return 2 * (data - x_min) / (x_max - x_min)
        else:
            return 2 * (x_max - data) / (x_max - x_min)

    return list(map(normalization, datas))


def dataDirection_3(datas, x_min, x_max, x_minimum, x_maximum):
    """
    区间型指标正向化

    :param datas: 迭代器
    :param x_min: 最佳区间的左端点
    :param x_max: 最佳区间的右端点
    :param x_minimum: 可接受区间的左端点
    :param x_maximum: 可接受区间的右端点
    """
    def normalization(data):
        if x_min <= data <= x_max:
            return 1
        elif data <= x_minimum or data >= x_maximum:
            return 0
        elif data > x_max:
            return 1 - (data - x_max) / (x_maximum - x_max)
        else:
            return 1 - (x_min - data) / (x_min - x_minimum)

    return list(map(normalization, datas))


def entropyWeight(data):
    """
    熵权法确定权重

    :param data: 行为评价对象，列为一个个的指标的 DataFrame
    """
    data = np.array(data)
    # 归一化
    P = data / data.sum(axis=0)

    # 计算熵值
    E = np.nansum(-P * np.log(P) / np.log(len(data)), axis=0)

    # 计算权系数
    return (1 - E) / (1 - E).sum()


def topsis(data, weight=None):
    """
    TOPSIS 评价

    :param data: 数据
    :param weight: 权重，若不给，则用熵权法自动确定
    """

    # 归一化
    data = data / ((data ** 2).sum())**0.5

    # 最优最劣方案
    Z = pd.DataFrame([data.min(), data.max()], index=['负理想解', '正理想解'])

    # 距离
    weight = entropyWeight(data) if weight is None else np.array(weight)
    Result = data.copy()
    Result['正理想解'] = np.sqrt(
        ((data - Z.loc['正理想解']) ** 2 * weight).sum(axis=1))
    Result['负理想解'] = np.sqrt(
        ((data - Z.loc['负理想解']) ** 2 * weight).sum(axis=1))

    # 综合得分指数
    Result['综合得分指数'] = Result['负理想解'] / (Result['负理想解'] + Result['正理想解'])
    Result['排序'] = Result.rank(ascending=False)['综合得分指数']

    return Result, Z, weight


if __name__ == '__main__':
    """
    问题描述
    给定 5 所院校的 4 个指标，评价这 5 个院校的好坏
    """

    data = {'人均专著': [0.1, 0.2, 0.4, 0.9, 1.2],
            '生师比': [5, 6, 7, 10, 2],
            '科研经费': [5000, 6000, 7000, 10000, 400],
            '逾期毕业率': [4.7, 5.6, 6.7, 2.3, 1.8]}
    data = pd.DataFrame(data, index=['院校' + i for i in list('ABCDE')])

    data['生师比'] = dataDirection_3(data['生师比'], 5, 6, 2, 12)  # 师生比数据为区间型指标
    data['逾期毕业率'] = dataDirection_1(data['逾期毕业率'], 0.01)  # 逾期毕业率为极小型指标

    weight = [0.2, 0.3, 0.4, 0.1]  # 人为划分的权重
    out = topsis(data, weight=None)  # 若为 None，使用熵权法确定权重
    print(out[0])
