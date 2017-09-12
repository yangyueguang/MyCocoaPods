
#import "Utility.h"
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <AudioToolbox/AudioToolbox.h>//振动
#import <CommonCrypto/CommonDigest.h>
#import <StoreKit/StoreKit.h>
#import <NSString_expanded/NSString+expanded.h>

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
    return macAddressString.md5;
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

-(NSString *)timeToNow:(NSString *)theDate{
    NSString *timeString=@"";
    if (!theDate) {return @"";}
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[NSDate dateWithTimeIntervalSince1970:[theDate integerValue]];
    if (!d) {return theDate;}
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSTimeInterval cha=(now-late)>0 ? (now-late) : 0;
    if (cha/60<1) {
        timeString=@"刚刚";
    }else if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@ 分前", timeString];
    }else if (cha/3600>1 && cha/3600<12) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@ 小时前", timeString];
    }else if(cha/3600<24){
        timeString = @"今天";
    }else if(cha/3600<48){
        timeString = @"昨天";
    }else if(cha/3600/24<10){
        timeString = [NSString stringWithFormat:@"%.0f 天前",cha/3600/24];
    }else if(cha/3600/24<365){
        [dateFormatter setDateFormat:@"MM月dd日"];
        timeString=[dateFormatter stringFromDate:d];
    }else{
        timeString = [NSString stringWithFormat:@"%d年前",(int)cha/3600/24/365];
    }
    return timeString;
}
//时间戳
-(NSString *)timeToTimestamp:(NSString *)timestamp{
    if (!timestamp) {return @"";}
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *aTime = [NSDate dateWithTimeIntervalSince1970:[timestamp integerValue]];
    NSString *str=[dateFormatter stringFromDate:aTime];
    return str;
}


#pragma mark 元件创建
+ (UITextField *)textFieldlWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor placeholder:(NSString *)aplaceholder text:(NSString*)atext{
    UITextField *baseTextField=[[UITextField alloc]initWithFrame:aframe];
    [baseTextField setKeyboardType:UIKeyboardTypeDefault];
    [baseTextField setBorderStyle:UITextBorderStyleNone];
    [baseTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [baseTextField setTextColor:acolor];
    baseTextField.placeholder=aplaceholder;
    baseTextField.font=afont;
    [baseTextField setSecureTextEntry:NO];
    [baseTextField setReturnKeyType:UIReturnKeyDone];
    [baseTextField setText:atext];
    baseTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return baseTextField;
}

+(UIImageView*)imageviewWithFrame:(CGRect)_frame defaultimage:(NSString*)_image{
    return [self imageviewWithFrame:_frame defaultimage:_image stretchW:0 stretchH:0];
}
//-1 if want stretch half of image.size
+(UIImageView*)imageviewWithFrame:(CGRect)_frame defaultimage:(NSString*)_image stretchW:(NSInteger)_w stretchH:(NSInteger)_h{
    UIImageView *imageview = nil;
    if(_image){
        if (_w&&_h) {
            UIImage *image = [UIImage imageNamed:_image];
            if (_w==-1) {
                _w = image.size.width/2;
            }
            if(_h==-1){
                _h = image.size.height/2;
            }
            imageview = [[UIImageView alloc] initWithImage:[image stretchableImageWithLeftCapWidth:_w topCapHeight:_h]];
            imageview.contentMode=UIViewContentModeScaleToFill;
        }else{
            imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_image]];
            imageview.contentMode=UIViewContentModeScaleAspectFill;
        }
    }
    if (CGRectIsEmpty(_frame)) {
        [imageview setFrame:CGRectMake(_frame.origin.x,_frame.origin.y, imageview.image.size.width, imageview.image.size.height)];
    }else{
        [imageview setFrame:_frame];
    }
    imageview.clipsToBounds=YES;
    return  imageview;
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
-(NSString *)VersionSelect{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}
#pragma mark 版本更新
- (void)upDataVersion{
//    NSString *version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    NSString *s = [NSString stringWithContentsOfURL:[NSURL URLWithString:@""] encoding:NSUTF8StringEncoding error:nil];

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

#pragma mark 新增的方法
+ (NSDictionary *)dictFromLocalJsonFileName:(NSString *)name{
    if (name == nil) return nil;
    NSString *pathr=[[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSString *jsonString=[[NSString alloc] initWithContentsOfFile:pathr encoding:NSUTF8StringEncoding error:nil];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {NSLog(@"json解析失败：%@",err);return nil;}
    return dic;
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
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
