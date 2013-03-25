 
『dApps APP开发者社区Code分享』——与您分享最精彩最实用的APP源码

 / -------------------------------------------\
|  dApps Code：http://www.dapps.net/dev/code   |
|  关注我们的微博：http://weibo.com/dapps      |
 \--------------------------------------------/



免责声明：
本文件均是收集整理自网络，作为学习交流使用，不可用于任何商业途径，请在下载后24小时内删除。

使用前请您先阅读以下条款，否则请勿使用本站提供的文件！
   1) 本站不能绝对保证所提供软件或程序的完整性和安全性。
   2) 请务必在使用前查毒 (这也是您使用其它网络资源所必须注意的) 
   3) 近来部分国产软件、汉化安装程序捆绑流氓插件，若为dApps推荐下载的软件，请您也要在安装过程谨慎点击每一个下一步。
   4) 由本站提供的程序/源码对您的网站或计算机造成严重后果的本站概不负责。
   5) 本站提供的程序均为网上搜集，如果该文件涉及或侵害到您的版权请立即通知我们，我们会立即撤下相关资源。

dApps敬上！

---------------------------------我是APP开发的分界线---------------------
Android 2.1 Emulator 使用方法
假设压压缩包解压后放D:\AndroidEmulator目录下

1. 运行模拟器，打开cmd命令窗口，进入到D:\AndroidEmulator目录，执行以下命令：
D:\AndroidEmulator>start /b emulator.exe -sysdir d:\AndroidEmulator -system images\system.img -data images\userdata.img -ramdisk images\ramdisk.img -kernel images\kernel-qemu -skindir d:\AndroidEmulator\skins -skin HVGA
      
2. 运行示例程序，执行命令
D:\AndroidEmulator>adb install Renju\Renju.apk
如果遇到以下输出：
* daemon not running. starting it now on port 5037 *
* daemon started successfully *
error: device offline
不用理会，重新执行adb install Renju\Renju.apk命令即可。

模拟器具体制作方法请参考后面或者个人博客文章：http://blog.csdn.net/luoshengyang/article/details/6586759
示例程序Renju.apk是一个交互式人机对战五子棋游戏，有兴趣请参考apps目录下的使用说明，或者关注个人博客：http://blog.csdn.net/luoshengyang

欢迎交流合作：shyluo@gmail.com


制作流程
======================================================================================
 如果我们编写了一个Android应用程序，想在一台没有Android SDK或者BUILD环境的机器显示给别人看，应该怎么办呢？通常，我们开发Android应用程序的时候，都是使用模拟器来运行程序，要么是SDK环境下，要么是在源代码BUILD环境下使用。在SDK环境下，结合Eclipse和ADT，使用模拟器很方便，而BUILD环境下，也是很简单地使用emulator命令就可以了，具体可以参考在Ubuntu上下载、编译和安装Android最新源代码一文。这篇文章介绍另外一种方法在Windows下环境下使用Android模拟器，它不依赖于SDK或者BUILD环境，可以独立分发和使用。

要运行Android模拟器emulator，只要具备4个系统镜像就可以了，分别是system.img、userdata.img、ramdisk.img和kernel-qemu，这4个文件均可以在从SDK环境中得到，此外，最好还要添加模拟器皮肤和adb工具，这样功能才算完整。以下介绍具体制方法。

一. 下载Android SDK。官方下载http://dl.google.com/android/android-sdk_rXX-windows.zip，XX是指你要下载的版本号，例如我下载的是08。此链接可能已经被和谐，，可以在网上搜索一下，用其它办法下载。下载好之后，运行SDK Manager工具，下载完整的SDK。假设SDK放在D:\android-sdk-windows目录下。

二. 新建一个目录，例如，在D盘下新建目录D:\AndroidEmulator。进入到D:\android-sdk-windows\tools目录下，将emulator.exe拷拷贝到D:\AndroidEmulator中，同时进入到D:\android-sdk-windows\platform-tools目录下，拷贝adb.exe和AdbWinApi.dll两个文件到D:\AndroidEmulator中。注意，有的SDK把adb.exe和AdbWinApi.dll放在D:\android-sdk-windows\tools目录下。

三. 在D:\AndroidEmulator新建目录images，用来存放上面提到的4个系统镜像。例如要制作Android2.1模拟器，则到D:\android-sdk-windows\platforms\android-7\images目录下，把里面的文件全部拷贝到D:\AndroidEmulator\images目录下，D:\android-sdk-windows\platforms\android-7\images目录包含了system.img、userdata.img、ramdisk.img和kernel-qemu这4个文件。

四. 在D:\AndroidEmulator新建目录skins，用来存放模拟器皮肤文件。继续以制作Android2.1模拟器为例，到D:\android-sdk-windows\platforms\android-7\skins目录下，把里面所有的文件夹拷贝到D:\AndroidEmulator\skins目录下，D:\android-sdk-windows\platforms\android-7\skins目录包含了模拟器皮肤文件。

五. 启动命令行窗口，进入到D:\AndroidEmulator目录，执行以下命令：

D:\AndroidEmulator>start /b emulator.exe -sysdir d:\AndroidEmulator -system images\system.img -data images\userdata.img -ramdisk images\ramdisk.img -kernel images\kernel-qemu -skindir d:\AndroidEmulator\skins -skin HVGA

start /b表示在后台运行emulator，其它emulator命令选项请执行emulator -help查看。这样，模拟器就运起来了。

六. 如果要在模拟器上安装APK程序，则执行adb install XXX.apk命令，运行adb install命令时，如果遇到下面输出：

D:\AndroidEmulator>adb install Renju.apk
* daemon not running. starting it now on port 5037 *
* daemon started successfully *
error: device offline

不用理会，重新运行，直到提示成功为止。

这样，如果我们编写了一个Android应用程序，想拿到一台没有Android SDK和Android Build环境的机器上显示给别人看，就可以打包D:\AndroidEmulator这个文件夹，再带上你的Android应用程序，就可以显示了，是不是很方便呢。