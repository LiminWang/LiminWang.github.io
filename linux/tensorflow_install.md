# tensorflow C++ API的使用

## 官方推荐编译方式
TensorFlow官方推荐使用Bazel编译源码和安装
[参考链接](https://www.tensorflow.org/install/install_sources)


## C++静态编译
## Ubuntu 16.04
```
$ sudo apt-get install autoconf automake libtool curl make g++ unzip zlib1g-dev git python
$ git clone https://github.com/tensorflow/tensorflow
$ cd tensorflow
$ git checkout r1.4
$ ./tensorflow/contrib/makefile/download_dependencies.sh
$ ./tensorflow/contrib/makefile/build_all_linux.sh
```

## Centos 7.2

```
$ sudo yum install autoconf automake libtool curl make g++ unzip zlib1g-dev git python
$ git clone https://github.com/tensorflow/tensorflow
$ cd tensorflow
$ git checkout r1.4
$ ./tensorflow/contrib/makefile/download_dependencies.sh
$ ./tensorflow/contrib/makefile/build_all_linux.sh
```

## 编译成功

### 静态库路径
```
tensorflow/tensorflow/contrib/makefile/gen/lib/libtensorflow-core.a
```

### 静态库开发

TensorFlow的头文件和静态库做开发，tensorflow/tensorflow/contrib/makefile目录下的几个目录需要注意：
* downloads 存放第三方依赖的一些头文件和静态库，比如nsync、Eigen等
* gen 存放TensorFlow生成的C++ PB头文件、TensorFlow的静态库、ProtoBuf的头文件和静态库等等


## 使用TensorFlow C++ API编写预测代码

### 例子程序
```
完整的代码在https://github.com/formath/tensorflow-predictor-cpp，路径为
src/simple_model.cc
```

### 预测代码主要包括以下几个步骤：
* 创建Session
```
Session* session;
Status status = NewSession(SessionOptions(), &session);
if (!status.ok()) {
      std::cout << status.ToString() << std::endl;
} else {
      std::cout << "Session created successfully" << std::endl;
}
```

* 导入之前生成的模型

```
GraphDef graph_def;
Status status = ReadBinaryProto(Env::Default(), "../demo/simple_model/graph.pb",
&graph_def);
if (!status.ok()) {
      std::cout << status.ToString() << std::endl;
} else {
      std::cout << "Load graph protobuf successfully" << std::endl;
}


* 将模型设置到创建的Session里
```
Status status = session->Create(graph_def);
if (!status.ok()) {
      std::cout << status.ToString() << std::endl;
} else {
      std::cout << "Add graph to session successfully" << std::endl;
}
```

* 设置模型输入输出
```
Tensor a(DT_FLOAT, TensorShape()); // input a
a.scalar<float>()() = 3.0;
Tensor b(DT_FLOAT, TensorShape()); // input b
b.scalar<float>()() = 2.0;
```

* 预测
```
std::vector<std::pair<string, tensorflow::Tensor>> inputs = {
      { "a", a },
        { "b", b },
}; // input
std::vector<tensorflow::Tensor> outputs; // output
Statuc status = session->Run(inputs, {"c"}, {}, &outputs);
if (!status.ok()) {
      std::cout << status.ToString() << std::endl;
} else {
      std::cout << "Run session successfully" << std::endl;
}
```

* 查看预测结果
```
uto c = outputs[0].scalar<float>();
std::cout << "output value: " << c() << std::endl;
```

* 关闭Session
```
session->Close();
```

## 构建C++代码
### 头文件路径
```
tensorflow/tensorflow/contrib/makefile/gen/proto // TensorFlow PB文件生成的pb.h
头文件
tensorflow/tensorflow/contrib/makefile/gen/protobuf-host/include // ProtoBuf头文
件
tensorflow/tensorflow/contrib/makefile/downloads/eigen // eigen头文件
tensorflow/tensorflow/contrib/makefile/downloads/nsync/public // nsync头文件
```

### 静态库
```
./tensorflow/tensorflow/contrib/makefile/gen/lib // TensorFlow静态库
./tensorflow/tensorflow/contrib/makefile/gen/protobuf-host/lib // protobuf静态库
./tensorflow/tensorflow/contrib/makefile/downloads/nsync/builds/default.macos.c++11 // nsync静态库
```

libtensorflow-core.a libprotobuf.a libnsync.a
其他: pthread m z

### CMake构建
```
git clone https://github.com/formath/tensorflow-predictor-cpp.git
cd tensorflow-predictor-cpp
mkdir build && cd build
cmake ..
make
构建完成后在bin路径下会看到一个simple_model可执行文件，运行./simple_model即可看到输出
```


