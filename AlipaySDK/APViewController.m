//
//  APViewController.m
//  AliSDKDemo
//
//  Created by 亦澄 on 16-8-12.
//  Copyright (c) 2016年 Alipay. All rights reserved.
//

#import "APViewController.h"
#import "Order.h"
#import "APAuthV2Info.h"
#import "DataSigner.h"
//#import <AlipaySDK/AlipaySDK.h>
#define ALI_DEMO_BUTTON_WIDTH  (([UIScreen mainScreen].bounds.size.width) - 40.0f)
#define ALI_DEMO_BUTTON_HEIGHT (60.0f)
#define ALI_DEMO_BUTTON_GAP    (30.0f)
#define ALI_DEMO_INFO_HEIGHT (200.0f)
@implementation APViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self generateButtons];
}
#pragma mark   ==============产生随机订单号==============
- (void)generateButtons{
    // NOTE: 支付按钮，模拟支付流程
    CGFloat originalPosX = 20.0f;
    CGFloat originalPosY = 100.0f;
    UIButton* payButton = [[UIButton alloc]initWithFrame:CGRectMake(originalPosX, originalPosY, ALI_DEMO_BUTTON_WIDTH, ALI_DEMO_BUTTON_HEIGHT)];
    payButton.backgroundColor = [UIColor colorWithRed:81.0f/255.0f green:141.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    payButton.layer.masksToBounds = YES;
    payButton.layer.cornerRadius = 4.0f;
    [payButton setTitle:@"支付宝支付Demo" forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(doAlipayPay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];
    
    // NOTE: 授权按钮，模拟授权流程
    originalPosY += (ALI_DEMO_BUTTON_HEIGHT + ALI_DEMO_BUTTON_GAP);
    UIButton* authButton = [[UIButton alloc]initWithFrame:CGRectMake(originalPosX, originalPosY, ALI_DEMO_BUTTON_WIDTH, ALI_DEMO_BUTTON_HEIGHT)];
    authButton.backgroundColor = [UIColor colorWithRed:81.0f/255.0f green:141.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    authButton.layer.masksToBounds = YES;
    authButton.layer.cornerRadius = 4.0f;
    [authButton setTitle:@"支付宝授权Demo" forState:UIControlStateNormal];
    [authButton addTarget:self action:@selector(doAlipayAuth) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:authButton];
    
    // NOTE: 重要说明
    NSString* text = @"重要说明:\n本Demo为了方便向商户展示支付宝的支付流程，所以订单信息的加签过程放在客户端完成；\n在商户的真实App内，为了防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；\n商户privatekey等数据严禁放在客户端，订单信息的加签过程也务必放在服务端完成；\n若商户接入时不遵照此说明，因此造成了损失，需自行承担。";
    CGFloat infoHeight = [text boundingRectWithSize:CGSizeMake(ALI_DEMO_BUTTON_WIDTH, CGFLOAT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f]}
                                            context:nil].size.height;
    originalPosY = ([UIScreen mainScreen].bounds.size.height) - (infoHeight + 2) - ALI_DEMO_BUTTON_GAP;
    UILabel* information = [[UILabel alloc]initWithFrame:CGRectMake(originalPosX, originalPosY, ALI_DEMO_BUTTON_WIDTH, infoHeight + 2)];
    information.numberOfLines = 0;
    information.backgroundColor = [UIColor clearColor];
    [information setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [information setTextColor:[UIColor redColor]];
    information.text = text;
    [self.view addSubview:information];
    
}

- (NSString *)generateTradeNO{
	static int kNumber = 15;
	NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	NSMutableString *resultStr = [[NSMutableString alloc] init];
	srand((unsigned)time(0));
	for (int i = 0; i < kNumber; i++){
		unsigned index = rand() % [sourceStr length];
		NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
		[resultStr appendString:oneStr];
	}
	return resultStr;
}
//合作身份者id，以2088开头的16位纯数字
#define PartnerID  @"2088521328301360"
//收款支付宝账号
#define SellerID   @"info@isolar88.com"
//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"63e5ome78a57swkijwq0rii0mklt7ug7"
//商户私钥，自助生成
#define PartnerPrivKey  @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBALzZYBqk2l/r6710aoHy+uUAE9K5DX6iPBfzdAq8h9jiuGBUeM52l+Rxukdym/KDdWhazWhpA3nrMRDWNvK6hv+n1mTfq1A8WZyD8bHy0yOItwOOVtbZtjw8jsUuwfp7Vgm6zaksi3wtYbaa94rYJ7+0tUEZgFBlHkeBuTjXbrV3AgMBAAECgYAQ1Ye9mEhnGI6xGrmLz+8Rjso1lI1hZnDY6bjEZD3v1XX+EEmcjfHISWMDj3HbUmCa5s08q2/F5HNBPvcy9/GknPJ4up0GXxMbwA2mm3Ye4dMLDPYI8CF6EHUsg50oGrjZYIv98i03PUJPvZvPo4QfV5UW6ig+PWhHrDznySVkYQJBAPtQfiDO2TFOQ+bcFBp4sv1RqW8KS10rhRsQNIA+BLqsfWB8rMphZ4JXtdg3v7ohNRnajDQJDZbQheYJz8VlB58CQQDAXr1rQyMqh8KyO3LaKW7huczBvP4zmy7wct3FfezRiQdtcyT0Nhz5JadexSwqZLfXOF+RGrHGZKvDRhCM8mMpAkB2PioJ36jbBPr3vOaMieuVOn3gq9RHsvk+gYJiMEvjVNLsudxGoEumTQRXBevkdElar7Q1q2jEY7oMQOOL+Xv7AkAX1mWQehRMe+AzZ8x2njXAQN7PjxTM3kj1wLYcd9s1p85E0MTegioa8YCI7NPpOOvS/ohRGca3t9fU7cS1Qn/pAkBZJ9o3lxzPO3QMlozuwLg08Wes25Kx+EVyAzrtp7ODcsNgjW1P5RqgOpNyeYE5bb6dd3IBKTEMk1optwTqgev3"
//支付宝公钥
#define AlipayPubKey    @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI6d306Q8fIfCOaTXyiUeJHkrIvYISRcc73s3vF1ZT7XN8RNPwJxo8pWaJMmvyTn9N4HQ632qJBVHf8sxHi/fEsraprwCtzvzQETrNRwVxLO5jVmRGi60j8Ue1efIlzPXV9je9mkjzOmdssymZkh2QhUrCmZYI/FCEa3/cNMW0QIDAQAB"
#define alipayBackUrl @"http://www.isolar88.com"//支付宝回掉路径
#define alipayAppid @"2016113003600839"
#pragma mark   ==============点击订单模拟支付行为==============
//
//选中商品调用支付宝极简支付
- (void)doAlipayPay{
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
/*=======================需要填写商户app申请的===================================*/
    NSString *appID = alipayAppid;
    NSString *privateKey = PartnerPrivKey;
    //partner和seller获取失败,提示
    if ([appID length] == 0 ||[privateKey length] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"缺少appId或者私钥。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    //生成订单信息及签名
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    // NOTE: app_id设置
    order.app_id = appID;
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    // NOTE: 支付版本
    order.version = @"1.0";
    // NOTE: sign_type设置
    order.sign_type = @"RSA";
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = @"测试一下，iOS 薛超的账号";
    order.biz_content.subject = @"于洋限量版";
    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
//    order.return_url = @"http://www.isolar88.com";
//    order.notify_url = @"http://www.isolar88.com";
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderInfo];
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"alisdkdemo";
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",orderInfoEncoded, signedString];
        // NOTE: 调用支付结果开始支付
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
//        }];
    }
}
#pragma mark   ==============点击模拟授权行为==============
- (void)doAlipayAuth{
    //重要说明
    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*=======================需要填写商户app申请的===================================*/
    NSString *pid = PartnerID;
    NSString *appID = alipayAppid;
    NSString *privateKey = PartnerPrivKey;
    //pid和appID获取失败,提示
    if ([pid length] == 0 ||[appID length] == 0 ||[privateKey length] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"缺少pid或者appID或者私钥。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    //生成 auth info 对象
    APAuthV2Info *authInfo = [APAuthV2Info new];
    authInfo.pid = pid;
    authInfo.appID = appID;
    //auth type
    NSString *authType = [[NSUserDefaults standardUserDefaults] objectForKey:@"authType"];
    if (authType) {
        authInfo.authType = authType;
    }
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    // 将授权信息拼接成字符串
    NSString *authInfoStr = [authInfo description];
    NSLog(@"authInfoStr = %@",authInfoStr);
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:authInfoStr];
    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    if (signedString.length > 0) {
//        authInfoStr = [NSString stringWithFormat:@"%@&sign=%@&sign_type=%@", authInfoStr, signedString, @"RSA"];
//        [[AlipaySDK defaultService] auth_V2WithInfo:authInfoStr fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//           NSLog(@"result = %@",resultDic);
//           // 解析 auth code
//           NSString *result = resultDic[@"result"];
//           NSString *authCode = nil;
//           if (result.length>0) {
//               NSArray *resultArr = [result componentsSeparatedByString:@"&"];
//               for (NSString *subResult in resultArr) {
//                   if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
//                       authCode = [subResult substringFromIndex:10];
//                       break;
//                   }
//               }
//           }
//           NSLog(@"授权结果 authCode = %@", authCode?:@"");
//       }];
    }
}

@end
