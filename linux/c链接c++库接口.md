# c程序链接C++库接口

# 用nm可以查看符号表，会发现定义的接口前面加了符号


# 需要在c++文件头加上如下的标示

/* c++ header */
#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

my_lib_init()
my_lib_close()

#ifdef __cplusplus
}
#endif /* __cplusplus */


