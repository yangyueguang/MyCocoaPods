
#import <UIKit/UIKit.h>
@interface KKNavigationController : UINavigationController
@property (nonatomic,strong) UIPanGestureRecognizer *recognizer;
@property (nonatomic,retain) NSMutableArray *screenShotsList;
// 默认为特效开启
@property (nonatomic, assign) BOOL canDragBack;
@end
