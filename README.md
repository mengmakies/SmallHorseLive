**小马直播间**基于**环信IM的聊天室**和**Ucloud的直播云ULive**实现：
- 环信IM http://www.easemob.com/
- Ucloud的直播云ULive  https://www.ucloud.cn/site/product/ulive.html

![](https://raw.githubusercontent.com/mengmakies/SmallHorseLive/master/screenshot1.png)

![](https://raw.githubusercontent.com/mengmakies/SmallHorseLive/master/screenshot2.png)


音视频直播的两个专业术语：推流、拉流。
>- 推流：把视频流“推”送到服务器，也就是：视频录制；
- 拉流：把视频流从服务器“拉”出来，也就是：视频播放；

**注意：**以上为个人理解，专业解释需要大家搜索百度或必应~!~

其次，做这个demo过程中有2个坑，小马都帮大家踩过了：
>- 环信 iOS HyphenateFullSDK（包含**实时通话**功能）与UCloud的直播云SDK会冲突，推流的时候直接导致视频“卡住”不动。所以只能集成环信HyphenateSDK （不包含**实时通话**功能）；
- UCloud官方明确表明[直播云SDK最低支持IOS7.0](https://docs.ucloud.cn/upd-docs/ulive/ULive_IOS_SDK.html)，可是经小马实测，IOS7.0.4无法推流（但是拉流正常），被这个坑了4天，所以建议大家真机测试时，IOS系统版本至少要8.0以上。

>如果没有安卓机做推流测试，大家可以用其它推流工具，墙裂推荐：https://www.qcloud.com/doc/api/258/4743

**项目说明**
《一言不合你就用环信搞个直播APP》http://community.easemob.com/article/825307904
