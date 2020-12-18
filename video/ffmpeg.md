

# 常用命令
## 打印文件信息

```
$ ffprobe -i input.mp4 -v quiet -of json -show_format -show_streams
$ ffprobe -v quiet -select_streams v -show_frames input.ts -of json
$ ffprobe -v quiet -select_streams v -show_frames -show_entries frame=key_frame,pkt_pts_time,pict_type  input.ts -of json
$ ffprobe -select_streams v -skip_frame nokey -show_frames -show_entries frame=pkt_pts_time,pkt_duration_time,pkt_pos -v quiet input.ts -threads 0 -of compact | cut -d '|' -f 2
$ ffprobe -v quiet -show_entries stream=codec_type,start_time,duration input.mp4 -of json
$ ffprobe -show_entries frame_tags=lavfi.ocr.text -f lavfi -i "movie=/home/lmwang/movie/zhebiao.mp4,crop=iw/4:ih/4,ocr=datapath=../3rdparty_img/share/tessdata/:language=bravo" > test.out
$ ffmpeg -y -i /home/lmwang/movie/zhebiao.mp4 -vf "crop=iw/4:ih/4:0:0,ocr=datapath=../3rdparty_img/share/tessdata/:language=bravo,metadata=print:file=result.txt"
$ ffmpeg -y -i /home/lmwang/movie/zhebiao.mp4 -vf "crop=iw/4:ih/4:0:0,ocr=datapath=../3rdparty_img/share/tessdata/:language=bravo,metadata=print:key=lavfi.ocr.text" -f null -

```

## 关键帧间隔
```
$ ffprobe -show_frames -select_streams v:0 -print_format csv ./test_gop.ts 2> /dev/null | awk -F ',' '{ if ($4 > 0) print NR; }'
```

## NDI
```
./ffmpeg -i ~/Downloads/input.mkv -f libndi_newtek -clock_video true -clock_audio true -pix_fmt uyvy422 "OUTPUT"
./ffmpeg -f libndi_newtek -find_sources 1 -i dummy
./ffplay -f libndi_newtek -i "MACBOOK.LOCAL (OUTPUT)"
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

```
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
```
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

```
$ ffmpeg -i side1.mp4 -i side2.mp4 -filter_complex "[0:v]setpts=PTS-STARTPTS,
pad=iw*2:ih[bg]; [1:v]setpts=PTS-STARTPTS[fg]; [bg][fg]overlay=w"
side1_by_side2.mp4

$ ffmpeg -i left.mp4 -i right.mp4 -filter_complex \
"[0:v][1:v]hstack=inputs=2[v];[0:a][1:a]amerge[a]" \
-map "[v]" -map "[a]" -ac 2 output.mp4

 >>> left half video side by side

 ./ffmpeg -i ~/Movies/sr_source/src.ts -i ~/Movies/sr_source/ds_sr_4k.ts -filter_complex \
 "[0:v]setpts=PTS-STARTPTS,scale=3840x2160,crop=iw/2:ih:0:0[left];[1:v]setpts=PTS-STARTPTS,crop=iw/2:ih:0:0[right];[left][right]hstack=inputs=2[v];[0:a][1:a]amerge[a]" \
 -map "[v]" -map "[a]" -ac 2 output.mp4

 >>> right half video side by side
./ffmpeg -i ~/Movies/sr_source/src.ts -i ~/Movies/sr_source/ds_sr_4k.ts -filter_complex \
 "[0:v]setpts=PTS-STARTPTS,scale=3840x2160,crop=iw/2:ih:iw/2:ih[left];[1:v]setpts=PTS-STARTPTS,crop=iw/2:ih:iw/2:ih[right];[left][right]hstack=inputs=2[v];[0:a][1:a]amerge[a]" \
 -map "[v]" -map "[a]" -ac 2 output.ts


$ ffmpeg -i left.mp4 -i right.mp4 -filter_complex \
""[0:v]setpts=PTS-STARTPTS[left];[1:v]setpts=PTS-STARTPTS[right];[left][right]hstack=inputs=2[v];[0:a][1:a]amerge[a]" \
-map "[v]" -map "[a]" -ac 2 output.mp4

$ ./ffplay  -fflags nobuffer  -protocol_whitelist rtp,udp,file -f lavfi  "movie=filename='1_4.sdp'\:s='v\:0\+v\:1+v\:2\+v\:3+a\:0'[a][b][c][d][out1];[a][b][c][d]xstack=inputs=4:layout=0_0|0_h0|w0_0|w0_h0[out0]"

$ ffmpeg -i top_l.mp4 -i top_r.mp4 -i bottom_l.mp4 -i bottom_r.mp4 -filter_complex \
"[0:v][1:v]hstack[t];[2:v][3:v]hstack[b];[t][b]vstack[v]; \
 [0:a][1:a][2:a][3:a]amerge=inputs=4[a]" \
-map "[v]" -map "[a]" -ac 2 -shortest output.mp4

$ ffplay -f lavfi "movie=left.mp4,scale=iw/2:ih[v0];movie=right.mp4,scale=iw/2:ih[v1];[v0][v1]hstack"
$ ffplay -f lavfi "movie=side_by_side/cctv3.ts[v0];movie=side_by_side/cctv3.ts[v1];[v0][v1]vstack=inputs=2"
$ ./ffplay -i ~/Movies/2.mkv -vf "split[a][b],[b]colordetect,eq=eval=frame[c],[a][c]hstack=2"
./ffplay -i ~/Movies/2.mkv -sws_flags full_chroma_int+accurate_rnd+bicubic -vf "split[a][b],[a]crop=iw/2:ih:0:0[d],[b]colorstats,metadata=mode=print,eq=eval=frame,colorstats,metadata=mode=print,crop=iw/2:ih:iw/2:0[c],[d][c]hstack=2"
```

### 自动测试源

./ffplay -f lavfi -i "smptebars=duration=5:size=1280x720:rate=30"
./ffplay -f lavfi -i "testsrc=duration=10:size=1280x720:rate=30"
./ffmpeg -f lavfi -i testsrc=duration=10:size=1280x720:rate=30 test.mp4


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

### 字幕硬叠加到视频
‘’‘
./ffmpeg -i ~/Downloads/multiaudioandsubtitles_4sub.ts -filter_complex '[0:5] setpts=PTS+1/TB [sub];[0:0] [sub] overlay' -sn -map 0:1 out.mp4
···


## subtitle copy
```
./ffmpeg -i ~/Movies/720p-h264-23.97fps-8bits-420-SDR-4M-4min36sec-2audio-2subtitle.mkv  -map 0:v -map 0:a -map 0:s:0 -map 0:s:1 -c:v copy -c:a copy -c:s srt -disposition:s:0 forced -metadata:s:s:0 language=chi -metadata:s:s:0 title="Chinese" -metadata:s:s:1 language=eng -metadata:s:s:1 title="English"   ~/Movies/test.mkv

./ffmpeg -i ~/Movies/720p-h264-23.97fps-8bits-420-SDR-4M-4min36sec-2audio-2subtitle.mkv  -map 0:v -map 0:a -map 0:s:0 -map 0:s:1 -c:v copy -c:a copy -c:s mov_text -disposition:s:0 forced -metadata:s:s:0 language=chi -metadata:s:s:0 title="Chinese" -metadata:s:s:1 language=eng -metadata:s:s:1 title="English"   ~/Movies/test.mp4
```

### readvitc
```
./ffplay -vf "readvitc=scan_max=30,readeia608=scan_max=30,crop=iw:30:0:0,scale=720:480:flags=neighbor,setdar=4/3,drawtext=fontfile=/Library/Fonts/Courier\ New.ttf:fontcolor=white:fontsize=36:box=1:boxcolor=black@0.5:x=(w-tw)/2:y=h*3/4-ascent:text=VITC %{metadata\\\:lavfi.readvitc.tc_str\\\:-- -- -- --},drawtext=fontfile=/Library/Fonts/Courier\ New.ttf:fontcolor=white:fontsize=36:box=1:boxcolor=black@0.5:x=(w-tw)/2:y=400-ascent:text=Line %{metadata\\\:lavfi.readeia608.0.line\\\:-} %{metadata\\\:lavfi.readeia608.0.cc\\\:------} - Line %{metadata\\\:lavfi.readeia608.1.line\\\:-} %{metadata\\\:lavfi.readeia608.1.cc\\\:------}" ~/Movies/mpeg2_cc.ts
```

### 同步测试
./ffplay  -f lavfi "movie=filename='http\://192.168.1.187\:8080/huawei/1080p-1.m3u8',drawtext=fontfile=/System/Library/Fonts/ArialHB.ttc:fontsize=48:fontcolor=white:text=\\'%{pts\:hms}\,%{metadata\\:timecode}\\'[a];movie=filename='http\://192.168.1.187\:8080/huawei/1080p-2.m3u8',drawtext=fontfile=/System/Library/Fonts/ArialHB.ttc:fontsize=48:fontcolor=white:text=\\'%{pts\: hms}\,%{metadata\\:timecode}\\'[b];[a][b]hstack"

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

### LOGO分段叠加
```
./ffmpeg -i input.mp4 -i logo1.png -i logo2.png -i logo3.png -filter_complex "[1:v]scale=240:120[logo1],[2:v]scale=240:120[logo2],[3:v]scale=240:120[logo3],[0:v][logo1]overlay=100:100:enable='between(t,5,25)':eof_action=repeat[out0],[out0][logo2]overlay=100:100:enable='between(t,20,35)':eof_action=pass[out1],[out1][logo3]overlay=50:50:enable='gte(t,0)':eof_action=repeat" output.mp4
```

### OCR text
* build ffmpeg --with-tesseract

```
$ ffprobe -show_entries frame_tags=lavfi.ocr.text -f lavfi -i "movie=img.png,ocr" 
4 ffprobe -f lavfi -i "movie=input.mov,ocr" -show_entries frame=pkt_dts_time:frame_tags=lavfi.ocr.text -of json
```

### 区域模糊

```sh
$ ffmpeg -i input.ts -filter_complex "[0:v]crop=200:200:60:30,boxblur=2[fg];[0:v][fg]overlay=60:30[v]" -map "[v]"
    -map 0:a -c:v libx264 -c:a copy blur.ts
$ ffmpeg -i input.ts -vf "delogo=60:30:200:200"  -c:v libx264 -c:a copy -y blur.ts
```

### 叠加logo
```
ffmpeg -loglevel debug -i /root/420_10bit.ts -i /root/logo.png -filter_complex
"[1:v]scale=3280:2160,format=p010le[logo];[0:v][logo]overlay=x=main_w-100:y=main_h-100,format=p010le"
-c:v hevc_nvenc a.ts
```


###  psnr和ssim质量比较
```
$ ffmpeg -i orig.ts -i ref.ts -lavfi  "ssim=ssim.log;[0:v][1:v]psnr=psnr.log" -y -f rawvideo /dev/null
$ time ./ffmpeg -i xiangcun.mp4 -i h264_qsv_2000K.mp4 -filter_complex "ssim=stats_file=ssim_stats.log" -f null -
$ time ./ffmpeg -i xiangcun.mp4 -i h264_qsv_2000K.mp4 -filter_complex "psnr=stats_file=psnr_stats.log" -f null -
$ ./ffmpeg -i ref.mp4  -i cmp.mp4 -filter_complex "[0:v]scale=1920x1080:flags=bicubic[main];[main][1:v]libvmaf=model_path=./model/vmaf_v0.6.1.pkl:pool=mean:log_path=vmaf.log:shortest=1" -shortest -f null -


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

### 视频加入静音数据
```
$ ffmpeg -i video.mp4 -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=44100 \
-c:v copy -shortest output.mp4
```

### 静音检测

```
./ffprobe -of  compact=p=0 -show_entries frame=pkt_pts:frame_tags -bitexact -f lavfi \
"amovie=../fate-suite/lossless-audio/inside.tta,silencedetect=n=-33.5dB"
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

## 场景切换
```sh
./ffprobe -show_frames -of compact=p=0 -f lavfi "movie=fate-suite/svq3/Vertical400kbit.sorenson3.mov,select=gt(scene\,.4)"
```

### freezedetect
```
./ffprobe -of compact=p=0 -show_entries frame=pkt_pts:frame_tags -bitexact -f lavfi -f lavfi "mptestsrc=r=25:d=10:m=51,freezedetect"
```

### 声音波形图效果
```sh
$ ffmpeg -i input.ts -filter_complex "[0:a]showvolume=f=1:b=4:w=720:h=68,format=yuv420p[vid]" -map "[vid]" -map 0:a -c:v libx264 -preset fast -crf 18 -codec:a copy -strict -2 -b:a 192k audio.mp4 $ ffmpeg -i ~/Downloads/test_norm.ts -filter_complex "[0:a]ahistogram,format=yuv420p[vid]" -map "[vid]" -map 0:a -c:v libx264 -preset fast -crf 18 -codec:a copy -strict -2 -b:a 192k audio.mp4
$ ffmpeg -i input.mp4 -filter_complex
"[0:a]showfreqs=s=640x518:mode=line:fscale=log,pad=1280:720[vs];
[0:a]showspectrum=mode=separate: color=intensity:scale=cbrt:s=640x518[ss];[0:a]showwaves=s=1280x202:mode=line[sw];[vs][ss]overlay=w[bg];[bg][sw]overlay=0:H-h[out]"
-map "[out]" -map 0:a -c:v libx264 -preset fast -crf 18 -c:a copy test.mp4
```

### hdr2sdr
```
./ffmpeg -y -i hdr.ts -vf scale=-1:-1:in_color_matrix=bt2020,format=rgb48,lut3d=./8a_hlg_bt709.cube,scale=-1:-1:out_color_matrix=bt709:nb_threads=12,format=yuv420p -c:v libsvt_hevc -color_primaries bt709 -colorspace bt709 -color_trc bt709 -b:v 15000k sdr.ts
```

### sdr2hdr
```
./ffmpeg -y -vf asr2=2,lut3d=./3a_bt709_hlg.cube,scale=in_range=tv:out_range=tv:in_color_matrix=bt709:out_color_matrix=bt2020ncl -c:v hevc_nvenc -pix_fmt yuv420p10 -color_primaries bt2020 -colorspace  bt2020_ncl  -color_trc arib-std-b67  -sei hlg -preset medium -coder 1 -bf 0 -refs 3 -rc-lookahead 40 -sc_threshold 0 -g 7 -r 25 -aspect 16:9 -b:v 30000k -maxrate:v 35000k -c:a libfdk_aac -af volume=100/100  -ac 2 -ar 48000 -ab 192k

./ffmpeg -f lavfi  -i color=white:duration=1:r=1:size=1280x720,colordetect,metadata=mode=print,lut3d=lut/4b.cube,colordetect,metadata=mode=print
```

### 查看rgb color level
```
./ffplay -i histogram_source.jpg -vf format=rgb24,waveform=c=7:d=parade,scale=1200x512
```

### 对比质量
./ffplay -i input.mp4 -sws_flags full_chroma_int+accurate_rnd+bicubic -vf "split[a][b],[b]colorstats,metadata=mode=print,eq=eval=frame,colorstats,metadata=mode=print[c],[a][c]hstack=2"

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

### hls
```
./ffmpeg -threads 4 -vsync 1 -i ~/Movies/input.mp4 -r 25 \
-use_localtime 1 -use_localtime_mkdir 1 -hls_segment_filename \
'%Y%m%d/file-%Y%m%d-%s.ts' ~/Movies/hls/out.m3u8

./ffmpeg -re -i ~/Movies/logo_test/cctv7.ts -c:a copy -c:v libx264 \
 -f hls -hls_time 2 -hls_playlist_type event -master_pl_name \
 index.m3u8 -hls_segment_filename stream_%v/data%06d.ts -use_localtime_mkdir 1 \
 -var_stream_map 'v:0,a:0' stream_%v.m3u8
```

### hls multiple output
```
./ffmpeg -threads 4 -vsync 1 -i ~/Movies/input.mp4 -r 25 \
-b:v:0 5250k -c:v h264 -pix_fmt yuv420p -profile:v main -level 4.1 \
-b:v:1 4200k -c:v h264 -pix_fmt yuv420p -profile:v main -level 4.1 \
-b:v:1 3150k -c:v h264 -pix_fmt yuv420p -profile:v main -level 4.1 \
-b:a:0 256k \
-b:a:0 192k \
-b:a:0 128k \
-c:a aac -ar 48000  -map 0:v -map 0:a:0 -map 0:v -map 0:a:0 -map 0:v -map 0:a:0 \
-f hls -var_stream_map "v:0,a:0  v:1,a:1 v:2,a:2" \
-master_pl_name  master.m3u8 -t 300 -hls_time 10 -hls_init_time 4 -hls_list_size \
10 -master_pl_publish_rate 10 -hls_flags \
delete_segments+discont_start+split_by_time  \
~/Movies/hls/vs%v/manifest.m3u8
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
./ffprobe -of compact=p=0 -show_entries frame=pkt_pts:frame_tags -bitexact -f lavfi \
"sws_flags=+accurate_rnd+bitexact;movie=/Users/lmwang/Movies/Passengers_Breakfast_1080-sdr.mkv,select=gt(scene\,.25)"
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


 /opt/bravo/bts/transcoder/objs/ffmpeg -probesize 10000000 -analyzeduration 10000000 -y -hwaccel cuvid -c:v h264_cuvid \
 -gpu 1 -i /root/4K-8m-60.mp4 -filter_complex "scale_npp=w=3840:h=2160:format=yuv420p,hwdownload,format=yuv420p"
 -c:v hevc_nvenc -preset medium -coder 1 -bf 0 -refs 3 -rc-lookahead 40 -sc_threshold 0 -g 100 -r 50 -aspect 16:9
 -b:v 16000k -maxrate:v 16000k  -c:a libfdk_aac -af volume=100/100 -ac 2 -ar 44100 -ab 48k -map 0:v? -map 0:a? -map 0:s? -movflags faststart -f mp4 test.mp4

### PAL
If it’s PAL chromaticities (=bt470bg), we then need to transcode as follows:
```
$ ffmpeg -i raw.mp4 -color_primaries bt470bg -color_trc gamma28 -colorspace bt470bg -r 25 -crf 18 screen-rec.mp4
```

### NTSC
For NTSC chromaticities (=smpte170m), we’ll need a different set of primaries, transfer curve, and colorspace:
```
$ ffmpeg -i raw.mp4 -color_primaries smpte170m -color_trc smpte170m -colorspace smpte170m -r 25 -crf 18 screen-rec.mp4
```

### HDR10

./ffmpeg_g -y -i 4K.mp4 -c:v hevc_nvenc -preset hq -b:v 20000k -strict_gop 1 -no-scenecut 1 -g 7 \
    -aud 1 -color_primaries bt2020 -colorspace bt2020_ncl -color_trc smpte2084 -sei hdr10  -master_display \
    "G(13250,34500)B(7500,3000)R(34000,16000)WP(15635,16450)L(10000000,50)" -max_cll "0, 0" test.ts

./ffmpeg_g -y -hwaccel cuvid -c:v hevc_cuvid -i 4K.mp4 -c:v hevc_nvenc -preset hq -b:v 20000k -strict_gop 1 -no-scenecut 1 -g 7 \
    -aud 1 -color_primaries bt2020 -colorspace bt2020_ncl -color_trc smpte2084 -sei hdr10  -master_display \
    "G(13250,34500)B(7500,3000)R(34000,16000)WP(15635,16450)L(10000000,50)" -max_cll "0, 0" test.ts

./obj/3rdparty/ffmpeg/ffmpeg-3.4/ffmpeg -i ~/movie/4K_HDR/LG.4K.HDR.Demo.Daylight.mkv  -c:v libsvt_hevc \
    -hdr 1 -master_display "G(13250,34500)B(7500,3000)R(34000,16000)WP(15635,16450)L(10000000,50)" -max_cll "0, 0" test.ts

### HLG
./ffmpeg_g -i 420_10bit.ts -c:v hevc_nvenc -preset hq -b:v 20000k -strict_gop 1 -no-scenecut 1 -g 7 \
    -aud 1 -color_primaries bt2020 -colorspace bt2020_ncl -color_trc arib-std-b67  -sei hlg test.ts

### framecrc
./ffmpeg  -c:v pgmyuv -i /Users/lmwang/Documents/git/build_ffmpeg/build/ffmpeg.git/tests/vsynth1/%02d.pgm \
    -vf interlace=tff,fieldorder=bff -sws_flags +accurate_rnd+bitexact -f framecrc -
./ffmpeg -c:v pgmyuv -i ./tests/vsynth1/%02d.pgm -filter_complex \
"split[main][over];[over]scale=88:72,pad=96:80:4:4[overf];[main][overf]overlay=240:16:format=yuv420" -f framecrc -
make fate-filter-overlay_yuv420 SAMPLES=./fate-suite
./ffmpeg -c:v pgmyuv -i ./tests/vsynth1/%02d.pgm -filter_complex "scale=88:72,pad=96:80:4:4" -f framecrc -

make fate-gifenc-rgb8 SAMPLES=./fate-suite
./ffmpeg -i ./fate-suite/gif/tc217.gif -c:v gif -pix_fmt rgb8 -f framecrc -

fate-filter-overlay_yuv420
fate-gifenc-rgb8
fate-filter-overlay_rgb
fate-filter-fieldorder
fate-filter-lavd-scalenorm
h264-reinit-large_420_8-to-small_420_8
fate-h264-brokensps-2580
./ffmpeg_g -loglevel trace -i ./fate-suite/h264/brokensps.flv -filter_threads 9 -vf format=yuv420p,scale=w=192:h=144 -sws_flags bitexact+bilinear -f framecrc -
./ffmpeg_g -y -i ./fate-suite/h264/reinit-large_420_8-to-small_420_8.h264  -filter_threads 9 -vf format=yuv444p10le,scale=w=352:h=288 -sws_flags bitexact+bilinear -f framecrc -

### MXF
./ffmpeg -i test.mxf -r 50 -c:v libx264 -me_method tesa -subq 9 -partitions all -direct-pred auto -psy 0 -b:v 500M -bufsize 500M -maxrate 500M -minrate 500M -level 5.1 -g 0 -keyint_min 0 -x264opts filler  -x264opts force-cfr -color_primaries bt2020 -colorspace bt2020_ncl -color_trc arib-std-b67 -preset superfast -tune fastdecode -c:a pcm_s24le output.mxf

### decklink采集卡测试
./ffmpeg -sources
./ffmpeg -y -timecode_format rp188any  -f decklink -i 'DeckLink 8K Pro (1)' -vf showinfo -f null -
./ffmpeg -y -raw_format yuv422p10 -format_code 4k59 -f decklink \
-i 'DeckLink 8K Pro (1)' -vf \
scale=3840x2160:flags=fast_bilinear,format=pix_fmts=yuv420p \
-codec:v nvenc_hevc -ac 2 -acodec libfdk_aac -ar 44100 -ab 48k -f mpegts /dev/null

./ffmpeg -y -raw_format yuv422p10 -format_code 4k59 -f decklink \
-i 'DeckLink 8K Pro (1)' -vf \
scale=3840x2160:flags=fast_bilinear,format=pix_fmts=p010le \
-codec:v nvenc_hevc -ac 2 -acodec libfdk_aac -ar 44100 -ab 48k -f mpegts /dev/null

./ffmpeg -r 29.97 -s 1280x720 -pix_fmt nv12 -f avfoundation -i "1:0" -filter_threads 1 -c:v libx265 -threads 1 -trellis 0 -subq 1  -preset ultrafast -tune zerolatency -flags2 local_header -acodec aac -pkt_size 1316 -flush_packets 0 -fflags nobuffer  -b:v 1500k -g 12  -pix_fmt nv12  -f mpegts "srt://192.168.1.82:8080?&send_buffer_size=4096&rcvlatency=0&recv_buffer_size=4096&transtype=live&latency=0&peerlatency=0&rcvlatency=0&streamid=uplive.cybercloud.com.cn/live/test"

./ffplay -analyzeduration 1 -fflags nobuffer -probesize 32  "srt://192.168.1.82:8080?streamid=live.cybercloud.com.cn/live/test"
./ffplay -analyzeduration 1 -fflags nobuffer -probesize 32 "srt://192.168.1.113:8080?streamid=live.cybercloud.com.cn/live/test" \
    -vf drawtext="fontfile=/Library/Fonts/Arial.ttf:fontcolor=white:text=\\'%{metadata\\:timecode}\\'"

# FFmpeg resource
* [Create a mosaic out of several input videos](https://trac.ffmpeg.org/wiki/Create%20a%20mosaic%20out%20of%20several%20input%20videos)
* 

