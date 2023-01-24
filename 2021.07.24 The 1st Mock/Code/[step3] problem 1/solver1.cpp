/*
 * 该求解器要特别关注两个下标：
 * 1. 搅拌站的位置编号 pos
 * 2. 搅拌站编号作为输入数据，作为一个一维表的下标编号 plant
*/

#include <iostream>
#include <fstream>
#include <set>
#include <string>
#define CNT_SITE 92
#define CNT_PLANT 20
#define INF 0x3fffffff

using namespace std;

struct Plant {
    string name;
    int position_number;
    int type;
};

const int productivity[3 + 1] = {0, 400, 700, 900};  // 三种型号对应的产能

double min_dist[CNT_SITE + 5][CNT_SITE + 5];  // 弗洛伊德算法结果
Plant plants[CNT_PLANT + 5];  // 混凝土搅拌站的数据
double demand[CNT_SITE + 5];  // 工地的需求量
set<int> distribution[CNT_PLANT + 5];  // distribution[i] 保存了分配给 i 号搅拌站的工地编号集合
bool is_distributed[CNT_SITE + 5] = {};  // 标识工地是否已经分配过搅拌站

// 读取文件 floyd_answer.txt 中的邻接矩阵数据到 min_dist[][]
bool read_floyd_answer_txt();

// 读取文件 plant.txt 中的混凝土搅拌站的数据到 plants[]
bool read_plant_txt();

// 读取文件 site.txt 中的工地需求量数据到 demand[]
bool read_site_txt();

// 在从 site 到所有 plant 的最短距离中，找到第 n 小的距离
// 返回 plant 对应的位置编号
int get_nth_min(int site, int n);

// 返回 plant 当前的供给量
double get_current_supply(int plant);

// 从工地的视角，生成最佳分配方案
bool generate_scheme_by_site();

// 在从位置编号为 pos 的搅拌站到所有 site 的最短距离中，找到第 n 小的距离
// 返回 site 对应的位置编号
int get_nth_min_by_plant(int plant, int n);

// 从搅拌站的视角，生成最佳分配方案
bool generate_scheme_by_plant();

// 保存分配方案至 [filename].txt
bool save_answer(string filename);

// 输出所有搅拌站的存量和容量信息
void print_plant_info();

// 计算运输成本
double cal_cost();

int main()
{
    if (read_floyd_answer_txt())
        cout << "读取文件 floyd_answer.txt 成功！\n";
    else
        cout << "读取文件 floyd_answer.txt 失败！\n";

    if (read_plant_txt())
        cout << "读取文件 plant.txt 成功！\n";
    else
        cout << "读取文件 plant.txt 成功！\n";

    if (read_site_txt())
        cout << "读取文件 site.txt 成功！\n";
    else
        cout << "读取文件 site.txt 成功！\n";

    cout << "准备生成分配方案...\n";
    if (generate_scheme_by_plant() || true)
    {
        cout << "方案分配成功！\n";
        cout << "请输入文件名称：";
        string filename;
        cin >> filename;
        if (save_answer(filename))
            cout << "文件保存成功！\n";
        else
            cout << "文件保存失败！\n";
    }
    else
        cout << "方案分配失败\n";
    
    cout << "所有搅拌站的存量和容量信息如下：\n";
    print_plant_info();
    cout << "总的运输成本为：" << cal_cost() << endl;
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

bool read_plant_txt()
{
    ifstream f;
    f.open("plant.txt");
    if (!f.is_open())
        return false;
    for (int i = 1; i <= CNT_PLANT; i++)
    {
        string n;
        int p, t;
        f >> n >> p >> t;
        plants[i] = {n, p, t};
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

int get_nth_min(int site, int n)
{
    double tmp[CNT_PLANT + 5];
    int index[CNT_PLANT + 5];
    for (int i = 1; i <= CNT_PLANT; i++)
    {
        tmp[i] = min_dist[site][i];
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
    return index[n];
}

double get_current_supply(int plant)
{
    double cur = 0;
    for (set<int>::iterator it = distribution[plant].begin(); it != distribution[plant].end(); it++)
        cur += demand[*it];
    return cur;
}

bool generate_scheme_by_site()
{
    for (int site = 1; site <= CNT_SITE; site++)  // 对每一个工地 site
    {
        bool flag = false;  // 标志变量，用于侦测工地 site 是否能找到一个合适的搅拌站 plant
        for (int rank = 1; rank <= CNT_PLANT; rank++)
        {
            int plant = get_nth_min(site, rank);  // 找到第 rank 近的 plant
            double supply = get_current_supply(plant);  // 获取当前 plant 已供给量
            double capacity = productivity[plants[plant].type];  // 获取当前 plant 的最大供给容量
            cout << "距离工地 " << site << " 的第 " << rank << " 近的搅拌站是 " << plant << " 号" << endl;
            cout << "搅拌站 " << plant << " 目前的供给量为 " << supply << "/" << capacity << endl;
            if (supply + demand[site] <= capacity)  // 如果 plant 仍能向 site 提供攻击
            {
                flag = true;
                distribution[plant].insert(site);
                cout << "经分配后，搅拌站 " << plant << " 目前的供给量为 " << supply + demand[site] << "/" << capacity << endl;
                break;
            }
        }
        if (flag == false)
            return false;  // 不存在满足需求的分配方案
    }
    return true;
}

int get_nth_min_by_plant(int pos, int n)
{
    double tmp[CNT_SITE + 5];
    int index[CNT_SITE + 5];
    for (int i = 1; i <= CNT_SITE; i++)
    {
        tmp[i] = min_dist[pos][i];
        index[i] = i;
    }
    for (int i = 1; i <= n; i++)  // 找到第 i 小的值
    {
        int min_i = i;
        for (int j = i + 1; j <= CNT_SITE; j++)  // 找到 [i+1, CNT_SITE] 范围内的最小值
            if (tmp[j] < tmp[min_i])
                min_i = j;
        swap(tmp[i], tmp[min_i]);
        swap(index[i], index[min_i]);
    }
    return index[n];
}

bool generate_scheme_by_plant()
{
    for (int plant = 1; plant <= CNT_PLANT; plant++)
    {
        for (int rank = 1; rank <= CNT_SITE; rank++)
        {
            int pos = plants[plant].position_number;
            int site = get_nth_min_by_plant(pos, rank);  // 找到第 rank 近的 site，获得其位置编号
            if (is_distributed[site] == true)  // 跳过已分配过的
                continue;
            double supply = get_current_supply(plant);  // 获取当前 plant 已供给量
            double capacity = productivity[plants[plant].type];  // 获取当前 plant 的最大供给容量
            cout << "距离搅拌站 " << pos << " 的第 " << rank << " 近的工地是 " << site << " 号" << endl;
            cout << "搅拌站 " << pos << " 目前的供给量为 " << supply << "/" << capacity << endl;
            if (supply + demand[site] <= capacity)
            {
                distribution[plant].insert(site);
                is_distributed[site] = true;  // 标记已分配过
                cout << "经分配后，搅拌站 " << pos << " 目前的供给量为 " << supply + demand[site] << "/" << capacity << endl;
            }
            else
                break;
        }
    }
    for (int i = 1; i <= CNT_SITE; i++)
        if (is_distributed[i] == false)
            return false;
    return true;
}

bool save_answer(string filename)
{
    ofstream f;
    f.open(filename + ".txt", ios::out);
    if (!f.is_open())
        return false;
    for (int i = 1; i <= CNT_PLANT; i++)
    {
        f << plants[i].position_number << ' ';
        for (set<int>::iterator it = distribution[i].begin(); it != distribution[i].end(); it++)
            f << *it << ' ';
        f << endl;
    }
    f.close();
    return true;
}

void print_plant_info()
{
    for (int i = 1; i <= CNT_PLANT; i++)
        cout << "位置为 " << plants[i].position_number << " 的搅拌站："  << get_current_supply(i) << "/" << productivity[plants[i].type] << endl;
}

double cal_cost()
{
    double cost = 0;
    for (int i = 1; i <= CNT_PLANT; i++)
        for (set<int>::iterator it = distribution[i].begin(); it != distribution[i].end(); it++)
            cost += min_dist[plants[i].position_number][*it] * demand[*it];
    return cost;
}
