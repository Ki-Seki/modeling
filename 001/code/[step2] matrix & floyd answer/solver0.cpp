#include <iostream>
#include <fstream>
#include <cmath>
#include <string>
#define CNT_SITE 92
#define CNT_PATH 140
#define INF 0x3fffffff

using namespace std;

struct Site {
    double x, y;
};

Site sites[CNT_SITE + 5];  // 一维表：工地坐标
double matrix[CNT_SITE + 5][CNT_SITE + 5];  // 邻接矩阵：工地间的路径

// 读取文件 site.txt 中的工地坐标数据到 sites[]
bool read_site_txt();

// 读取文件 path.txt 中的工地间的路径数据到 matrix[][]
bool read_path_txt();

// 存储邻接矩阵到文件 file_name
bool save_matrix(string file_name);

// 弗洛伊德算法求全源最短路径
void floyd()
{
    for (int i = 1; i <= CNT_SITE; i++)  // 中介点 i
        for (int j = 1; j <= CNT_SITE; j++)
            for (int k = 1; k <= CNT_SITE; k++)
                if (matrix[j][i] != INF && matrix[i][k] != INF)  // 存在路径
                    if (matrix[j][i] + matrix[i][k] < matrix[j][k])  // 松弛操作
                        matrix[j][k] = matrix[j][i] + matrix[i][k];
}

int main()
{
    read_site_txt();
    fill(matrix[0], matrix[0] + (CNT_SITE + 5) * (CNT_SITE + 5), INF);
    for (int i = 1; i <= CNT_SITE; i++) matrix[i][i] = 0;
    read_path_txt();
    save_matrix("matrix");
    floyd();
    save_matrix("floyd_answer");
    return 0;
}

bool read_site_txt()
{
    ifstream f;
    f.open("site.txt");
    if (!f.is_open())
        return false;
    for (int i = 0; i < CNT_SITE; i++)
    {
        int n;
        double x, y, d;
        f >> n >> x >> y >> d;
        sites[n] = {x, y};
    }
    f.close();
    return true;
}

bool read_path_txt()
{
    ifstream f;
    f.open("path.txt");
    if (!f.is_open())
        return false;
    for (int i = 0; i < CNT_PATH; i++)
    {
        int s1, s2;
        double x1, x2, y1, y2, distance;
        f >> s1 >> s2;
        x1 = sites[s1].x;
        y1 = sites[s1].y;
        x2 = sites[s2].x;
        y2 = sites[s2].y;
        distance = sqrt(pow(x2-x1, 2) + pow(y2-y1, 2));
        matrix[s1][s2] = matrix[s2][s1] = distance;
    }
    f.close();
    return true;
}

bool save_matrix(string filename)
{
    ofstream f;
    f.open(filename + ".txt", ios::out);
    if (!f.is_open())
        return false;
    for (int i = 1; i <= CNT_SITE; i++)
    {
        for (int j = 1; j <= CNT_SITE; j++)
            f << (matrix[i][j] == INF ? -1 : matrix[i][j]) << ' ';
        f << endl;
    }
    f.close();
    return true;
}
