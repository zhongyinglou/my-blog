 

##  前期分析

 

1. 病毒程序

 

  此次分析的样本是一款结合键盘监听和远程监控的木马,启动之后可以伪装成某热门IM 软件,并且能够长期驻留在系统中.骇客利用钓鱼邮件和传输捆绑文件来传播该木马,一旦感染比较难完全修复.

 

木马采用试卷作为文件名和.pif 后缀来迷惑用户点击.

 

![图片](pic_temp6\psb1.png)

 

  木马作者使用MFC 来编写外壳程序,使得寻找病毒真实入口点的难度增大,但是可以从LoadLibrary 的交叉调用寻找到加载主要病毒代码的位置.

 

![图片](pic_temp6\psb2.png)

 

2. 病毒脱壳过程

 

  木马程序为了逃过特征码免杀,把主体代码保存在数组中,然后通过解密和加载把主体代码加载到0x10000000 中

 

![图片](pic_temp6\psb3.png)

 

  跟踪程序到call [ebp+var_8] 之后,F7 步进到程序入口点,到达主体代码入口点0x1000C070,然后利用OD 的备份功能把该主体代码Dump 下来,结果是Dump 失败(已经尝试了几种办法,还是不能够直接Dump 内存).

 

![图片](pic_temp6\psb4.png)

 

  于是直接到解密后的地址把代码Dump 下来,发现这是一个伪装成UPX 的ACProtect 壳.脱去之后,利用字符串导出工具了解到一些有趣的信息.

 

![图片](pic_temp6\psb5.png)

 

![图片](pic_temp6\psb6.png)

 

##  文件行为分析

 

1.病毒文件在%AppData% 下创建ebb77b510896c2684f07aa09909db81 文件夹并设置隐藏属性

 

![图片](pic_temp6\psb7.png)

 

2.把自身复制到创建好的文件夹,命名为crossfire.exe ,然后在桌面创建快捷方式”腾讯.lnk”,然后执行该程序

 

![图片](pic_temp6\psb8.png)

 

3.全盘搜索crossfire.exe ,然后把自身覆盖原文件,并在最后填充垃圾数据



![图片](pic_temp6\psb9.png)

 

![图片](pic_temp6\psb10.png)

 

##  键盘监听行为分析

 

  由上面的得出的字符串信息可以知道,这款木马程序本身携带有键盘监听功能,于是根据一般使用到的监听API 进行交叉引用查找,找到一个后台监听线程.

 

![图片](pic_temp6\psb11.png)

 

![图片](pic_temp6\psb12.png)

 

  木马监听键盘的设计思路也很有意思,它不是只针对某个程序进行监听,而是监听前台窗口,并且为每个监听的窗口的击键记录和窗口名都保存到键盘记录文件中.

 

![图片](pic_temp6\psb13.png)

 

![图片](pic_temp6\psb14.png)

 

![图片](pic_temp6\psb15.png)

 

  找出了木马是如何监听键盘后,顺着字符串

 

![图片](pic_temp6\psb16.png)

 

  找出木马上传击键记录的行为,先把所有数据读取出来之后,通过异或0x62 加密数据然后传输到服务端

 

![图片](pic_temp6\psb17.png)

 

##  网络行为分析

 

  分析的过程中,由于木马的作者已经把服务器关闭了,没有办法建立通信,具体的细节没有办法再详细地分析出来,但是大概的网络行为分析如下:

 

1. 把保存在外壳代码中的加密域名解密并且解析IP 地址和端口,由whois 和IP 反查可以得知这是动态域名

 

![图片](pic_temp6\psb18.png)

 

2. 木马客户端向服务器建立长连接,并且上传主机信息给服务器

 

![图片](pic_temp6\psb19.png)

 

![图片](pic_temp6\psb20.png)

 

![图片](pic_temp6\psb21.png)

 

3. 建立后台线程等待控制

 

![图片](pic_temp6\psb22.png)

 

  除此之外,木马还会在本地建立新的帐户并且启动远程桌面功能.

 

![图片](pic_temp6\psb23.png)

 

![图片](pic_temp6\psb24.png)

 

##  结语

 

  木马的作者在写代码的时候考虑到杀毒软件的查杀和反病毒人员的分析,在代码上面做了许多手脚,在分析主体代码的时候遇到一些和木马作者对抗意识的情况,他在细节的处理上考虑周到.最后建议大家以后还是谨慎接收和打开可疑的文件,以免陷入感染木马的危机.