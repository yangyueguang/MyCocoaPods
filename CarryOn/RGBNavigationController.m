#import "RGBNavigationController.h"
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kVersion7  ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
// 背景视图起始frame.x
#define startX -200;
@interface RGBNavigationController ()<UIGestureRecognizerDelegate>{
    CGPoint startTouch;
    UIImageView *lastScreenShotView;
    UIView *blackMask;
    CGFloat startBackViewX;
}
//这是测试只获取分支而改动的文件夹
@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,assign) BOOL isMoving;
@end
@implementation RGBNavigationController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {    }
    return self;
}
- (void)dealloc{
    self.screenShotsList = nil;
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
    self.canDragBack = YES;
    _recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(paningGestureReceive:)];
    _recognizer.delegate=self;
    [_recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:_recognizer];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self.screenShotsList addObject:[self capture]];
    [super pushViewController:viewController animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated{

    [self.screenShotsList removeLastObject];
    return [super popViewControllerAnimated:animated];
}
-(NSArray *)popToRootViewControllerAnimated:(BOOL)animated{

    [self.screenShotsList removeAllObjects];
    return [super popToRootViewControllerAnimated:animated];
}
-(NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{

    int count=(int)[self.viewControllers count];
    for (int i=count-1; i>=0; i--) {
        UIViewController *tempC=[self.viewControllers objectAtIndex:i];
        if ([NSStringFromClass([viewController class]) isEqualToString:NSStringFromClass([tempC class])]) {
            break;
        }
        [self.screenShotsList removeLastObject];
    }
    return [super popToViewController:viewController animated:animated];
}
#pragma mark - Utility Methods -
- (UIImage *)capture{
    UIGraphicsBeginImageContextWithOptions(self.view.window.bounds.size, self.view.opaque, 0.0);
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
- (void)moveViewWithX:(float)x{
    x = x>kScreenWidth?kScreenWidth:x;
    x = x<0?0:x;
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    float alpha = 0.4 - (x/800);
    blackMask.alpha = alpha;
    
    CGFloat y = x * abs((int)startBackViewX)/kScreenWidth;
    CGFloat lastScreenShotViewHeight =kScreenHeight;//kVersion7? kkBackViewHeight:kkBackViewHeight-20;//
    [lastScreenShotView setFrame:CGRectMake(startBackViewX+y,0,kScreenWidth, lastScreenShotViewHeight)];
}
-(BOOL)isBlurryImg:(CGFloat)tmp{
    return YES;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if(self.canDragBack) return YES;
    else return NO;
}
#pragma mark - Gesture Recognizer -
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer{
    if (self.backgroundView) { self.backgroundView = nil; }
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    CGPoint touchPoint = [recoginzer locationInView:[[UIApplication sharedApplication]keyWindow]];
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        _isMoving = YES;
        startTouch = touchPoint;
        if (!self.backgroundView){
            CGRect frame =[UIScreen mainScreen].bounds;// self.view.frame;
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:blackMask];
        }
        self.backgroundView.hidden = NO;
        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        startBackViewX = startX;
        [lastScreenShotView setFrame:CGRectMake(startBackViewX,lastScreenShotView.frame.origin.y,lastScreenShotView.frame.size.height,lastScreenShotView.frame.size.width)];
        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        if (touchPoint.x - startTouch.x > 50){
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:kScreenWidth];
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                _isMoving = NO;
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
        }
        return;
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        return;
    }
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}
@end
