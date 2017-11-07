

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
### slideshow
```
$ ffmpeg -framerate 10 -f image2 -i image%d.jpg video.mpg
$ ffmpeg -start_number 126 -i img%03d.png -pix_fmt yuv420p out.mp4
$ cat *.png | ffmpeg -f image2pipe -i - output.mkv
$ ffmpeg -loop 1 -i img.jpg -c:v libx264 -t 30 -pix_fmt yuv420p out.mp4
```

### 叠加马赛克

```
$ ffmpeg -i s-0-h-0.mp4 -i s-1-h-0.mp4 -i s-2-h-0.mp4 -i s-3-h-0.mp4 -i s-4-h-0.mp4 -filter_complex "
        nullsrc=size=4240x478 [base];
        [0:v] setpts=PTS-STARTPTS, scale=848x478 [vid1];
        [1:v] setpts=PTS-STARTPTS, scale=848x478 [vid2];
        [2:v] setpts=PTS-STARTPTS, scale=848x478 [vid3];
        [3:v] setpts=PTS-STARTPTS, scale=848x478 [vid4];
        [4:v] setpts=PTS-STARTPTS, scale=848x478 [vid5];
        [base][vid1] overlay=shortest=1 [tmp1];
        [tmp1][vid2] overlay=shortest=1:x=848 [tmp2];
        [tmp2][vid3] overlay=shortest=1:x=1696 [tmp3];
        [tmp3][vid4] overlay=shortest=1:x=2544 [tmp4];
        [tmp4][vid5] overlay=shortest=1:x=3392
    "
   -c:v libx264 output.mkv

$ ffmpeg -i udp://224.0.1.14:5000?fifo_size=100000 -i udp://224.0.1.14:5000?fifo_size=100000 
-i udp://224.0.1.14:5000?fifo_size=100000 -i udp://224.0.1.14:5000?fifo_size=100000 
-filter_complex
"nullsrc=size=1920x1080 [base]; [0:v] setpts=PTS-STARTPTS, scale=960x540
[upperleft]; [1:v] setpts=PTS-STARTPTS, scale=960x540 [upperright]; [2:v]
setpts=PTS-STARTPTS, scale=960x540 [lowerleft]; [3:v] setpts=PTS-STARTPTS,
scale=960x540 [lowerright]; [base][upperleft] overlay=shortest=1 [tmp1];
[tmp1][upperright] overlay=shortest=1:x=960 [tmp2]; [tmp2][lowerleft]
overlay=shortest=1:y=540 [tmp3]; [tmp3][lowerright]
overlay=shortest=1:x=960:y=540" -c:v libx264 -preset ultrafast -f mpegts
udp://224.0.1.15:5000
```

### OCR text
* build ffmpeg --with-tesseract

```sh
$ ffprobe -show_entries frame_tags=lavfi.ocr.text -f lavfi -i "movie=img.png,ocr" 
4 ffprobe -f lavfi -i "movie=input.mov,ocr" -show_entries frame=pkt_dts_time:frame_tags=lavfi.ocr.text -of json
```

### 区域模糊

```sh
$ ffmpeg -i input.ts -filter_complex "[0:v]crop=200:200:60:30,boxblur=2[fg];[0:v][fg]overlay=60:30[v]" -map "[v]"
    -map 0:a -c:v libx264 -c:a copy blur.ts
$ ffmpeg -i input.ts vf "delogo=60:30:200:200"  -c:v libx264 -c:a copy -y blur.ts
``

###  psnr和ssim质量比较

```sh
$ ffmpeg -i orig.ts -i ref.ts -lavfi  "ssim=ssim.log;[0:v][1:v]psnr=psnr.log" -y -f rawvideo /dev/null

```

### 视频信号分析
```sh
ffprobe -f lavfi -i
"movie=mission.mov,signalstats=stat=tout+vrep+brng,cropdetect=reset=1,split[a][b];[a]field=top[a1];[b]field=bottom[b1],[a1][b1]psnr"
-show_frames -show_versions -of xml=x=1:q=1 -noprivate > test.xml
```

### 调整视频速度
```
$ ffmpeg -i input.mkv -filter:v "setpts=0.5*PTS" output.mkv
$ ffmpeg -i input.mkv -filter:v "setpts=2.0*PTS" output.mkv
```

### 视频加入音频
```
$ ffmpeg -i audio.wav -i video_wo_audio.avi video_w_audio.mpg
```

### 马赛克
```sh
$ ffmpeg -i input.mp4 -vf select='gt(scene\,0.4)',scale=160:120,tile -frames:v 1 mosaic_preview.png
$ $ ffmpeg -i input.mp4 -frames 1 -vf "select=not(mod(n\,500)),scale=160:120,tile=4x3" tile.png
```

### 左到右叠加效果

```sh
$ ffmpeg -i input1.mp4 -i input2.jpg -filter_complex "[1] scale=100:100 [tmp];[0][tmp] overlay=x='if(gte(t,2),t*100, 10)':y=30" output.mp4
```

### 声音波形图效果
```sh
$ ffmpeg -i input.ts -filter_complex "[0:a]showvolume=f=1:b=4:w=720:h=68,format=yuv420p[vid]" -map "[vid]" -map 0:a -c:v libx264 -preset fast -crf 18 -codec:a copy -strict -2 -b:a 192k audio.mp4 $ ffmpeg -i ~/Downloads/test_norm.ts -filter_complex "[0:a]ahistogram,format=yuv420p[vid]" -map "[vid]" -map 0:a -c:v libx264 -preset fast -crf 18 -codec:a copy -strict -2 -b:a 192k audio.mp4
$ ffmpeg -i input.mp4 -filter_complex
"[0:a]showfreqs=s=640x518:mode=line:fscale=log,pad=1280:720[vs];
[0:a]showspectrum=mode=separate: color=intensity:scale=cbrt:s=640x518[ss];[0:a]showwaves=s=1280x202:mode=line[sw];[vs][ss]overlay=w[bg];[bg][sw]overlay=0:H-h[out]"
-map "[out]" -map 0:a -c:v libx264 -preset fast -crf 18 -c:a copy test.mp4
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

### 输入测试源生成

```
$ ffmpeg -y -f lavfi -i testsrc -vframes 1 testsrc.png
$ ffmpeg -y -f lavfi -i smptehdbars -vframes 1 smptehdbars.png
$ ffmpeg -f lavfi -i testsrc=duration=60:size=1280x720:rate=25 output.mp4
$ ffmpeg -f lavfi -i "smptebars=duration=5:size=1280x720:rate=30" output.mp4
```

### 分析Motion Vector
```sh
$ ffplay -flags2 +export_mvs input.mp4 -vf codecview=mv=pf+bf+bb
$ ffmpeg -flags2 +export_mvs -i input.mp4 -vf codecview=mv=pf+bf+bb output.mp4
```

### 分析QP量化值
```
$ ffplay -flags2 +export_mvs input.mp4 -vf codecview=mv=pf+bf+bb
$ ffmpeg -flags2 +export_mvs -i input.mp4 -vf codecview=mv=pf+bf+bb output.mp4
```

### 分析宏块类型
```
$ ffplay -debug vis_mb_type input.mp4
$ ffmpeg -debug vis_mb_type -i input.mp4 output.mp4
```

### xavc mxf输出

3rdparty_img/ffmpeg/bin/ffmpeg -loglevel debug  -i
/home/lmwang/movie/TheGreatWall.mpg -s 3840x2160 -r 25 -c:v libx264 -pix_fmt
yuv422p10le -b:v 20M -bufsize 20M -level 5.2 -g 0 -keyint_min 0 -x264-params
nal-hrd=cbr:avcintra-class=200:avcintra-flavour=sony -c:a pcm_s24le test.mxf


# FFmpeg resource
* [Create a mosaic out of several input videos](https://trac.ffmpeg.org/wiki/Create%20a%20mosaic%20out%20of%20several%20input%20videos)
* 
