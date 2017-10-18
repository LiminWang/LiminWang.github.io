# 边缘检测算法

## 概念

边缘是指图像局部上灰度强度变化最显著的点的集合部分。主要存在于目标与目标、目标与
背景、区域与区域包括不同色彩)之间，是图像分割、纹理特征和形状特征等图像分析的重
要基础。边缘检测的任务就是精确定位边缘和抑制噪声。


## 数学背景
### 线性滤波

线性滤波可以说是图像处理最基本的方法，它可以允许我们对图像进行处理，产生很多不同
的效果。做法很简单。首先，我们有一个二维的滤波器矩阵（也叫卷积核）和一个要处理的
二维图像。然后，对于图像的每一个像素点，计算它的邻域像素和滤波器矩阵的对应元素的
乘积，然后加起来，作为该像素位置的值。这样就完成了滤波过程。

### 卷积

线性滤波可以说是图像处理最基本的方法，它可以允许我们对图像进行处理，产生很多不同
的效果。做法很简单。首先，我们有一个二维的滤波器矩阵（卷积核）和一个要处理的二维
图像。然后，对于图像的每一个像素点，计算它的邻域像素和滤波器矩阵的对应元素的乘积
，然后加起来，作为该像素位置的值。这样就完成了滤波过程。

* 用数学公式表示
y(s)=∫x(t)h(s-t)dt

一个单位脉冲信号，经过一个卷积核，得到的结果，就是这个卷积核。

一个图像是一个不同幅度的脉冲信号的n*m阵列，经过一个卷积核，得到的结果,就是个经过
n*m个不同幅度的平移后的卷积核的叠加

### 导数
连续函数上某点斜率，导数越大表示变化率越大，变化率越大的地方就越是“边缘”,在斜率
90度的地方，导数无穷大, 很难表示出来

在实际的图像分割中，往往只用到一阶和二阶导数，虽然，原理上，可以用更高阶的导数，
但是，因为噪声的影响，在纯粹二阶的导数操作中就会出现对噪声的敏感现象，三阶以上的
导数信息往往失去了应用价值。二阶导数还可以说明灰度突变的类型。在有些情况下，如灰
度变化均匀的图像，只利用一阶导数可能找不到边界，此时二阶导数就能提供很有用的信息
。二阶导数对噪声也比较敏感，解决的方法是先对图像进行平滑滤波，消除部分噪声，再进
行边缘检测。不过，利用二阶导数信息的算法是基于过零检测的，因此得到的边缘点数比较
少，有利于后继的处理和识别工作。

### 微分
连续函数上x变化了dx，导致y变化了dy，dy值越大表示变化的越大.

微分与导数换算：dy = f'(x)dx

### 差分
对数字图像常用差分代替微分, 差分定义 
f'(x) = f(x + 1) - f(x)，用后一项减前一项

## 滤波矩阵
滤波矩阵是一个由权重数据组成的矩阵，中心像素周围像素的亮度乘以这些权重然后再相加
就能得到中心像素的转化后数值。大小一般都为奇数，以便他有一个中心，如3x3,5x5,7x7,
下面以3x3为例说明常见的滤波矩阵。你可以观察到矩阵元素和一般都是1(亮度一样） 

### 直通滤波

```
0,0,0,
0,1,0,
0,0,0
```

### 锐化滤波

```
 0, -2,  0,
-2,  9, -2,
 0, -2,  0
 ```

### 平均模糊

```
1/9,1/9,1/9,
1/9,1/9,1/9,
1/9,1/9,1/9
```

### 高斯模糊

```
1/16 * [1,2,1
        2,4,2,
        1,2,1]
1/273 * [1, 4, 7, 4,1,
         4,16,26,26,4,
         7,26,41,26,7,
         4,16,26,26,4,
         1, 4, 7, 4,1]
```

### 运动模糊

```
1/3,0,0,
0,1/3,0,
0,0,1/3
```

### 浮雕

```
-1,-1,0,
-1, 0,1,
 0, 1,1
 ```


## 边缘检测算法
边缘检测的基本思想首先是利用边缘增强算子, 突出图像中的局部边缘, 然后定义象素的"
边缘强度", 通过设置阈值的方法提取边缘点集。由于噪声和 模糊的存在, 监测到的边界可
能会变宽或在某点处发生间断。

图象边缘检测必须满足两个条件：一能有效地抑制噪声；二必须尽量精确确定边缘的位置。
常用的检测算子有微分算子、拉普拉斯高斯算子和canny算子。

### Sobel算子
微分算子法是指对图像求一阶导数或二阶导数, 图像灰度变化较大的点处得到的值较大,因此
我们将图像的导数算子运算值作为相应的边界强度, 所以可以通过 对这些导数值设置阈值,
提取边界的点集。对数字图像常用差分代替微分, 比较常见的微分算子有Sobel, prewitt和
Robert算子。

* 计算一阶差分

排好序：[-1 * f(x-1)，0 * f(x)，1 * f(x+1)]
提出系数：[-1, 0, 1]

* 二维表

```
-1, 0, 1
-1, 0, 1
-1, 0, 1
```

* Prewitt算子
属于加权平均算子, 对噪声有抑制作用

f(x-1, y-1),  f(x, y-1),  f(x+1, y-1)
f(x-1, y),    f(x, y),    f(x+1, y)
f(x-1, y+1),  f(x, y+1),  f(x+1, y+1)

*  Sobel 算子
1. 加大中心权重，偏x方向 

```
-1, 0, 1
-2, 0, 2
-1, 0, 1
```

2. 加大中心权重，偏y方向 

```
-1, -2, -1
0,  0,  0
1,  2,  1

3. Sobel检测结果

```
G(x, y) = Gx + Gy,  范围为[0, 255]
Gx: 偏x 方向
Gy: 偏y 方向
```

* OpenCV测试代码

```cpp
#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;

int main(int argc, char** argv)
{
    Mat src;
    Mat out;
    Mat sobelx, sobely;
    Mat disp;

    src = imread(argv[1]);

    // Display image
    namedWindow("Original Image", WINDOW_AUTOSIZE);
    imshow("Original Image", src);

    // Apply sobel filter with only x gradient
    Sobel(src, sobelx, CV_32F, 1, 0);
    // Apply sobel filter with only y gradient
    Sobel(src, sobely, CV_32F, 0, 1);

    //合并原图和结果图显示
    hconcat(sobelx, sobely, disp);

    namedWindow(argv[1], CV_WINDOW_AUTOSIZE | CV_WINDOW_KEEPRATIO | CV_GUI_EXPANDED);
    imshow(argv[1], disp);

    waitKey();
    return 0;
}
```


### Laplace算子
拉普拉斯是用二阶差分计算边缘的，边缘衡量方式，常应用于事先已做过平滑处理的图像，
其目的是减少影像对噪声的敏感度Laplace算子优点是是各向同性的, 能对任何走向的界线
和线条进行锐化, 无方向性。

与一阶微分相比，二阶微分的边缘定位能力更强，锐化效果更好。拉普拉斯算子应用可增强
图像中灰度突变的区域，减弱灰度的缓慢变化区域。因此，锐化处理可选择拉普拉斯算子对
原图像进行处理，产生描述灰度突变的图像，再将拉普拉斯图像与原始图像叠加而产生锐化
图像

1. 一阶微分图中极大值或极小值处
2. 二阶微分在亮的一边是负的，在暗的一边是正的。常数部分为零。可以用来确定边的准
确位置，以及像素在亮的一侧还是暗的一侧。
3. 定义数字形式的拉普拉斯要求系数之和必为0

* 数学推导

一阶差分：f '(x) = f(x) - f(x - 1)
二阶差分：f '(x) = (f(x + 1) - f(x)) - (f(x) - f(x - 1))

简化：f '(x) = f(x - 1) - 2 f(x)) + f(x + 1)
系数：[1, -2, 1]
二维：f '(x, y) = -4 f(x, y) + f(x-1, y) + f(x+1, y) + f(x, y-1) + f(x, y+1)

卷积系数：
```
0,  1, 0
1, -4, 1
0,  1, 0
```

考虑上2个斜对角, 最终得到卷积模版系数：

```
1,  1, 1
1, -8, 1
1,  1, 1
```

5 x 5 过滤器
```
0   0 -1  0  0 
0  -1 -2 -1  0
-1 -2 17 -2 -1
0  -1 -2 -1  0
0   0 -1  0  0
```

* OpenCV测试代码

```cpp
#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;

int main(int argc, char** argv)
{
    Mat src, src_gray, dst_gray, dst, disp;

    src = imread(argv[1]);

    //用高斯滤波降噪
    Mat g_src;
    GaussianBlur(src, g_src, Size(3, 3), 0, 0);

    //获取灰度图像
    cvtColor(g_src, src_gray, COLOR_RGB2GRAY);

    //Laplacian变换
    Laplacian(src_gray, dst_gray, CV_8U, 9, 1, 0, BORDER_DEFAULT);

    dst = Scalar::all(0);
    src.copyTo(dst, dst_gray);

    //合并原图和结果图显示
    hconcat(src, dst, disp);

    namedWindow(argv[1], CV_WINDOW_AUTOSIZE | CV_WINDOW_KEEPRATIO | CV_GUI_EXPANDED);
    imshow(argv[1], disp);

    waitKey();
    return 0;
}
```

### Canny算子
* 背景
Canny算法是John F.Canny在1986年提出的边缘检测算法, 论文提出3个标准
1. 检测标准：不丢失重要的边缘，不应有虚假的边缘。
2. 定位标准：实际边缘与检测到的边缘位置之间的偏差最小。
3. 单响应标准：将多个响应降低为单个边缘响应。简言之，是检测出来的边缘的边缘宽度
应该为1

经典的Canny边缘检测算法通常都是从高斯模糊开始，到基于双阈值实现边缘连接结束。

Canny算子是一个具有滤波，增强，检测的多阶段的优化算子，在进行处理前，Canny算子先
利用高斯平滑滤波器来平滑图像以除去噪声，Canny分割算法采用一阶偏导的有限差分来计
算梯度幅值和方向，在处理过程中，Canny算子还将经过一个非极大值抑制的过程，最后
Canny算子还采用两个阈值来连接边缘。

* 算法 
1.平滑处理：将图像与高斯矩阵做卷积。
为了减少图像的噪点，通常都会使用高斯滤波器来平滑图像。如size=5的算子如下:

```
1/159 * [2, 4, 5, 4,2,
         4, 9, 12,9,4,
         5, 12,15,12,5,
         4, 9, 12,9,4,
         2, 4, 5, 4,2]
```

2.边缘强度计算：计算图像的边缘幅度及方向。

边缘强度的计算包括边缘幅度以及边缘方向的计算。一般选择Sobel算子或者Roberts算子得
到x,y方向的梯度强度，利用两个方向的梯度dx, dy,然后利用如下公式计算：
* 边缘强度：g=dx2+dy2
* 边缘方向：θ=atan2(dy,dx)

一般在算法实现中，为了效率边缘强度的计算会使用|dx|+|dy|计算。

3.非极大值抑制：只有局部极大值标记为边缘。

对于边缘的定义一般情况下有两种：一种是二阶导数过零点，另一种是一阶导数的极大极小
值。这两种定义本质上是一致的。但是在实现上通常使用后一种

4.滞后阈值化处理。
边缘的提取好坏很大程度上依赖阈值的选取。如果阈值选取过大，则会少掉有效边缘。如果
阈值设置过小，则会有许多噪点。

滞后阈值分割使用两个阈值，high threshold和low threshold。当边缘强度大于high
threshold的立即设置为边缘点，低于low threshold立即剔除，在中间的作为潜在边缘点，
按下列原则处理：只有这些点能按照某一路径与已存在边缘点相连时，它们才被接受为边缘点 

* OpenCV实现函数
可以参考代码实现理解

void Canny(InputArray image, OutputArray edges, double threshold1, double
            threshold2, int apertureSize=3, bool L2gradient=false )

* 测试代码

```cpp
#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;

int main(int argc, char** argv)
{
    Mat src;
    Mat out;
    Mat dst, edge, gray;
    Mat disp;

    src = imread(argv[1]);

    //将原图像转为灰度
    cvtColor(src, gray, COLOR_RGB2GRAY);

    //滤波(降噪)
    blur(gray, edge, Size(3, 3));

    Canny(edge, out, 15, 10);

    dst = Scalar::all(0);
    src.copyTo(dst, out);

    //合并原图和结果图显示
    hconcat(src, dst, disp);

    namedWindow(argv[1], CV_WINDOW_AUTOSIZE | CV_WINDOW_KEEPRATIO | CV_GUI_EXPANDED);
    imshow(argv[1], disp);

    waitKey();
    return 0;
}

```


# 参考链接
* [Image Filtering](http://lodev.org/cgtutor/filtering.html)
* [Laplace Operator](https://docs.opencv.org/2.4/doc/tutorials/imgproc/imgtrans/laplace_operator/laplace_operator.html)
* [Sobel operator](https://en.wikipedia.org/wiki/Sobel_operator)
* [Canny edge detector](http://en.wikipedia.org/wiki/Canny_edge_detector)
* [微分方程](http://open.163.com/special/opencourse/equations.html)





