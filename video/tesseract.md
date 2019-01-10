# tesseract 使用备忘录

tesseract-ocr 光学字符识别 是指对文本资料进行扫描，然后对图像文件进行分析处理，获取文字及版面信息过程。

## tesseract安装(Mac)
* brew cask install xquartz
* brew install tesseract --with-training-tools
* 默认的语言只有eng, osd; 如果需要其他语言包，前面安装tesseract时加--with-all-languanges
* 可以查询安装的语言包： tesseract --list-langs
* 下载[jTessBoxEditor](http://vietocr.sourceforge.net/training.html)做训练, 只依赖java环境
```
  jTessBoxEditorFX$ java -Xms4096m -Xmx4096m -jar jTessBoxEditorFX.jar
```
 * 图像处理中会使用imageMagick(convert)

```
$ brew install imagemagick
```

## training 训练

> 参考：https://www.jianshu.com/p/5f847d8089ce
> 图片预处理用到的知识： https://github.com/tesseract-ocr/tesseract/wiki/ImproveQuality

### 预备知识：
* 在开始准备用于训练的图片之前，建议先看看官方wiki的提高图像质量的说明，重要的几点是：
    *   Tesseract在DPI为至少为300 DPI的图像上效果最佳，所以需要考虑提高图片的DPI，一般图片默认的都是72 
    *  将图像转换为黑白（就是二值化）
    *  消除噪点（就是降低干扰）
    *  旋转（就是将文字尽量水平）
    *  移除不必要的边界（就是要适当裁剪图片）

### 准备图片
可以结合快捷键截图，使用MAC自动预览，黏贴, 再导出tif文件, 如果png转换，使用下面命令

```
$ convert *.png -density 300 img-%d.png
$ convert *.png img-%d.tif
```

### 开始训练
* 菜单栏选择：Tools-Merge TIFF
* 选择自己前面生成的几个.tif文件，打开，另存为lang.fontname.exp0.tif

```
文件命名规则：
[lang].[fontname].exp[num].tif
lang--语言的名称， -l 时指定用的
fontname--字体名称
exp[num]--是用来支持增量训练的，可以不断累积训练
比如现在叫lang.fontname.exp0.tif， 以后可以再来个lang.fontname.exp1.tif
lang.fontname.exp2.tif
。。。
```

* 生成.box文件

```
tesseract lang.fontname.exp0.tif lang.fontname.exp0 batch.nochop makebox
如果有多个,可以：
tesseract lang.fontname.exp1.tif lang.fontname.exp1 batch.nochop makebox
```

> 可以先执行下训练命令，测试下训练有没有问题

```
tesseract lang.fontname.exp0.tif lang.fontname.exp0 box.train
生成xxx.tr文件，即表示可以训练，删除xxx.tr即可。
```

* 校正.tif .box文件
    * 启动jTessBoxEditor.jar,菜单栏第二排选择Box Editor,然后选择Open，打开lang.fontname.exp0.tif; 
看Box Coordinates中识别出的字符有无问题，有问题就校正下坐标，可以在Box View中细调
    * 全部修改完成后，save

* 开始训练

```
tesseract lang.fontname.exp0.tif lang.fontname.exp0 box.train
生成lang.fontname.exp0.tr文件
```

* 生成unicharset文件

```
NOTE: The unicharset file must be regenerated whenever inttemp, normproto and pffmtable are generated (i.e. they must all be recreated when the box file is changed) as they have to be in sync.

unicharset_extractor lang.fontname.exp0.box
生成一个unicharset文件
```

* set_unicharset_properties
 
```
官方Wiki说的是还有这一步，但是不知道是不是一定要通过源码编译才有，反正我是没找到，这一步就忽略了。
training/set_unicharset_properties -U input_unicharset -O output_unicharset --script_dir=training/langdata

```

* 定义font_properties文件
    * 在当前训练的文件夹中，新建font_properties文件，输入 font 0 0 0 0 0
    * 保存退出
    * 文件名不要自己发挥，只能是这个名字
    * font_properties文件的目的是提供字体样式信息，当字体被识别时将显示在输出中

* clustering 聚类
    * 官方提供了3个步骤，shapeclustering mftraining 和 cntraining
    * shapeclustering 的说明是 should not normally be used except for the Indic languages 所以，不是印度语，千万千万不要执行，否则你就会发现识别的全是错误的 。
    
    ```
    mftraining -F font_properties -U unicharset -O num.unicharset lang.fontname.exp0.tr
    cntraining lang.fontname.exp0.tr
    ``` 

* 合并文件
    * 把聚类生成的shapetable，normproto，inttemp，pffmtable几个文件改成用lang.前缀重命名(num. shapetable)
    
    ```
    mv inttemp num.inttemp
    mv normproto num.normproto
    mv pffmtable num.pffmtable
    mv shapetable num.shapetable
    
    combine_tessdata num.
    ```
    
    * 生成num.traineddata 并且打印的结果中Offset 1、3、4、5、13 这些项不是 -1 方可；将num.traineddata拷贝到/usr/local/Cellar/tesseract/3.05.01/share/tessdata下，tesseract --list-langs就会显示可用的num语言包
            

