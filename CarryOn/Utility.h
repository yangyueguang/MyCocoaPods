
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Utility : NSObject
///单例初始化
+(id)Share;
///获取地址
+(NSString *)getMacAddress;
#pragma mark 功能方法
///打开appid对应的appStore
- (void)openAppStore:(NSString *)appId;
///打电话
- (void)makeCall:(NSString *)phoneNumber;
///振动
-(void)StartSystemShake;
///播放提示音
-(void)playSystemSound;
///类似qq聊天窗口的抖动效果
-(void)shakeViewAnimation:(UIView *)aV;
///view 左右抖动
-(void)leftRightAnimations:(UIView *)view;
@end
