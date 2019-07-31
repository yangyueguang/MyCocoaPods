
##高新技术
1.支付宝相关功能接入:支付 会员 营销 理财 开店 社交功能。 https://open.alipay.com/platform/home.htm
2.微信相关功能接入:移动应用开发 网站应用开发 公众号开发 公众号第三方开发  支付 登录 分享 收藏 图像识别 语音识别 语音合成 语义理解。 https://open.weixin.qq.com
3.MOB接入:社会化分享 免费短信验证码 手游录像分享 MobAPI。 http://www.mob.com
4.融云RONGCLOUD接入:IM系列 即时聊天 音视频通讯 视频直播 在线客服 推送和短信。http://www.rongcloud.cn
5.网易云信接入:IM即时通讯 音视频通讯 教学白板 聊天室 短信  http://netease.im  网易视频云接入:直播 点播 互动直播 http://vcloud.163.com 网易易盾接入:广告过滤 智能鉴黄 暴恐识别 谣言排查 http://dun.163.com
6.环信接入:IM即时通讯 音视频通讯 多种消息格式 红包功能 http://www.easemob.com
7.容联云通讯:IM即时通讯+办公 音视频通讯 红包 电话 短信 语音通知 http://www.yuntongxun.com
8.友盟接入:大数据 应用统计 线下分析 行业报告 分享 推送 http://www.umeng.com
9.个推接入:推送  http://www.getui.com
10.腾讯云接入:云服务器 云硬盘 云API 云通讯 短信 视频服务 推送 https://www.qcloud.com
11.极光接入:推送 IM即时通讯 短信 统计 https://www.jiguang.cn
12.FFmpeg接入:音视频编码、解码、记录、转换，视频直播等功能。https://ffmpeg.org  
案例:http://download.csdn.net/download/baitxaps/8657935  https://github.com/leixiaohua1020/simplest_ffmpeg_mobile  https://github.com/xiayuanquan/FFmpegDemo
13.微吼直播接入:直播功能。http://www.vhall.com/business/page-85.html
14.科大讯飞接入:语音识别 语音合成 语音扩展 人脸识别 声纹识别 http://www.xfyun.cn


高端案例
指纹识别登录 https://github.com/zonghongyan/EVNTouchIDDemo
iOS操作HTML5页面及JS交互 http://www.jianshu.com/p/8ceb99e154f7 http://blog.csdn.net/zhangmengleiblog/article/details/51801994 http://www.cnblogs.com/wanxudong/p/5581367.html
推送教程http://www.2cto.com/kf/201607/530214.html http://www.jb51.net/Special/888.htm
邓白氏码申请教程https://developer.apple.com/support/D-U-N-S/cn/
数据库操作管理软件http://www.orsoon.com/Mac/85386.html
iOS录音并播放http://blog.sina.com.cn/s/blog_7d1531ed01019cxb.html
音视频录制、播放与处理http://www.cnblogs.com/kenshincui/p/4186022.html
iOS开发系列--通讯录、蓝牙、内购、GameCenter、iCloud、Passbook系统服务开发汇总 http://www.cnblogs.com/kenshincui/p/4220402.html
iOS开发系列--Swift语言http://www.cnblogs.com/kenshincui/p/4717450.html  http://www.cnblogs.com/kenshincui/p/4824810.html http://www.cnblogs.com/kenshincui/p/5594951.html
iOS开发系列--扩展http://www.cnblogs.com/kenshincui/p/5644803.html
iOS开发系列--Kenshin博客 http://www.cnblogs.com/kenshincui/default.aspx
iOS语音通话（语音对讲）http://blog.csdn.net/u011619283/article/details/39613335
史上最全的开源库整理http://blog.csdn.net/u010551217/article/details/52946139  http://blog.csdn.net/liu1039950258/article/details/51656144
所有的集合视图动画 https://github.com/nicklockwood/iCarousel

##支付心得
//IOS之收集到的很好的网址（博客，网站）http://www.cnblogs.com/goodboy-heyang/category/733290.html
//GitHub 上有哪些完整的 iOS-App 源码值得参考？http://www.cnblogs.com/goodboy-heyang/p/5248379.html
//酷炫动画github源码下载地址：https://github.com/lichtschlag/Dazzle
//IOS开发之支付功能概述 http://www.cnblogs.com/goodboy-heyang/p/5252159.html
//本工具类封装了微信和支付宝的接口，内涵微信的发消息或文件到朋友，朋友圈以及收藏内容还有分享到支付宝的消息。还有微信支付和支付宝支付的功能。另含微信的高级接口包括语音识别，图像识别等。
#pragma mark 微信接入https://open.weixin.qq.com
/* 1.接入微信必须注册一个微信开放平台账号：https://open.weixin.qq.com
2.填写相关资料及实名认证并花300元申请开发者资质认证。https://open.weixin.qq.com/cgi-bin/profile?t=setting/dev&lang=zh_CN&token=8699abf1cc006cd477c0fa38add3e628394455d6
3.在管理中心按需创建应用的相关信息并开通相应的功能(移动应用、网站应用、公众账号、公众号第三方平台),获取AppKey和AppSecret.https://open.weixin.qq.com/cgi-bin/applist?t=manage/list&lang=zh_CN&token=8699abf1cc006cd477c0fa38add3e628394455d6
4.如果开通了微信支付填写好相应的信息审核通过会下发一个商户账号(如:账号:1419747302@1419747302密码:847281 APPID:wx1e84e84a6e551aff)，根据商户账号密码到网址登录可查看用户交易等数据信息。https://pay.weixin.qq.com/index.php/core/info
5.在资源中心阅读相应的开发文档。https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&lang=zh_CN&token=8699abf1cc006cd477c0fa38add3e628394455d6&appid=wx1e84e84a6e551aff
6.下载微信SDK并配置开发环境。https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=1417694084&token=8699abf1cc006cd477c0fa38add3e628394455d6&lang=zh_CN
7.在APPDelegate中导入头文件WXApi.h并遵守WXApiDelegate。在didFinishLaunch中注册微信ID及Secret。参照demo重写AppDelegate的handleOpenURL和openURL方法。
8.参照开发文档，按需接入微信登录、发消息、分享、收藏、支付、图像识别、语音识别、语音合成、语义理解
9.在数据中心可查看微信用户的分析数据以及分享、收藏、登录、智能等用户行为统计数据信息。https://open.weixin.qq.com/cgi-bin/frame?t=statistics/analysis_tmpl&lang=zh_CN&token=8699abf1cc006cd477c0fa38add3e628394455d6
10.微信样例//@简书地址:   http://www.jianshu.com/p/af8cbc9d51b0  @Github地址: https://github.com/lyoniOS/WxPayDemo
*/
#pragma mark 支付宝接入https://open.alipay.com
/*1.接入支付宝必须注册一个支付宝账户：https://open.alipay.com/platform/home.htm
2.填写相关资料及实名认证并设置应用密匙其他项可选设置，获取AppID和AppSecret。https://openhome.alipay.com/platform/setting.htm https://doc.open.alipay.com/docs/doc.htm?spm=a219a.7629140.0.0.ZyhHVp&treeId=193&articleId=105310&docType=1
3.在研发管理创建应用并填写相应信息以及开通相应功能。https://openhome.alipay.com/platform/appManage.htm
4.在文档中心详细阅读支付宝接入文档。https://doc.open.alipay.com
5.下载支付宝SDK并集成开发环境。https://doc.open.alipay.com/doc2/detail.htm?treeId=204&articleId=105295&docType=1  https://doc.open.alipay.com/doc2/detail.htm?treeId=54&articleId=104509&docType=1
6.在AppDelegate中导入<AlipaySDK/AlipaySDK.h>头文件并参照demo重写openURL的方法。
7.在文档中心详细阅读支付宝API文档。https://doc.open.alipay.com/doc2/apiList?docType=4
8.按需接入支付宝的相应功能。支付能力、理财能力、口碑开店能力、会员营销、支付宝卡券、会员能力、生活号、行业能力、信用能力、安全能力、云监控、社交能力、服务市场管理以及基础能力。
报错：openssl/asn1.h file not found 在header searchPaths：$(PROJECT_DIR)/GuangFuBao/wechart&alipay/alipaySKD
使用alipaySDK需要在buildsettings searchPath header  增加这一行："$(SRCROOT)/薛超APP框架/ThirdSDK/alipaySDK"
支付宝样例http://www.jianshu.com/p/b3063678c462
*/

#pragma mark 支付宝分享
/*1.导入alipayShareSDK然后做一般情况下相应的配置。
2.在AppDelegate遵守APOpenAPIDelegate协议，在didFinishLaunching方法中注册申请的appID：[APOpenAPI registerApp:@"alisdkdemo"]，在application:openURL方法中[APOpenAPI handleOpenURL:url delegate:self]
3.重写两个方法
//收到一个来自支付宝的请求，第三方应用程序处理完后调用sendResp向支付宝发送结果
- (void)onReq:(APBaseReq*)req{}
//  第三方应用程序发送一个sendReq后，收到支付宝的响应结果*resp : 第三方应用收到的支付宝的响应结果类，目前支持的类型包括 APSendMessageToAPResp(分享消息)
- (void)onResp:(APBaseResp*)resp{}
*/

#pragma mark 苹果官方支付https://developer.apple.com https://developer.apple.com/apple-pay/
/*1.不用导入三方库，也不用在AppDelegate中设置什么。target导入PassKit.framework库。
2.注册 Merchant ID。使用 Apple Pay 的前提是必须注册一个 `Merchant ID`
a. 在开发者后台选择 [Merchant IDs 标签](https://developer.apple.com/account/ios/identifiers/merchant/merchantCreate.action) ，设置你的 `Merchant ID`，注册系统会默认添加 `merchant.` 前缀，如下图 ![merchant id](imgs/merchant_id.png)
b. 注册完成后再次选择 [Merchant IDs 标签](https://developer.apple.com/account/ios/identifiers/merchant/merchantList.action)，在列表中点击 `ApplePayDemo`，点击 `Edit`
c. 由于我们是在中国区使用 `Apple Pay`，所以在 `Merchant Settings` 的 `Are you processing your payments outside of the United States?` 选项中勾选 `Yes` ![outside us](imgs/outside_us.png)
d. 继续生成 `CSR`，这一步跟 `APNS` 的 `CSR` 生成步骤是一样的，不再赘述，请大家参考相关资料
3.注册 App ID
a. 在开发者后台选择 [App IDs 标签](https://developer.apple.com/account/ios/identifiers/) 注册 `App ID` 并指定 `Bundle ID`，例如 `com.example.appid`，在 `App Services` 中记得勾选 `Apple Pay`   ![App Services](imgs/app_services.png)
b. 注册完成再次选择 [App IDs 标签](https://developer.apple.com/account/ios/identifiers/)，点击刚才所注册的 `App ID`，点击 `Edit` 按钮  ![App ID Settings](imgs/app_id_settings.png)
c. 在 `Apple Pay` 中点击 `Edit`，然后选择你刚才生成的 `Merchant ID` ![configure merchant id](imgs/app_id_configure_merchant_id.png)
4. 生成 `Provisioning Profile` 并配置 Xcode 项目
a. 在开发者后台选择 [Provisioning Profiles 标签](https://developer.apple.com/account/ios/profile/profileList.action) ，根据刚才的 `App ID` 生成 `Profile`，完成后下载文件，双击文件完成导入
b. 创建 Xcode 项目，设置相应的 `Bundle ID`。完成后在项目的 `TARGETS` 项中选择 `Capabilities` 标签，打开 `Apple Pay` 选项并配置相应的 `Merchant ID` </br>
c.打开wallet，设置allow all。![Xcode project settings](imgs/xcode_project_settings.png)
5. 开发。在开发中需要用的类#import <PassKit/PassKit.h>并遵守<PKPaymentAuthorizationViewControllerDelegate>协议。实现见Wechart&AlipayViewController。如有疑问查看ApplePay文件夹图片。
*/

#pragma mark 银联支付https://open.unionpay.com/ajweb/index
/*1.接入银联必须先注册银联开发账号，然后按照指引往下走。https://open.unionpay.com/ajweb/help/toPage
2.选择银联服务产品查看说明然后登陆商户服务系统选择创建相应的服务https://open.unionpay.com/ajweb/product https://merchant.unionpay.com/portal/
3.导入银联的SDK，info中加入URL Schemes:UPPayDemo。设置OtherLinkerFlags:-ObjC  导入LocalAuthentication.framework  libPaymentControl.a  CFNetwork.framework  libz.tbd  SystemConfiguration.framework
4.在AppDelegate中引入头文件并加入对应的代码：代码见notes.md文件
5.参考API进行开发 https://open.unionpay.com/ajweb/help/api
详情见Wechart&AlipayViewController
*/

#pragma mark 连连支付 https://apple.lianlianpay.com/OpenPlatform/
/*
1.接入连连支付ApplePay必须注册连连开发账号。邮箱激活即可获得AppID。创建应用。在苹果官网登陆apple账号注册Merchant ID。下载连连的csr文件上传到苹果并下载对应的cer证书，上传该cer证书到连连并提交。
2.查看待完成事项，完善商户基本信息、财务信息并签署纸质合同回寄到指定地址。https://apple.lianlianpay.com/OpenPlatform/appAdmin.action
3.下载LianlianSDK，查看连连技术文档，开始开发。https://apple.lianlianpay.com/OpenPlatform/technical_documents.jsp
4.其中有个静态库.a与支付宝的静态库冲突，删除即可：libRsaCrypto.a
*/

#pragma mark QQ钱包支付 http://qpay.qq.com/
/*
1.接入QQ钱包必须注册QQ钱包开发账号。填写经营信息、商户信息、结算账户、提交审核、验证账户、签署协议、接入成功。
2.查看开发文档，选择接入方式。下载SDK，根据开发文档配置环境开始开发。https://qpay.qq.com/qpaywiki.shtml
3.记得在info中添加:LSApplicationQueriesSchemes:mqqwallet
*/
#pragma mark web支付 https://www.baidu.com
//直接跳转支付的网页即可，说明略。




