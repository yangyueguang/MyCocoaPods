//  SendMsgToWeChatViewController.m
//  ApiClient
//  Created by Tencent on 12-2-27.
//  Copyright (c) 2012年 Tencent. All rights reserved.
#import "SendMsgToWeChatViewController.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"
#import "RespForWeChatViewController.h"
@interface SendMsgToWeChatViewController ()<WXApiManagerDelegate,UITextViewDelegate>{
    UILabel *tips;
    UIImage *thumbImage;
    UIImage *testImage;
    NSData *gifImageData,*pdfData;
    NSString *title,*subtitle,*describe;
    NSString *pictureUrl,*musicUrl,*videoUrl,*webUrl;
}
@property (nonatomic) enum WXScene currentScene;
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) UIScrollView *footView;
@end
@implementation SendMsgToWeChatViewController
@synthesize currentScene = _currentScene;
@synthesize appId = _appId;
#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    title = @"这是消息的标题title";
    subtitle = @"这是消息的副标题描述内容subscribe";
    describe = @"这是纯文本内容的消息主体content";
    pictureUrl = @"http://pic.yesky.com/uploadImages/2015/174/53/6NSGL7M9J7C3.jpg";
    webUrl = @"http://tech.qq.com/a/20160529/007832.htm";
    videoUrl = @"http://www.iqiyi.com/yinyue/20120919/5c688b84912a8198.html";//少女时代
    musicUrl = @"http://stream20.qqmusic.qq.com/32464723.mp3";
    thumbImage = [UIImage imageNamed:@"thumb"];
    testImage = [UIImage imageNamed:@"test.jpg"];
    [self setupHeadView];
    [self setupSceneView];
    [self setupFootView];
    [WXApiManager sharedManager].delegate = self;
}
#pragma mark - User Actions
- (void)onSelectSessionScene {
    _currentScene = WXSceneSession;
    tips.text = @"分享场景:会话";
}

- (void)onSelectTimelineScene {
    _currentScene = WXSceneTimeline;
    tips.text = @"分享场景:朋友圈";
}

- (void)onSelectFavoriteScene {
    _currentScene = WXSceneFavorite;
    tips.text = @"分享场景:收藏";
}

- (void)sendTextContent {
    [WXApiRequestHandler sendText:title InScene:_currentScene];
}
- (void)sendImageContent {
    [WXApiRequestHandler sendImageData:UIImageJPEGRepresentation(testImage, 1.0)
                               TagName:@"WECHAT_TAG_JUMP_APP"
                            MessageExt:describe
                                Action:@"<action>dotaliTest</action>"
                            ThumbImage:thumbImage
                               InScene:_currentScene];
}

- (void)sendLinkContent {
    [WXApiRequestHandler sendLinkURL:webUrl
                             TagName:describe
                               Title:title
                         Description:subtitle
                          ThumbImage:thumbImage
                             InScene:_currentScene];
}

- (void)sendMusicContent {
    [WXApiRequestHandler sendMusicURL:musicUrl
                              dataURL:musicUrl
                                Title:title
                          Description:subtitle
                           ThumbImage:thumbImage
                              InScene:_currentScene];
}

- (void)sendVideoContent {
    [WXApiRequestHandler sendVideoURL:videoUrl
                                Title:title
                          Description:subtitle
                           ThumbImage:thumbImage
                              InScene:_currentScene];
}

- (void)sendAppContent {
    Byte* pBuffer = (Byte *)malloc(1024 * 100);
    memset(pBuffer, 0, 1024 * 100);
    NSData* data = [NSData dataWithBytes:pBuffer length:1024 * 100];
    free(pBuffer);
    [WXApiRequestHandler sendAppContentData:data
                                    ExtInfo:@"<xml>extend info</xml>"
                                     ExtURL:webUrl
                                      Title:title
                                Description:subtitle
                                 MessageExt:describe
                              MessageAction:@"<action>dotaliTest</action>"
                                 ThumbImage:thumbImage
                                    InScene:_currentScene];
}

- (void)sendNonGifContent {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"];
    NSData *emoticonData = [NSData dataWithContentsOfFile:filePath];
    UIImage *thumbImage = [UIImage imageNamed:@"thumb.png"];
    [WXApiRequestHandler sendEmotionData:emoticonData
                              ThumbImage:thumbImage
                                 InScene:_currentScene];
}

- (void)sendGifContent {
    [WXApiRequestHandler sendEmotionData:gifImageData
                              ThumbImage:thumbImage
                                 InScene:_currentScene];
}

- (void)sendAuthRequest {
    [WXApiRequestHandler sendAuthRequestScope:@"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
                                        State:@"xxx"
                                       OpenID:@"0c806938e2413ce73eef92cc3"
                             InViewController:self];
}

- (void)sendFileContent {
    [WXApiRequestHandler sendFileData:pdfData
                        fileExtension:describe
                                Title:title
                          Description:subtitle
                           ThumbImage:thumbImage
                              InScene:_currentScene];
}

- (void)addCardToWXCardPackage {
    WXCardItem* cardItem = [[WXCardItem alloc] init];
    cardItem.cardId = @"pDF3iY9tv9zCGCj4jTXFOo1DxHdo";
    cardItem.extMsg = @"{\"code\": \"\", \"openid\": \"\", \"timestamp\": \"1418301401\", \"signature\":\"f54dae85e7807cc9525ccc127b4796e021f05b33\"}";
    [WXApiRequestHandler addCardsToCardPackage:[NSArray arrayWithObject:cardItem]];
}

- (void)batchAddCardToWXCardPackage {
    WXCardItem* cardItem = [[WXCardItem alloc] init];
    cardItem.cardId = @"pDF3iY9tv9zCGCj4jTXFOo1DxHdo";
    cardItem.extMsg = @"{\"code\": \"\", \"openid\": \"\", \"timestamp\": \"1418301401\", \"signature\":\"f54dae85e7807cc9525ccc127b4796e021f05b33\"}";
    [WXApiRequestHandler addCardsToCardPackage:[NSArray arrayWithObjects:cardItem,cardItem, nil]];
}
- (void)bizPay {
    NSString *res = [WXApiRequestHandler jumpToBizPay];
    if( ![@"" isEqual:res] ){
        NSLog(@"支付失败");
    }
}
#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)req {
    // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
    NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
    NSString *strMsg = [NSString stringWithFormat:@"openID: %@", req.openID];
    
    
    UIAlertController *acVC = [UIAlertController alertControllerWithTitle:strTitle message:strMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *destructive = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        RespForWeChatViewController* controller = [RespForWeChatViewController alloc];
        [self presentViewController:controller animated:YES completion:nil];
    }];
    [acVC addAction:destructive];
    [self presentViewController:acVC animated:YES completion:nil];
}

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)req {
    WXMediaMessage *msg = req.message;
    //显示微信传过来的内容
    WXAppExtendObject *obj = msg.mediaObject;
    NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
    NSString *strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n附加消息:%@\n", req.openID, msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length, msg.messageExt];
    NSLog(@"%@===%@",strTitle,strMsg);
}

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)req {
    WXMediaMessage *msg = req.message;
    
    //从微信启动App
    NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
    NSString *strMsg = [NSString stringWithFormat:@"openID: %@, messageExt:%@", req.openID, msg.messageExt];
    NSLog(@"%@===%@",strTitle,strMsg);
}

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {
    NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", response.errCode];
    NSLog(@"%@===%@",strTitle,strMsg);
}

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response {
        NSMutableString* cardStr = [[NSMutableString alloc] init];
    for (WXCardItem* cardItem in response.cardAry) {
        [cardStr appendString:[NSString stringWithFormat:@"cardid:%@ cardext:%@ cardstate:%u\n",cardItem.cardId,cardItem.extMsg,(unsigned int)cardItem.cardState]];
    }
    NSLog(@"%@===%@",@"add card resp",cardStr);
}

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
    NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", response.code, response.state, response.errCode];
    NSLog(@"%@===%@",strTitle,strMsg);
}

#pragma mark - Private Methods
- (void)setupHeadView {
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [headView setBackgroundColor:[UIColor greenColor]];
    UIImage *image = [UIImage imageNamed:@"micro_messenger.png"];
    NSInteger tlx = (headView.frame.size.width -  image.size.width) / 2;
    NSInteger tly = 20;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(tlx, tly, image.size.width, image.size.height)];
    [imageView setImage:image];
    [headView addSubview:imageView];
    

    
    [self.view addSubview:headView];
}

- (void)setupSceneView {
    UIView *sceceView = [[UIView alloc] initWithFrame:CGRectMake(0, 135 + 2, 100, 100)];
    [sceceView setBackgroundColor:[UIColor greenColor]];
    
    tips = [[UILabel alloc]init];
    tips.text = @"分享场景:会话";
    tips.textColor = [UIColor blackColor];
    tips.backgroundColor = [UIColor clearColor];
    tips.textAlignment = NSTextAlignmentLeft;
    tips.frame = CGRectMake(10, 5, 200, 40);
    [sceceView addSubview:tips];
    
    UIButton *btn_x = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_x setTitle:@"会话" forState:UIControlStateNormal];
    btn_x.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_x setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_x setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btn_x setFrame:CGRectMake(20, 50, 80, 40)];
    [btn_x addTarget:self action:@selector(onSelectSessionScene) forControlEvents:UIControlEventTouchUpInside];
    [sceceView addSubview:btn_x];
    
    UIButton *btn_y = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_y setTitle:@"朋友圈" forState:UIControlStateNormal];
    btn_y.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_y setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_y setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btn_y setFrame:CGRectMake(120, 50, 80, 40)];
    [btn_y addTarget:self action:@selector(onSelectTimelineScene) forControlEvents:UIControlEventTouchUpInside];
    [sceceView addSubview:btn_y];
    
    UIButton *btn_z = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_z setTitle:@"收藏" forState:UIControlStateNormal];
    btn_z.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_z setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_z setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btn_z setFrame:CGRectMake(220, 50, 80, 40)];
    [btn_z addTarget:self action:@selector(onSelectFavoriteScene) forControlEvents:UIControlEventTouchUpInside];
    [sceceView addSubview:btn_z];
    
    [self.view addSubview:sceceView];
}

#define LEFTMARGIN			12
#define TOPMARGIN			15
#define BTNWIDTH			140
#define BTNHEIGHT			40
#define ADDBUTTON_AUTORELEASE(idx, title, sel) [self addBtn:idx tit:title selector:sel]
-(UIButton*) addBtn:(int)idx tit:(NSString*)title selector:(SEL)sel{
    CGRect rect;
    if(idx % 2 == 1) {
        rect = CGRectMake(LEFTMARGIN, 25*(idx/2) + TOPMARGIN*(idx/2+1), BTNWIDTH, BTNHEIGHT - 4);
    } else {
        rect = CGRectMake(LEFTMARGIN*2 + BTNWIDTH, 25*(idx/2-1) + TOPMARGIN*(idx/2), BTNWIDTH, BTNHEIGHT - 4);
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = rect;
    btn.tag = idx;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [self.footView addSubview:btn];
    return btn;
}

- (void)setupFootView {
    self.footView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 135 + 2 + 100 + 2, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 135 - 2 - 100 - 2)];
    [self.footView setBackgroundColor:[UIColor greenColor]];
    self.footView.contentSize = [UIScreen mainScreen].bounds.size;
    [self.view addSubview:self.footView];
    
    int index = 1;
    ADDBUTTON_AUTORELEASE(index++, @"发送Text消息给微信", @selector(sendTextContent));
    ADDBUTTON_AUTORELEASE(index++, @"发送Photo消息给微信", @selector(sendImageContent));
    ADDBUTTON_AUTORELEASE(index++, @"发送Link消息给微信", @selector(sendLinkContent));
    ADDBUTTON_AUTORELEASE(index++, @"发送Music消息给微信", @selector(sendMusicContent));
    ADDBUTTON_AUTORELEASE(index++, @"发送Video消息给微信", @selector(sendVideoContent));
    ADDBUTTON_AUTORELEASE(index++, @"发送App消息给微信", @selector(sendAppContent));
    ADDBUTTON_AUTORELEASE(index++, @"发送非gif表情给微信", @selector(sendNonGifContent));
    ADDBUTTON_AUTORELEASE(index++, @"发送gif表情给微信", @selector(sendGifContent));
    ADDBUTTON_AUTORELEASE(index++, @"微信授权登录", @selector(sendAuthRequest));
    ADDBUTTON_AUTORELEASE(index++, @"发送文件消息给微信", @selector(sendFileContent));
    ADDBUTTON_AUTORELEASE(index++, @"添加单张卡券至卡包", @selector(addCardToWXCardPackage));
    ADDBUTTON_AUTORELEASE(index++, @"添加多张卡券至卡包", @selector(batchAddCardToWXCardPackage));
    ADDBUTTON_AUTORELEASE(index++, @"发起微信支付", @selector(bizPay));
}

@end
