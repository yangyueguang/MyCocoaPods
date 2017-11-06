//
//  RespForWeChatViewController.mm
//  SDKSample
//
//  Created by Tencent on 12-4-9.
//  Copyright (c) 2012年 Tencent. All rights reserved.
#import "RespForWeChatViewController.h"
#import "WXApiManager.h"
#import "WXApiResponseHandler.h"
static NSString *kAppContentExInfo = @"<xml>extend info</xml>";
static NSString *kAppMessageAction = @"<action>dotaliTest</action>";
#define BUFFER_SIZE 1024 * 100

@interface RespForWeChatViewController(){
    UIImage *thumbImage;
    UIImage *testImage;
    NSData *gifImageData,*pdfData;
    NSString *title,*subtitle,*describe;
    NSString *pictureUrl,*musicUrl,*videoUrl,*webUrl;
}
@end
@implementation RespForWeChatViewController
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
    gifImageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dynamic" ofType:@"gif"]];
    pdfData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iphone4" ofType:@"pdf"]];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 135 + 1, UIApplication.sharedApplication.keyWindow.bounds.size.width, UIApplication.sharedApplication.keyWindow.bounds.size.height - 135 - 2)];
    [footView setBackgroundColor:[UIColor colorWithRed:0xef green:0xef blue:0xef alpha:0xef]];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"回应Text消息给微信" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(10, 25, 145, 40)];
    [btn addTarget:self action:@selector(sendTextContent) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn2 setTitle:@"回应Photo消息给微信" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setFrame:CGRectMake(165, 25, 145, 40)];
    [btn2 addTarget:self action:@selector(sendImageContent) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn3 setTitle:@"回应Link消息给微信" forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3 setFrame:CGRectMake(10, 80, 145, 40)];
    [btn3 addTarget:self action:@selector(sendLinkContent) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn4 setTitle:@"回应Music消息给微信" forState:UIControlStateNormal];
    btn4.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn4 setFrame:CGRectMake(165, 80, 145, 40)];
    [btn4 addTarget:self action:@selector(sendMusicContent) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn4];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn5 setTitle:@"回应Video消息给微信" forState:UIControlStateNormal];
    btn5.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn5 setFrame:CGRectMake(10, 135, 145, 40)];
    [btn5 addTarget:self action:@selector(sendVideoContent) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn5];
    
    UIButton *btn6 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn6 setTitle:@"回应App消息给微信" forState:UIControlStateNormal];
    btn6.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn6 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn6 setFrame:CGRectMake(165, 135, 145, 40)];
    [btn6 addTarget:self action:@selector(sendAppContent) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn6];
    
    UIButton *btn7 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn7 setTitle:@"回应非gif表情给微信" forState:UIControlStateNormal];
    btn7.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn7 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn7 setFrame:CGRectMake(10, 190, 145, 40)];
    [btn7 addTarget:self action:@selector(sendNonGifContent) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn7];
    
    UIButton *btn8 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn8 setTitle:@"回应gif表情给微信" forState:UIControlStateNormal];
    btn8.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn8 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn8 setFrame:CGRectMake(165, 190, 145, 40)];
    [btn8 addTarget:self action:@selector(sendGifContent) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn8];
    
    UIButton *btn9 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn9 setTitle:@"回应文件消息给微信" forState:UIControlStateNormal];
    btn9.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn9 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn9 setFrame:CGRectMake(10, 235, 145, 40)];
    [btn9 addTarget:self action:@selector(sendFileContent) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn9];
    
    [self.view addSubview:footView];
}

#pragma mark - User Actions
- (void)sendTextContent {
    [WXApiResponseHandler respText:describe];
    [self dismissModalViewControllerAnimated:YES];
}
- (void)sendImageContent {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    [WXApiResponseHandler  respImageData:imageData
                              MessageExt:nil
                                  Action:nil
                              ThumbImage:thumbImage];
    [self dismissModalViewControllerAnimated:YES];
}
- (void)sendLinkContent {
    [WXApiResponseHandler respLinkURL:webUrl
                                Title:title
                          Description:subtitle
                           ThumbImage:thumbImage];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)sendMusicContent {
    [WXApiResponseHandler respMusicURL:musicUrl
                               dataURL:musicUrl
                                 Title:title
                           Description:subtitle
                            ThumbImage:thumbImage];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)sendVideoContent {
    [WXApiResponseHandler respVideoURL:videoUrl
                                 Title:title
                           Description:subtitle
                            ThumbImage:thumbImage];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)sendAppContent {
    Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
    memset(pBuffer, 0, BUFFER_SIZE);
    NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
    free(pBuffer);
    [WXApiResponseHandler respAppContentData:data
                                     ExtInfo:kAppContentExInfo
                                      ExtURL:webUrl
                                       Title:title
                                 Description:subtitle
                                  MessageExt:describe
                               MessageAction:kAppMessageAction
                                  ThumbImage:thumbImage];
}

- (void)sendNonGifContent {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"];
    NSData *emoticonData = [NSData dataWithContentsOfFile:filePath];
    [WXApiResponseHandler respEmotionData:emoticonData
                               ThumbImage:thumbImage];
}

- (void)sendGifContent {
    [WXApiResponseHandler respEmotionData:gifImageData
                               ThumbImage:thumbImage];
}

- (void)sendFileContent {
    [WXApiResponseHandler respFileData:pdfData
                         fileExtension:@"pdf"
                                 Title:title
                           Description:subtitle
                            ThumbImage:thumbImage];
}
@end
