

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

### 马赛克
```sh
$ ffmpeg -i input.mp4 -vf select='gt(scene\,0.4)',scale=160:120,tile -frames:v 1 mosaic_preview.png
$ $ ffmpeg -i input.mp4 -frames 1 -vf "select=not(mod(n\,500)),scale=160:120,tile=4x3" tile.png
```


# FFmpeg resource
* [Create a mosaic out of several input videos](https://trac.ffmpeg.org/wiki/Create%20a%20mosaic%20out%20of%20several%20input%20videos)
* 
