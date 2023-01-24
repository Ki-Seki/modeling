# 介绍

这个仓库保存了自己备战、参与数学建模竞赛时所写的相关代码（以 MATLAB 为主）。

## 目录

| **文件夹**              | **内容**                                | **赛题**                                     |
| ----------------------- | --------------------------------------- | -------------------------------------------- |
| 2021.07.24 The 1st Mock | 建模国赛备赛：第一次校内模拟训练        | 砼搅拌站的选址与规划设计                     |
| 2021.07.27 The 2nd Mock | 建模国赛备赛：第二次校内模拟训练        | 波士顿房价问题                               |
| 2021.09.04 The 3rd Mock | 建模国赛备赛：第三次校内模拟训练        | 应急物资分配决策                             |
| 2021.09.12 CUMCM        | 2021年全国大学生数学建模竞赛（CUMCM）   | A 题 “FAST”主动反射面的形状调节              |
| 2022.02.22 MCMICM       | 2022年美国大学生数学建模竞赛（MCM/ICM） | Problem E: Forestry for Carbon Sequestration |
| Templates               | 一些存档的模型的代码                    | -                                            |

## 代码统一使用 UTF-8 编码

MATLAB 默认使用 GBK，即 GB2312 编码，不通用。修改默认编码为 UTF-8 的方法如下：

编辑 matlab 的 locale 数据库文件 `lcdata.xml` (matlab bin 目录下).

删除

```xml
<encoding name="GBK">
    <encoding_alias name="936"/>
</encoding>
```

并将

```xml
<encoding name="UTF-8">
    <encoding_alias name="utf8"/>
</encoding>
```

改为

```xml
<encoding name="UTF-8">
    <encoding_alias name="utf8"/>
    <encoding_alias name="GBK"/>
</encoding>
```

重启 matlab 之后，即以 utf-8 编码.

> 方法作者：mozooo
> 
> 链接：https://www.zhihu.com/question/27933621/answer/249429313
> 
> 来源：知乎
> 
> 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

## 开源协议

如无特殊说明，开源协议默认为 MIT；在每个项目文件夹下，如有 LICENSE 文件，则要遵从其协议规定。
