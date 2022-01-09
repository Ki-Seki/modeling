# 介绍

这个仓库保存了自己参与的建模、科研项目的 MATLAB 代码。各文件夹内涵如下：

* 001：2021年第一次建模模拟（并非 MATLAB 代码解决，但思想是一致的）
* 002：2021年第二次建模模拟
* 003：2021年第三次建模模拟
* 004：2021年数模竞赛
* 005：陈克明遗传粒子群混合算法代码
* 006：疫情下应急物资配送

# 注意

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