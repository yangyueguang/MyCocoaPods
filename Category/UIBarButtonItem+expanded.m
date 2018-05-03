//
//  UIBarButtonItem+expanded.m
#import "UIBarButtonItem+expanded.h"
char * const UIBarButtonItemActionBlock = "UIBarButtonItemActionBlock";
#import <objc/runtime.h>
@implementation UIBarButtonItem (expanded)
+ (id)fixItemSpace:(CGFloat)space{
    UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fix.width = space;
    return fix;
}
- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style actionBlick:(BarButtonActionBlock)actionBlock{
    if (self = [self initWithTitle:title style:style target:nil action:nil]) {
        [self setActionBlock:actionBlock];
    }
    return self;
}
- (id)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style actionBlick:(BarButtonActionBlock)actionBlock{
    if (self = [self initWithImage:image style:style target:nil action:nil]) {
        [self setActionBlock:actionBlock];
    }
    return self;
}
- (id)initWithBackTitle:(NSString *)title target:(id)target action:(SEL)action{
    UIButton *view = [[UIButton alloc] init];
    [view addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_back"]];
    [view addSubview:imageView];
    UILabel *label = [[UILabel alloc] init];
    [label setText:title];
    [label setTextColor:[UIColor whiteColor]];
    [view addSubview:label];
    if (self = [self initWithCustomView:view]) {
        [imageView setFrame:CGRectMake(0, 0, 17, 34)];
        CGSize size = [label sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        [label setFrame:CGRectMake(17, 0, size.width, 34)];
        [view setFrame:CGRectMake(0, 0, label.frame.origin.x+label.frame.size.width, 34)];
    }
    return self;
}
- (void)performActionBlock {
    dispatch_block_t block = self.actionBlock;
    if (block)block();
}
- (BarButtonActionBlock)actionBlock {
    return objc_getAssociatedObject(self, UIBarButtonItemActionBlock);
}
- (void)setActionBlock:(BarButtonActionBlock)actionBlock{
    if (actionBlock != self.actionBlock) {
        [self willChangeValueForKey:@"actionBlock"];
        objc_setAssociatedObject(self,UIBarButtonItemActionBlock,
                                 actionBlock,OBJC_ASSOCIATION_COPY);
        [self setTarget:self];
        [self setAction:@selector(performActionBlock)];
        [self didChangeValueForKey:@"actionBlock"];
    }
}
+ (UIBarButtonItem *)initWithNormalImage:(NSString *)image target:(id)target action:(SEL)action width:(CGFloat)width height:(CGFloat)height{
    UIImage *normalImage = [UIImage imageNamed:image];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, width, height);
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
+ (UIBarButtonItem *)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}
+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image heighlightImage:(NSString *)heilightImage {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:heilightImage] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y, btn.currentBackgroundImage.size.width,btn.currentBackgroundImage.size.height);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}
@end
