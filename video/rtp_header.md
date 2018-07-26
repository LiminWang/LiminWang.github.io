
# rtp header

```
   0               1               2               3
   0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 7
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |V=2|P|X| CC   |M|     PT      |       sequence number          |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                           timestamp                           |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |           synchronization source (SSRC) identifier            |
   +=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
   |            contributing source (CSRC) identifiers             |
   |                             ....                              |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

- version (V): 2 bits
    标明RTP版本号。协议初始版本为0，RFC3550中规定的版本号为2。

- padding (P): 1 bit  
    如果该位被设置，则在该packet末尾包含了额外的附加信息，附加信息的最后一个
字节表示额外附加信息的长度（包含该字节本身）。该字段之所以存在是因为一些
加密机制需要固定长度的数据块，或者为了在一个底层协议数据单元中传输多个RTP
packets。

- extension (X): 1 bit
    如果该位被设置，则在固定的头部后存在一个扩展头部，格式定义在RFC3550 5.3.1节。

- CSRC count (CC): 4 bits
    在固定头部后存在多少个CSRC标记。

- marker (M): 1 bit
    该位的功能依赖于profile的定义。profile可以改变该位的长度，但是要保持marker和payload type总长度不变（一共是8 bit）。
   
- payload type (PT): 7 bits
    标记着RTP packet所携带信息的类型，标准类型列出在RFC3551中。如果接收方不能识别该类型，必须忽略该packet。

- sequence number: 16 bits
    序列号，每个RTP packet发送后该序列号加1，接收方可以根据该序列号重新排列数据包顺序。

- timestamp: 32 bits
    时间戳。反映RTP packet所携带信息包中第一个字节的采样时间。

- SSRC: 32 bits
    标识数据源。在一个RTP Session其间每个数据流都应该有一个不同的SSRC。

- CSRC list: 0 to 15 items, 32 bits each
    标识贡献的数据源。只有存在Mixer的时候才有效。如一个将多声道的语音流合并成一个单声道的语音流，在这里就列出原来每个声道的SSRC。

# 抓包分析
* 打开wireshark抓包工具，抓取所有UDP包(一般的RTP都基于UDP发送)
* 解析RTP包，选取其中一个要解析的UDP包，右键Decode as, 协议选择RTP
* 重新分析



