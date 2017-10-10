# mac下编译cmake依赖qt库出错解决方案


* 使用qt的项目

* [plate_tagger](https://github.com/openalpr/plate_tagger)
* mkdir build && cd build && cmake ..

```
  Could not find a package configuration file provided by "Qt5Widgets" with
  any of the following names:

    Qt5WidgetsConfig.cmake
    qt5widgets-config.cmake
```

* brew查找qt5路径

```sh
brew info qt5
```

* cmake输入qt路径
```sh
 mkdir build && cd build && cmake .. -DCMAKE_PREFIX_PATH=/usr/local/opt/qt
 ````



