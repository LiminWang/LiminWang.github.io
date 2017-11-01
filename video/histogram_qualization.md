# 直方图均衡化(Histogram Equalization)

## 原理

### 图像的直方图是什么?
* 直方图是图像中像素强度分布的图形表达方式
* 它统计了每一个强度值所具有的像素个数

### 直方图均衡化是什么?
* 直方图均衡化是通过拉伸像素强度分布范围来增强图像对比度的一种方法
* 直方图均衡化就是把给定图像的直方图分布改变成“均匀”分布直方图分布
* 直方图均衡化处理的“中心思想”是把原始图像的灰度直方图从比较集中的
某个灰度区间变成在全部灰度范围内的均匀分布

### 优点
* 通过这种方法，亮度可以更好地在直方图上分布
* 可逆性，如果已知均衡化函数，完全可以重新恢复原始的直方图


### 缺点
* 变换后图像的灰度级减少，某些细节消失
* 直方图有高峰的图像，处理后对比度不自然的部分过分增强


## 实现算法
直方图均衡化的基本思想是把原始图的直方图变换为均匀分布的形式，这样就增加了象素灰
度值的动态范围从而可达到增强图像整体对比度的效果。

在灰度直方图均衡化处理中对图像的映射函数可定义为:g = EQ (f)，这个映射函数EQ(f)必
须满足两个条件(其中L为图像的灰度级数)
* EQ(f)在0<=f<=L-1范围内是一个单值单增函数。这是为了保证增强处理没有打乱原始图像
的灰度排列次序，原图各灰度级在变换后仍保持从黑到白(或从白到黑)的排列
* 对于0<=f<=L-1有0<=g<=L-1，这个条件保证了变换前后灰度值动态范围的一致

要想实现均衡化的效果, 映射函数应该是一个累积分布函数(cumulative distribution
function，CDF), 通过CDF函数可以完成将原图像f的分布转换成g的均匀分布, 映射函数：
```
gk = EQ(fk) = (ni/n) = pf(fi)， (k=0,...,L-1)
```

可以参考OpenCV的equalizeHist函数源码实现.

## OpenCV实现

```cpp
 #include "opencv2/highgui/highgui.hpp"
 #include "opencv2/imgproc/imgproc.hpp"
 #include <iostream>
 #include <stdio.h>

 using namespace cv;
 using namespace std;

 int main( int argc, char** argv )
 {
     char* source_window = "Source Image";
     char* equalized_window = "Equalized Image";
     Mat src, dst;

     src = imread( argv[1], 1 );

     if( !src.data ) {
         cout <<"Usage: " << argv[0] << " <path_to_image>" << endl;
         return -1;
     }

     cvtColor( src, src, CV_BGR2GRAY );
     equalizeHist( src, dst );

     namedWindow( source_window, CV_WINDOW_AUTOSIZE );
     namedWindow( equalized_window, CV_WINDOW_AUTOSIZE );

     imshow( source_window, src );
     imshow( equalized_window, dst );

     waitKey(0);

     return 0;
 }

```






