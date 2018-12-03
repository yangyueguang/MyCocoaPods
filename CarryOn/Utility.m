
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
@end
