

# 常用命令
## 打印文件信息

```
$ ffprobe -i input.mp4 -v quiet -of json -show_format -show_streams
```

## 截图
### 截取一帧
* 命令
```
$ ffmpeg -i input.mp4 -ss 00:00:18.123 -f image2 -vframes 1 thumbmail.png
```

* -ss: 开始时间偏移, 需要解码直到设置的时间点，速度会比较慢，如果放在-i前面，seek速度会快，但位置不是非常精确
* -vframes: 视频的帧数


### 10秒截取一帧

```sh
$ ffmpeg -i input.mp4 -f image2 -vf fps=fps=1/10 thumbnail_%3d.png
```

### i-frame截图
```sh
$ ffmpeg -i input.mp4 -f image2 -vf "select='eq(pict_type,PICT_TYPE_I)'" -vsync vfr thumbnail_%03d.png
```

### side by side视频比较

```sh
$ ffmpeg -i side1.mp4 -i side2.mp4 -filter_complex "[0:v]setpts=PTS-STARTPTS,
pad=iw*2:ih[bg]; [1:v]setpts=PTS-STARTPTS[fg]; [bg][fg]overlay=w"
side1_by_side2.mp4
```

### 马赛克
```sh
$ ffmpeg -i input.mp4 -vf select='gt(scene\,0.4)',scale=160:120,tile -frames:v 1 mosaic_preview.png
$ $ ffmpeg -i input.mp4 -frames 1 -vf "select=not(mod(n\,500)),scale=160:120,tile=4x3" tile.png
```

### 视频稳定(类似相机硬件防抖动）
* build
1. ffmpeg编译需要打开下面选项:
--enable-libvidstab

2. build vid.stab

```sh
git clone https://github.com/georgmartius/vid.stab.git
cd vid.stab/
cmake .
make -j4
sudo checkinstall
```

* default option
```sh
$ ffmpeg -i input.mp4 -vf vidstabtransform,unsharp=5:5:0.8:3:3:0.4 output.mp4
```

* analysis first 
1. Analyze with default values:

```sh
$ ffmpeg -i input.mp4 -vf vidstabdetect -f null -
# Or analyze a very shaky video, on a scale of 1-10:
$ ffmpeg -i input.mp4 -vf vidstabdetect=shakiness=10:accuracy=15 -f null -
```

2. use that generated file transform.trf to help better stabilize the video:

```sh
ffmpeg -i input.mp4 -vf vidstabtransform=smoothing=30:input="transforms.trf"
output.mp4
```


# FFmpeg resource
* [Create a mosaic out of several input videos](https://trac.ffmpeg.org/wiki/Create%20a%20mosaic%20out%20of%20several%20input%20videos)
* 
