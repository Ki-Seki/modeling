/*
 * 该求解器要特别关注两个下标：
 * 1. 搅拌站的位置编号 pos
 * 2. 搅拌站编号作为输入数据，作为一个一维表的下标编号 plant
*/

#include <iostream>
#include <fstream>
#include <string>
#include <algorithm>
#include <map>
#define CNT_SITE 92
#define CNT_PLANT 20
#define INF 0x3fffffff

using namespace std;

struct Expect {
    double volume;
    int index;  // 排序下标
    int type;
};

const int all_types[CNT_PLANT + 5] = {0, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1};

double min_dist[CNT_SITE + 5][CNT_SITE + 5];  // 弗洛伊德算法结果
double demand[CNT_SITE + 5];  // 工地的需求量
int plant_pos[CNT_PLANT + 5];  // 搅拌站的位置，第一、二题中即从 1 到 20，第三题要看聚类分析后的结果
map<int, int> pos_plant;  // 将搅拌站的位置编号翻译为原来的下标
Expect supply[CNT_PLANT + 5] = {};  // 所有搅拌站的供给量期望值

// 读取文件 floyd_answer.txt 中的邻接矩阵数据到 min_dist[][]
bool read_floyd_answer_txt();

// 读取文件 site.txt 中的工地需求量数据到 demand[]
bool read_site_txt();

// 输入搅拌站的位置
void input_plant_pos();

// 在从 site 到所有 plant 的最短距离中，找到第 n 小的距离
// 返回 plant 对应的位置编号
int get_nth_min(int site, int n);

// 计算所有搅拌站的供给量期望值
void cal_expectation();

// 重载辅助 sort() 的 cmp() 函数
// 实现按照量从大到小排列
int cmp_by_volume(Expect a, Expect b)
{
    return a.volume > b.volume;
}

// 重载辅助 sort() 的 cmp() 函数
// 实现按照下标从小到大排列
int cmp_by_index(Expect a, Expect b)
{
    return a.index < b.index;
}

// 将每个工地的期望值和对应的工地编号保存到 expectation.txt
void save_expectation_txt();

// 生成方案：建设类型
// 方案会保存到 plant.txt。注意：这有可能覆盖原有的 plant.txt
void save_plant_txt();

int main()
{
    if (read_floyd_answer_txt())
        cout << "读取文件 floyd_answer.txt 成功！\n";
    else
        cout << "读取文件 floyd_answer.txt 失败！\n";

    if (read_site_txt())
        cout << "读取文件 site.txt 成功！\n";
    else
        cout << "读取文件 site.txt 成功！\n";

    input_plant_pos();

    cout << "准备计算各搅拌站期望值...\n";
    cal_expectation();
    cout << "计算完毕！\n";

    cout << "正在将期望值和类型一一对应...\n";
    sort(supply + 1, supply + 1 + CNT_PLANT, cmp_by_volume);
    for (int i = 1; i <= CNT_PLANT; i++)
        supply[i].type = all_types[i];
    save_expectation_txt();
    cout << "expectation.txt 保存成功！\n";

    sort(supply + 1,supply + 1 + CNT_PLANT, cmp_by_index);  // 重新排序回去
    save_plant_txt();
    cout << "plant.txt 保存成功！\n";
    return 0;
}

bool read_floyd_answer_txt()
{
    ifstream f;
    f.open("floyd_answer.txt");
    if (!f.is_open())
        return false;
    for (int i = 1; i <= CNT_SITE; i++)
        for (int j = 1; j <= CNT_SITE; j++)
        {
            double d;
            f >> d;
            if (d == -1) d = INF;
            min_dist[i][j] = min_dist[j][i] = d;
        }
    f.close();
    return true;
}

bool read_site_txt()
{
    ifstream f;
    f.open("site.txt");
    if (!f.is_open())
        return false;
    for (int i = 1; i <= CNT_SITE; i++)
    {
        double tmp1, tmp2, tmp3;
        double d;
        f >> tmp1 >> tmp2 >> tmp3 >> d;
        demand[i] = d;
    }
    f.close();
    return true;
}

void input_plant_pos()
{
    // 将搅拌站位置默认定义为 1 ~ 20
    for (int i = 1; i <= CNT_PLANT; i++)
    {
        plant_pos[i] = i;
        pos_plant[i] = i;
    }
    cout << "是否使用默认的从 1 ~ 20 编号的搅拌站位置？请键入 (y/n)：\n";
    char button;
    cin >> button;
    if (button == 'n' || button == 'N')
    {
        cout << "请输入 20 个搅拌站的位置编号：\n";
        for (int i = 1; i <= CNT_PLANT; i++)
        {
            cin >> plant_pos[i];
            pos_plant[plant_pos[i]] = i;
        }
    }}

int get_nth_min(int site, int n)
{
    double tmp[CNT_PLANT + 5];
    int index[CNT_PLANT + 5];
    for (int i = 1; i <= CNT_PLANT; i++)
    {
        tmp[i] = min_dist[site][plant_pos[i]];
        index[i] = i;
    }
    for (int i = 1; i <= n; i++)  // 找到第 i 小的值
    {
        int min_i = i;
        for (int j = i + 1; j <= CNT_PLANT; j++)  // 找到 [i+1, CNT_PLANT] 范围内的最小值
            if (tmp[j] < tmp[min_i])
                min_i = j;
        swap(tmp[i], tmp[min_i]);
        swap(index[i], index[min_i]);
    }
    return plant_pos[index[n]];
}

void cal_expectation()
{
    for (int site = 1; site <= CNT_SITE; site++)  // 对每一个工地 site
    {
        int pos = get_nth_min(site, 1);  // 找到最近的 plant
        supply[pos_plant[pos]].volume += demand[site];  // 累加求搅拌站 plant 的供给量期望值
    }
}

void save_expectation_txt()
{
    ofstream f;
    f.open("expectation.txt");
    for (int i = 1; i <= CNT_PLANT; i++)
        f << supply[i].volume << ' ';
    f << endl;
    for (int i = 1; i <= CNT_PLANT; i++)
        f << supply[i].type << ' ';
    f.close();
}

void save_plant_txt()
{
    ofstream f;
    f.open("plant.txt", ios::out);
    for (int i = 1; i <= CNT_PLANT; i++)
        f << 'A' << i << ' ' << plant_pos[i] << ' ' << supply[i].type << endl;
    f.close();
}
