//
//  UIBarButtonItem+expanded.h
//  MyFirstAPP
//
//  Created by 薛超 on 17/1/18.
//  Copyright © 2017年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BarButtonActionBlock)();
@interface UIBarButtonItem (expanded)

+ (id)fixItemSpace:(CGFloat)space;

- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style actionBlick:(BarButtonActionBlock)actionBlock;

- (id)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style actionBlick:(BarButtonActionBlock)actionBlock;

- (id)initWithBackTitle:(NSString *)title target:(id)target action:(SEL)action;

/// A block that is run when the UIBarButtonItem is tapped.
//@property (nonatomic, copy) dispatch_block_t actionBlock;
- (void)setActionBlock:(BarButtonActionBlock)actionBlock;

/**
 *根据图片快速创建一个UIBarButtonItem，自定义大小
 */
+ (UIBarButtonItem *)initWithNormalImage:(NSString *)image target:(id)target action:(SEL)action width:(CGFloat)width height:(CGFloat)height;

+ (UIBarButtonItem *)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action;

+(UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image heighlightImage:(NSString *)heilightImage;
@end
