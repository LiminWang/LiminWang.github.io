

# 常用命令
## 打印文件信息

```
$ ffprobe -i input.mp4 -v quiet -of json -show_format -show_streams
$ ffprobe -v quiet -select_streams v -show_frames input.ts -of json
$ ffprobe -v quiet -select_streams v -show_frames -show_entries frame=key_frame,pkt_pts_time,pict_type  input.ts -of json
$ ffprobe -v quiet -show_entries stream=codec_type,start_time,duration input.mp4 -of json
$ ffprobe -show_entries frame_tags=lavfi.ocr.text -f lavfi -i "movie=/home/lmwang/movie/zhebiao.mp4,crop=iw/4:ih/4,ocr=datapath=../3rdparty_img/share/tessdata/:language=bravo" > test.out
$ ffmpeg -y -i /home/lmwang/movie/zhebiao.mp4 -vf "crop=iw/4:ih/4:0:0,ocr=datapath=../3rdparty_img/share/tessdata/:language=bravo,metadata=print:file=result.txt"
$ ffmpeg -y -i /home/lmwang/movie/zhebiao.mp4 -vf "crop=iw/4:ih/4:0:0,ocr=datapath=../3rdparty_img/share/tessdata/:language=bravo,metadata=print:key=lavfi.ocr.text"
-f null -
-f null -
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
$ ffmpeg  -skip_frame nokey  -i input.ts -vf "select='eq(pict_type,PICT_TYPE_I)'"  -vsync vfr thumbnail_%03d.png
$ ffmpeg  -discard nokey  -i input.ts -vf "select='eq(pict_type,PICT_TYPE_I)'" -vsync vfr thumbnail_%03d.png
# keyframes with a radius of 3 seconds of times t = 14s, 107s and 2113s will be # selected
$ ffmpeg -discard nokey -i video.mp4 -q:v 2 -vf select="eq(pict_type\,PICT_TYPE_I)*(lt(abs(t-14),3)+lt(abs(t-107),3)+lt(abs(t-2113),3))" -vsync 0 frame%03d.jpg
```

### 快速截图
```sh
$ ffmpeg -i input.ts -movflags faststart -c:v copy -c:a copy -f mp4 -y mux.mp4
$ ffmpeg -discard nokey -i mux.mp4 -c copy -vsync vfr discard.mp4
$ ffmpeg -skip_frame nokey -ss 00:00:18 -i discard.mp4 -vf "scale=w=240:h=180:flags=fast_bilinear" -vsync vfr frame%04d.png -threads 4
```

### 快速合图
```sh
./ffmpeg -ss 50.058 -t 10 -i "input.mp4" -vf "scale=w=240:h=180:flags=fast_bilinear" -vsync vfr -y frame%04d.png

all_files=`ls frame*`
input_nr=0;
for i in $all_files
do
  input_files="$input_files -i $i"
  let input_nr=$input_nr+1;
done

./ffmpeg $input_files -filter_complex "hstack=inputs=$input_nr" -y big.png
```

### 获取关键帧基本信息
```sh
$ ffmpeg -skip_frame nokey -i input.mp4 -vf showinfo -vsync 0 -f null -
```

### side by side视频比较

```sh
$ ffmpeg -i side1.mp4 -i side2.mp4 -filter_complex "[0:v]setpts=PTS-STARTPTS,
pad=iw*2:ih[bg]; [1:v]setpts=PTS-STARTPTS[fg]; [bg][fg]overlay=w"
side1_by_side2.mp4

$ ffmpeg -i left.mp4 -i right.mp4 -filter_complex \
"[0:v][1:v]hstack=inputs=2[v];[0:a][1:a]amerge[a]" \
-map "[v]" -map "[a]" -ac 2 output.mp4

$ ffmpeg -i left.mp4 -i right.mp4 -filter_complex \
""[0:v]setpts=PTS-STARTPTS[left];[1:v]setpts=PTS-STARTPTS[right];[left][right]hstack=inputs=2[v];[0:a][1:a]amerge[a]" \
-map "[v]" -map "[a]" -ac 2 output.mp4

$ ffmpeg -i top_l.mp4 -i top_r.mp4 -i bottom_l.mp4 -i bottom_r.mp4 -filter_complex \
"[0:v][1:v]hstack[t];[2:v][3:v]hstack[b];[t][b]vstack[v]; \
 [0:a][1:a][2:a][3:a]amerge=inputs=4[a]" \
-map "[v]" -map "[a]" -ac 2 -shortest output.mp4

$ ffplay -f lavfi "movie=left.mp4,scale=iw/2:ih[v0];movie=right.mp4,scale=iw/2:ih[v1];[v0][v1]hstack"
$ ffplay -f lavfi "movie=side_by_side/cctv3.ts[v0];movie=side_by_side/cctv3.ts[v1];[v0][v1]vstack=inputs=2"
```


./ffmpeg -y  -i input.ts -i ./logo.png -filter_complex overlay=50:50:format=yuv420p10  -c:v hevc_videotoolbox ./test.ts

### slideshow
```
$ ffmpeg -framerate 10 -f image2 -i image%d.jpg video.mpg
$ ffmpeg -start_number 126 -i img%03d.png -pix_fmt yuv420p out.mp4
$ cat *.png | ffmpeg -f image2pipe -i - output.mkv
$ ffmpeg -loop 1 -i img.jpg -c:v libx264 -t 30 -pix_fmt yuv420p out.mp4
```

### 音频音柱
```
$ ffmpeg -i /Users/lmwang/Downloads/dongfanghd_audio.ts -filter_complex "showwaves=s=1280x720:mode=line:rate=25,format=yuv420p" ~/Downloads/test.mp4
```

### 音频合成图片
```
$ ffmpeg -y -loop 1 -i ~/Downloads/cctv5.png -i /Users/lmwang/Downloads/dongfanghd_audio.ts -shortest  ~/Downloads/test.ts
$ ffmpeg -y -r 25 -loop 1 -i ./cctv5.png  -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=48000 -c:a mp2  -t 120 output.mp4
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

```
ffmpeg -i ad_640_360_sr.ts -i ad_640_360_lanczos.ts -filter_complex
"[0:v]setpts=PTS-STARTPTS, pad=iw:ih[bg];[1:v]setpts=PTS-STARTPTS[fg];
[bg][fg]overlay=w/2" -vcodec h264 -b:v 25000k ad_merge.ts

ffmpeg -i ad_640_360_sr.ts -i ad_640_360_lanczos.ts -filter_complex
"[0:v]setpts=PTS-STARTPTS,
crop=iw:ih:iw/2:ih,pad=iw:ih[bg];[1:v]setpts=PTS-STARTPTS, crop=iw/2:ih:0:0[fg];
[bg][fg]overlay=0" -vcodec h264 -b:v 25000k ad_merge.ts
```

### LOGO检测和替换
```
$ ffplay -i ~/Movies/zhebiao.mp4 -vf find_rect=logo/detect_1.tif,cover_rect=logo/zhebiao_yuv.jpg:mode=cover
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
$ ffmpeg -i input.ts -vf "delogo=60:30:200:200"  -c:v libx264 -c:a copy -y blur.ts
``

### 叠加logo
ffmpeg -loglevel debug -i /root/420_10bit.ts -i /root/logo.png -filter_complex
"[1:v]scale=3280:2160,format=p010le[logo];[0:v][logo]overlay=x=main_w-100:y=main_h-100,format=p010le"
-c:v hevc_nvenc a.ts


###  psnr和ssim质量比较

```sh
$ ffmpeg -i orig.ts -i ref.ts -lavfi  "ssim=ssim.log;[0:v][1:v]psnr=psnr.log" -y -f rawvideo /dev/null
$ time ./ffmpeg -i xiangcun.mp4 -i h264_qsv_2000K.mp4 -filter_complex "ssim=stats_file=ssim_stats.log" -f null -
$ time ./ffmpeg -i xiangcun.mp4 -i h264_qsv_2000K.mp4 -filter_complex "psnr=stats_file=psnr_stats.log" -f null -

```


### 输出YUV数据

>> 10bit YUV

```sh
./ffmpeg -i UHD_Soccer.ts -an   -c:v rawvideo -pix_fmt yuv420p10le UHD_Soccer_10bit.yuv
```

>> 8bit YUV
```sh
./ffmpeg -i UHD_Soccer.ts -an   -c:v rawvideo -pix_fmt yuv420 UHD_Soccer_8bit.yuv
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

## 显示1x1棋盘效应效果（有的显示A，有的显示B:
```sh
./ffmpeg -y  -i input1.mp4 -i input2.mp4 -filter_complex "blend=all_expr='if(eq(mod(X,2),mod(Y,2)),A,B)'" -c:v hevc_videotoolbox  -b:v 15000k  output.mp4
```

### 声音波形图效果
```sh
$ ffmpeg -i input.ts -filter_complex "[0:a]showvolume=f=1:b=4:w=720:h=68,format=yuv420p[vid]" -map "[vid]" -map 0:a -c:v libx264 -preset fast -crf 18 -codec:a copy -strict -2 -b:a 192k audio.mp4 $ ffmpeg -i ~/Downloads/test_norm.ts -filter_complex "[0:a]ahistogram,format=yuv420p[vid]" -map "[vid]" -map 0:a -c:v libx264 -preset fast -crf 18 -codec:a copy -strict -2 -b:a 192k audio.mp4
$ ffmpeg -i input.mp4 -filter_complex
"[0:a]showfreqs=s=640x518:mode=line:fscale=log,pad=1280:720[vs];
[0:a]showspectrum=mode=separate: color=intensity:scale=cbrt:s=640x518[ss];[0:a]showwaves=s=1280x202:mode=line[sw];[vs][ss]overlay=w[bg];[bg][sw]overlay=0:H-h[out]"
-map "[out]" -map 0:a -c:v libx264 -preset fast -crf 18 -c:a copy test.mp4
```

### 查看编码参数

```
$ ffmpeg -h encoder=libx265
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

### 场景切换检测
```
./ffmpeg -i input.ts -vf  "select='gt(scene,0.3)',metadata=print" -pix_fmt yuv420p10 -f null - 2>&1
```

### xavc mxf输出

./ffmpeg -hwaccel qsv -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format
qsv -i 4k_h264_60fps.mp4 -c:v hevc_qsv -b:v 8M -maxrate 8M -load_plugins
6fadc791a0c2eb479ab6dcd5ea9da347 output.mp4

./ffmpeg -hwaccel qsv -hwaccel_device /dev/dri/renderD128 -hwaccel_output_format
qsv -i 4k_h264_60fps.mp4 -c:v hevc_qsv -b:v 8M -maxrate 8M -load_plugin hevc_hw
-init_hw_device qsv:hw -preset fast -profile:v main -an output.mp4

./ffmpeg -codec:v h264_qsv -i 4k_h264_60fps.mp4 -c:v hevc_qsv -b:v 3M -maxrate
3M -look_ahead 0 -load_plugin hevc_hw -init_hw_device qsv:hw -f mpegts /dev/null

./ffmpeg -load_plugin hevc_hw -codec:v hevc_qsv -i UHD_Soccer.ts -f null -


 /opt/bravo/bts/transcoder/objs/ffmpeg -probesize 10000000 -analyzeduration 10000000 -y -hwaccel cuvid -c:v h264_cuvid -gpu 1 -i /root/4K-8m-60.mp4 -filter_complex "scale_npp=w=3840:h=2160:format=yuv420p,hwdownload,format=yuv420p" -c:v hevc_nvenc -preset medium -coder 1 -bf 0 -refs 3 -rc-lookahead 40 -sc_threshold 0 -g 100 -r 50 -aspect 16:9 -b:v 16000k -maxrate:v 16000k  -c:a libfdk_aac -af volume=100/100 -ac 2 -ar 44100 -ab 48k -map 0:v? -map 0:a? -map 0:s? -movflags faststart -f mp4 test.mp4

### HDR10

./ffmpeg_g -y -i 4K.mp4 -c:v hevc_nvenc -preset hq -b:v 20000k -strict_gop 1 -no-scenecut 1 -g 7 \
    -aud 1 -color_primaries bt2020 -colorspace bt2020_ncl -color_trc smpte2084 -sei hdr10  -master_display \
    "G(13250,34500)B(7500,3000)R(34000,16000)WP(15635,16450)L(10000000,50)" -max_cll "0, 0" test.ts

./ffmpeg_g -y -hwaccel cuvid -c:v hevc_cuvid -i 4K.mp4 -c:v hevc_nvenc -preset hq -b:v 20000k -strict_gop 1 -no-scenecut 1 -g 7 \
    -aud 1 -color_primaries bt2020 -colorspace bt2020_ncl -color_trc smpte2084 -sei hdr10  -master_display \
    "G(13250,34500)B(7500,3000)R(34000,16000)WP(15635,16450)L(10000000,50)" -max_cll "0, 0" test.ts

### HLG
./ffmpeg_g -i 420_10bit.ts -c:v hevc_nvenc -preset hq -b:v 20000k -strict_gop 1 -no-scenecut 1 -g 7 \
    -aud 1 -color_primaries bt2020 -colorspace bt2020_ncl -color_trc arib-std-b67  -sei hlg test.ts

### decklink采集卡测试
./ffmpeg -y -raw_format yuv422p10 -format_code 4k59 -f decklink \
-i 'DeckLink 8K Pro (1)' -vf \
scale=3840x2160:flags=fast_bilinear,format=pix_fmts=yuv420p \
-codec:v nvenc_hevc -ac 2 -acodec libfdk_aac -ar 44100 -ab 48k -f mpegts /dev/null

./ffmpeg -y -raw_format yuv422p10 -format_code 4k59 -f decklink \
-i 'DeckLink 8K Pro (1)' -vf \
scale=3840x2160:flags=fast_bilinear,format=pix_fmts=p010le \
-codec:v nvenc_hevc -ac 2 -acodec libfdk_aac -ar 44100 -ab 48k -f mpegts /dev/null

# FFmpeg resource
* [Create a mosaic out of several input videos](https://trac.ffmpeg.org/wiki/Create%20a%20mosaic%20out%20of%20several%20input%20videos)
* 

