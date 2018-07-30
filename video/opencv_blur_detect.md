
# 检测图片是否模糊

```
bool isImageBlurry(cv::Mat& img)
{
    cv::Mat matImageGray;

    // converting image's color space (RGB) to grayscale
    cv::cvtColor(img, matImageGray, CV_BGR2GRAY);
    cv::Mat dst, abs_dst;
        cv::Laplacian(matImageGray, dst, CV_16S, 3);
        cv::convertScaleAbs( dst, abs_dst );
    cv::Mat tmp_m, tmp_sd;  
    double m = 0, sd = 0;  
    int threshold = 1000;
    cv::meanStdDev(dst, tmp_m, tmp_sd);  
    m = tmp_m.at<double>(0,0);  
    sd = tmp_sd.at<double>(0,0);  
    std::cout << "StdDev: " << sd * sd << std::endl; 
    return ((sd * sd) <= threshold);
}
```
