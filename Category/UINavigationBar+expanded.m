//
//  UINavigationBar+expanded.m
//  薛超APP框架
//
//  Created by Super on 2017/6/1.
//  Copyright © 2017年 薛超. All rights reserved.
//

#import "UINavigationBar+expanded.h"
#import <objc/runtime.h>

#define StatusBarHeight  [UIApplication sharedApplication].statusBarFrame.size.height

@implementation UINavigationBar (expanded)
static char kBackgroundViewKey;
static int kNavBarBottom = 64;
- (UIView*)backgroundView{
    return objc_getAssociatedObject(self, &kBackgroundViewKey);
}
- (void)setBackgroundView:(UIView*)backgroundView{
    objc_setAssociatedObject(self, &kBackgroundViewKey, backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)wr_setBackgroundColor:(UIColor *)color{
    if (self.backgroundView == nil){
        // 设置导航栏本身全透明
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.frame.size.height + StatusBarHeight)];
        // _UIBarBackground是导航栏的第一个子控件
        [self.subviews.firstObject insertSubview:self.backgroundView atIndex:0];
        // 隐藏导航栏底部默认黑线
        [self setShadowImage:[UIImage new]];
    }
    self.backgroundView.backgroundColor = color;
}

- (void)wr_setBackgroundAplha:(CGFloat)alpha
{
    if (self.backgroundView != nil) {
        self.backgroundView.alpha = alpha;
    }
}

- (void)wr_setBarButtonItemsAlpha:(CGFloat)alpha hasSystemBackIndicator:(BOOL)hasSystemBackIndicator{
    for (UIView *view in self.subviews){
        if (hasSystemBackIndicator == YES){
            // _UIBarBackground对应的view是系统导航栏，不需要改变其透明度
            if (![view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                view.alpha = alpha;
            }
        }else{
            // 这里如果不做判断的话，会显示 backIndicatorImage
            if (![view isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")] && ![view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                view.alpha = alpha;
            }
        }
    }
}
- (void)wr_setTranslationY:(CGFloat)translationY{
    // CGAffineTransformMakeTranslation  平移
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}
- (void)wr_clear{
    // 设置导航栏不透明
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

@end
