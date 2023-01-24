// K 均值聚类算法

#include <iostream>
#include <fstream>
#include <set>
#include <cmath>
#define CNT_SITE 92
#define CNT_PLANT 20
#define RAND_SEED 666

using namespace std;

struct Coordinate {
    double x, y;
};

set<int> clusters[CNT_PLANT + 5];  // CNT_PLANT 个聚类
Coordinate coord[CNT_SITE + 5];  // 所有工地的坐标数据
int plants[CNT_PLANT + 5];  // 每个聚类中最靠近中心点的作为搅拌站

// 读取 site.txt 中工地的坐标数据到 coord[]
void read_site_txt();

// 使用随即方法初始化聚类，其中随机数种子为 RAND_SEED
void random_init();

// 使用平均思想初始化聚类
void average_init();

// 获得 clusters[i] 的样本中心点
Coordinate get_sample_centre(int i);

// K 均值聚类算法的核心函数
void k_means();

// 将聚类结果保存到 cluster.txt 中
void save_cluster_txt();

// 以每个聚类中最靠近中心点的作为搅拌站，获取所有搅拌站的位置编号
void get_plant_pos();

int main()
{
    read_site_txt();
    random_init();
    k_means();
    cout << "聚类完毕！\n";
    save_cluster_txt();
    get_plant_pos();
    cout << "从所有聚类中找到最靠近其中心的样本点，作为搅拌站\n"
         << "这 20 个聚类的搅拌站的位置编号分别为：\n";
    for (int i = 1; i <= CNT_PLANT; i++)
        cout << plants[i] << ' ';
    cout << endl;
    return 0;
}

void read_site_txt()
{
    ifstream f;
    f.open("site.txt");
    for (int i = 1; i <= CNT_SITE; i++)
    {
        int index;
        double x, y, d;
        f >> index >> x >> y >> d;
        coord[index] = {x, y};
    }
    f.close();
}

void random_init()
{
    srand(RAND_SEED);
    for (int site = 1; site <= CNT_SITE; site++)
    {
        int r = 1 + rand() % CNT_PLANT;  // 产生 [1, 20] 的随机数 r
        clusters[r].insert(site);  // 随机将 site 分配给第 r 个聚类
    }
}

void average_init()
{

}

Coordinate get_sample_centre(int i)
{
    double sum_x = 0, sum_y = 0;
    for (set<int>::iterator it = clusters[i].begin(); it != clusters[i].end(); it++)
    {
        sum_x += coord[*it].x;
        sum_y += coord[*it].y;
    }
    double size = clusters[i].size();
    Coordinate c = {sum_x / size, sum_y / size};
    return c;
}

double euclidean_dist(Coordinate a, Coordinate b)
{
    return sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2));
}

void k_means()
{
    for (int site = 1; site <= CNT_SITE; site++)  // 遍历所有的工地
    {
        int from_cluster = -1;  // site 原来所在的 cluster 的下标
        int to_cluster = -1;  // site 将要去的最近的 cluster 的下标
        double min = __DBL_MAX__;  // 到所有聚类的最短的距离
        for (int cluster = 1; cluster <= CNT_PLANT; cluster++)
        {
            double d = euclidean_dist(coord[site], get_sample_centre(cluster));
            cout << "工地 " << site << " 到第 " << cluster << " 个聚类的距离为：" << d << endl;
            
            // 找最短距离及其对应的聚类的下标
            if (d < min)
            {
                min = d;
                to_cluster = cluster;
            }
            // 找 site 原来所在的 cluster 的下标
            if (clusters[cluster].count(site) == 1)
                from_cluster = cluster;
        }
        cout << "工地 " << site << " 从第 " << from_cluster << " 个聚类来，"<< "到第 " << to_cluster << " 个聚类的距离最短，为：" << min << endl;
        if (from_cluster != to_cluster)  // 如果起点终点不是同一聚类
        {
            clusters[from_cluster].erase(site);  // 从原聚类中删除 site
            clusters[to_cluster].insert(site);  // 在新聚类中加入 site
        }
    }
}

void save_cluster_txt()
{
    ofstream f;
    f.open("cluster.txt");
    for (int i = 1; i <= CNT_PLANT; i++)
    {
        for (set<int>::iterator it = clusters[i].begin(); it != clusters[i].end(); it++)
            f << *it << ' ';
        f << endl;
    }
    f.close();
}

void get_plant_pos()
{
    for (int i = 1; i <= CNT_PLANT; i++)  // 对于每个聚类
    {
        Coordinate centre = get_sample_centre(i);  // 聚类的中心点
        double min_dist = __DBL_MAX__;
        int min_site = -1;
        for (set<int>::iterator it = clusters[i].begin(); it != clusters[i].end(); it++)
        {
            int site = *it;
            double d = euclidean_dist(coord[site], centre);
            if (d < min_dist)
            {
                min_dist = d;
                min_site = site;
            }
        }
        plants[i] = min_site;
    }
}
