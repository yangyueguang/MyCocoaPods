
#import "Utility.h"
#include <sys/sysctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <AudioToolbox/AudioToolbox.h>//振动
#import <CommonCrypto/CommonDigest.h>
#import <QuartzCore/QuartzCore.h>
#import <StoreKit/StoreKit.h>
@interface Utility()<SKStoreProductViewControllerDelegate>
@end
@implementation Utility
static Utility *_utilityinstance=nil;
+(id)Share{
    static dispatch_once_t utility;
    dispatch_once(&utility, ^ {
        _utilityinstance = [[Utility alloc] init];
    });return _utilityinstance;
}
- (id)init{
    self = [super init];
    if (self) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }return self;
}
+(NSString *)getMacAddress{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else{
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)errorFlag = @"sysctl mgmtInfoBase failure";
        else{
            if ((msgBuffer = malloc(length)) == NULL)   errorFlag = @"buffer allocation failure";
            else{
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0) errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    if (errorFlag != NULL){free(msgBuffer);   return errorFlag;}
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",macAddress[0], macAddress[1], macAddress[2],macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    free(msgBuffer);
    return macAddressString;//.md5;
}

#pragma mark makeCall
- (void) makeCall:(NSString *)phoneNumber{
    NSString *phoneNum=[[[[phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"-" withString:@""]
                            stringByReplacingOccurrencesOfString:@"(" withString:@""]stringByReplacingOccurrencesOfString:@")" withString:@""];
    if ([phoneNum intValue]!=0) {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNum]] options:@{} completionHandler:^(BOOL success) {
         }];
    }else {
       NSLog(@"无效号码");
        return;
    }
}
#pragma mark 抖动与振动
//类似qq聊天窗口的抖动效果
-(void)shakeViewAnimation:(UIView *)aV{
    CGFloat t =5.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    CGAffineTransform translateTop =CGAffineTransformTranslate(CGAffineTransformIdentity,0.0,1);
    CGAffineTransform translateBottom =CGAffineTransformTranslate(CGAffineTransformIdentity,0.0,-1);
    aV.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse animations:^{
        [UIView setAnimationRepeatCount:2.0];
        aV.transform = translateRight;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.07 animations:^{
            aV.transform = translateBottom;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.07 animations:^{
                aV.transform = translateTop;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    aV.transform =CGAffineTransformIdentity;//回到没有设置transform之前的坐标
                } completion:NULL];
            }];
        }];
    }];
}

//view 左右抖动
-(void)leftRightAnimations:(UIView *)view{
    CGFloat t =5.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    view.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        view.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                view.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}
// 振动
- (void)StartSystemShake {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

//播放提示音
-(void)playSystemSound{
    SystemSoundID sound;//系统声音的id 取值范围为：1000-2000
    /*ReceivedMessage.caf--收到信息，仅在短信界面打开时播放。
     sms-received1.caf-------三全音sms-received2.caf-------管钟琴sms-received3.caf-------玻璃sms-received4.caf-------圆号
     sms-received5.caf-------铃声sms-received6.caf-------电子乐SentMessage.caf--------发送信息
     */
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",@"sms-received1",@"caf"];
    //[[NSBundle bundleWithIdentifier:@"com.apple.UIKit" ]pathForResource:soundName ofType:soundType];//得到苹果框架资源UIKit.framework ，从中取出所要播放的系统声音的路径
    //[[NSBundle mainBundle] URLForResource: @"tap" withExtension: @"aif"];  获取自定义的声音
    OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
    if (error != kAudioServicesNoError) NSLog(@"获取的声音的时候，出现错误");
    AudioServicesPlaySystemSound(sound);
}

#pragma mark -验证数据
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}
- (BOOL) validateTel: (NSString *) candidate {
    NSString *telRegex = @"^1[1234567890]\\d{9}$";
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *telTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex];
    NSPredicate *PHSP = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    if ([telTest evaluateWithObject:candidate] == YES || [PHSP evaluateWithObject:candidate] == YES) {
        return YES;
    }else{
        return NO;
    }
}
//判断是否为整形：
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
//判断是否为浮点形：
- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
#pragma mark -数据格式化
///数据格式化
-(NSString *)FormatPhone:(NSString *)str{
    if (str.length<10) {
        return str;
    }else{
        NSString *s1=[str substringToIndex:3];
        NSString *s2=[str substringWithRange:NSMakeRange(3, 4)];
        NSString *s3=[str substringFromIndex:7];
        NSString *turntoCarIDString=[NSString stringWithFormat:@"%@ %@ %@",s1,s2,s3];
        return turntoCarIDString;
    }
}
///格式化身份证号
-(NSString *)FormatIDC:(NSString *)str{
    if (str.length==18) {
        NSString *s1=[str substringToIndex:3];
        NSString *s2=[str substringWithRange:NSMakeRange(3, 3)];
        NSString *s3=[str substringWithRange:NSMakeRange(6, 4)];
        NSString *s4=[str substringWithRange:NSMakeRange(10, 4)];
        NSString *s5=[str substringFromIndex:14];
        NSString *turntoCarIDString=[NSString stringWithFormat:@"%@ %@ %@ %@ %@",s1,s2,s3,s4,s5];
        return turntoCarIDString;
    }else if(str.length>=15){
        NSString *s1=[str substringToIndex:(str.length-8)];
        NSString *s4=[str substringWithRange:NSMakeRange((str.length-8), 4)];
        NSString *s5=[str substringFromIndex:(str.length-4)];
        NSString *turntoCarIDString=[NSString stringWithFormat:@"%@ %@ %@",s1,s4,s5];
        return turntoCarIDString;
    }else{
        return str;
    }
}

/// 格式化组织机构代码证
-(NSString *)FormatOCC:(NSString *)str{
    if (str.length<9) {
        return str;
    }else{
        NSString *s1=[str substringToIndex:4];
        NSString *s2=[str substringWithRange:NSMakeRange(4, 4)];
        NSString *s3=[str substringFromIndex:8];
        NSString *turntoCarIDString=[NSString stringWithFormat:@"%@ %@ %@",s1,s2,s3];
        return turntoCarIDString;
    }
}
////格式化车牌号
-(NSString *)FormatPlate:(NSString *)str{
    if (str.length<7) {
        return str;
    }else{
        NSString *s1=[str substringToIndex:(str.length-5)];
        NSString *s2=[str substringWithRange:NSMakeRange((str.length-5), 5)];
        NSString *turntoCarIDString=[NSString stringWithFormat:@"%@ %@",s1,s2];
        return turntoCarIDString;
    }
}
//格式化vin
-(NSString *)FormatVin:(NSString *)str{
    if (str.length<17) {
        return str;
    }else{
        NSString *s1=[str substringToIndex:4];
        NSString *s2=[str substringWithRange:NSMakeRange(4, 4)];
        NSString *s3=[str substringWithRange:NSMakeRange(8, 1)];
        NSString *s4=[str substringWithRange:NSMakeRange(9, 4)];
        NSString *s5=[str substringWithRange:NSMakeRange(13, 4)];
        NSString *turntoVinString=[NSString stringWithFormat:@"%@ %@ %@ %@ %@",s1,s2,s3,s4,s5];
        return turntoVinString;
    }
}
///数字格式化
-(NSString*)FormatNumStr:(NSString*)nf{
    float f=[nf floatValue];
    NSNumberFormatter * formatter=[[NSNumberFormatter alloc]init];
    formatter.numberStyle=kCFNumberFormatterCurrencyStyle;
    NSString *turnstr=[formatter stringFromNumber:[NSNumber numberWithFloat:f]];
    turnstr=[turnstr substringFromIndex:1];
    return turnstr;
}
#pragma mark 是否支持蓝牙协议4.0
//是否支持蓝牙协议4.0
- (BOOL)isSupportBluetoothProtocol{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    if([platform isEqualToString:@"iPhone1,1"]) { return NO;
    }else if ([platform isEqualToString:@"iPhone1,2"]) {platform = @"iPhone 3G";return NO;
    }else if ([platform isEqualToString:@"iPhone2,1"]) {platform = @"iPhone 3GS"; return NO;
    }else if ([platform isEqualToString:@"iPhone3,1"]||[platform isEqualToString:@"iPhone3,2"]||[platform isEqualToString:@"iPhone3,3"]) {platform = @"iPhone 4";return NO;
    }else if ([platform isEqualToString:@"iPhone4,1"]) {platform = @"iPhone 4S";
    }else if ([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"]) {platform = @"iPhone 5";
    }else if ([platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"]) {platform = @"iPhone 5C";
    }else if ([platform isEqualToString:@"iPhone6,2"]||[platform isEqualToString:@"iPhone6,1"]) {platform = @"iPhone 5S";
    }else if ([platform isEqualToString:@"iPod4,1"]) {platform = @"iPod touch 4";return NO;
    }else if ([platform isEqualToString:@"iPod5,1"]) {platform = @"iPod touch 5";
    }else if ([platform isEqualToString:@"iPod3,1"]) {platform = @"iPod touch 3";return NO;
    }else if ([platform isEqualToString:@"iPod2,1"]) {platform = @"iPod touch 2";return NO;
    }else if ([platform isEqualToString:@"iPod1,1"]) {platform = @"iPod touch";return NO;
    }else if ([platform isEqualToString:@"iPad3,2"]||[platform isEqualToString:@"iPad3,1"]) {platform = @"iPad 3";return NO;
    }else if ([platform isEqualToString:@"iPad2,2"]||[platform isEqualToString:@"iPad2,1"]||[platform isEqualToString:@"iPad2,3"]||[platform isEqualToString:@"iPad2,4"]) {platform = @"iPad 2";return NO;
    }else if ([platform isEqualToString:@"iPad1,1"]) {platform = @"iPad 1";return NO;
    }else if ([platform isEqualToString:@"iPad2,5"]||[platform isEqualToString:@"iPad2,6"]||[platform isEqualToString:@"iPad2,7"]) {platform = @"ipad mini";
    }else if ([platform isEqualToString:@"iPad3,3"]||[platform isEqualToString:@"iPad3,4"]||[platform isEqualToString:@"iPad3,5"]||[platform isEqualToString:@"iPad3,6"]) {platform = @"ipad 3";return NO;
    }
    return YES;
}
//判断ios版本AVAILABLE
- (BOOL)isAvailableIOS:(CGFloat)availableVersion{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=availableVersion) {
        return YES;
    }else{
        return NO;
    }
}
+ (BOOL)validateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    int length =0;
    if (!value) {
        return NO;
    }else {
        length = (int)value.length;
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    if (!areaFlag) {
        return false;
    }
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    int year =0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return false;
    }
}
//判断是否银行卡
+ (BOOL)validateBankCard:(NSString *)cardNo{
    int oddsum = 0;    //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    cardNo = [cardNo substringToIndex:cardNoLength -1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1,1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) ==0)
        return YES;
    else
        return NO;
}
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)openAppStore:(NSString *)appId{
    //    NSString  *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appId];
    //    NSURL *url = [NSURL URLWithString:urlStr];
    //    [[UIApplication sharedApplication]openURL:url];
    SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
    storeProductVC.delegate = self;
    NSDictionary *dict = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];
    [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error){
        if (result){
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:storeProductVC animated:YES completion:nil];
        }
    }];
}
+(NSMutableArray *)imageDictWithImages:(NSMutableArray *)imagearry fileKey:(NSString *)key{
    NSMutableArray *marry=  [NSMutableArray array];
    for (int i=0; i<imagearry.count; i++) {
        UIImage *image=imagearry[i];
        NSMutableDictionary*dic=[NSMutableDictionary dictionary];
        [dic setValue:[NSString stringWithFormat:@"name%d.jpeg",i] forKey:@"fileName"];
        [dic setValue:key forKey:@"fileKey"];
        NSData *imgData=UIImageJPEGRepresentation(image, 1.0);
        [dic setObject:imgData forKey:@"fileData"];
        [marry addObject:dic];
//     @[@{@"fileData":data,@"fileKey":@"image",@"fileName":@"name.jpg"}]
    }return marry;
}
-(void)openSettings:(void (^)(BOOL))block{
    if(NSFoundationVersionNumber<NSFoundationVersionNumber_iOS_8_0){
        block(NO);
    }else{
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication]canOpenURL:url]){
            [[UIApplication sharedApplication]openURL:url options:@{} completionHandler:^(BOOL success) {
                block(success);
            }];
        }else{
            block(NO);
        }
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
