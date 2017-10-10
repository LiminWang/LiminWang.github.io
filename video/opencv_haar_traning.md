# opencv haar训练模型

# 测试训练素材(cars)

http://cogcomp.cs.illinois.edu/Data/Car/


# 训练方法
## Train your own OpenCV Haar classifier
* 工具
https://github.com/mrnugget/opencv-haar-classifier-training

* 步骤

```sh
find ./positive_images -iname "*.pgm" > positives.txt
find ./negative_images -iname "*.pgm" > negatives.txt

perl bin/createsamples.pl positives.txt negatives.txt samples 550\
  "opencv_createsamples -bgcolor 0 -bgthresh 0 -maxxangle 1.1\
  -maxyangle 1.1 maxzangle 0.5 -maxidev 40 -w 48 -h 24"

python ./tools/mergevec.py -v samples/ -o samples.vec

opencv_traincascade -data classifier -vec samples.vec -bg negatives.txt\
  -numStages 10 -minHitRate 0.999 -maxFalseAlarmRate 0.5 -numPos 1000\
  -numNeg 600 -w 48 -h 24 -mode ALL -precalcValBufSize 1024\
  -precalcIdxBufSize 1024
```

## OpenCV自带的方法 
### 步骤
* Downloaded the dataset & saved the positive images in a pos folder and the negative images in a neg folder

```
wget http://l2r.cs.uiuc.edu/~cogcomp/Data/Car/CarData.tar.gz
tar jxvf CarData.tar.gz
mkdir -p pos
cp CarData/TrainImages/pos-* pos
mkdir -p neg
cp CarData/TrainImages/neg-* neg
```

* generated a txt file for the positive images

```sh
find pos -iname "*.pgm" > cars.txt 
sed -i '' 's/.pgm/.pgm 1 0 0 100 40/g' cars.txt 
```

* generated a txt file for the negative images

```sh
find neg -iname "*.pgm" > bg.txt
```

* generated a vec file from cars.txt

```sh
opencv_createsamples -info cars.txt -num 550 -w 48 -h 24 -vec cars.vec
```

* train cascade

```sh
mkdir data
opencv_traincascade -data data -vec cars.vec -bg bg.txt \
 -numPos 500 -numNeg 500 -numStages 10 -w 48 -h 24 -featureType LBP
```



