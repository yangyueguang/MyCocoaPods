
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Utility : NSObject
///单例初始化
+(id)Share;
///获取地址
+(NSString *)getMacAddress;
///格式化电话号码
-(NSString *)FormatPhone:(NSString *)str;
///格式化身份证号
-(NSString *)FormatIDC:(NSString *)str;
///格式化组织机构代码证
-(NSString *)FormatOCC:(NSString *)str;
///格式化车牌号
-(NSString *)FormatPlate:(NSString *)str;
///格式化车辆识别码vin
-(NSString *)FormatVin:(NSString *)str;
///数字格式化
-(NSString*)FormatNumStr:(NSString*)nf;
///判断是否为整形
- (BOOL)isPureInt:(NSString*)string;
///判断是否为浮点形
- (BOOL)isPureFloat:(NSString*)string;
///是否支持蓝牙协议4.0
- (BOOL)isSupportBluetoothProtocol;
///验证邮箱
- (BOOL)validateEmail:(NSString *)candidate;
///验证手机号
- (BOOL)validateTel:(NSString *)candidate;
+ (BOOL)validateIDCardNumber:(NSString *)value;
+ (BOOL)validateBankCard:(NSString *)cardNo;
///判断ios版本是否高于当前版本要求
- (BOOL)isAvailableIOS:(CGFloat)availableVersion;
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
///把图片变成可上传的参数类型
+(NSMutableArray*)imageDictWithImages:(NSMutableArray*)imagearry fileKey:(NSString*)key;
+ (void)hidNavLine:(UIViewController *)vc;
+ (void)showNavLine:(UIViewController *)vc;
@end
