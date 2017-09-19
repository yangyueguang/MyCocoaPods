//
//  UINavigationBar+expanded.h
//  薛超APP框架
//
//  Created by Super on 2017/6/1.
//  Copyright © 2017年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (expanded)
/** 设置导航栏背景颜色*/
- (void)wr_setBackgroundColor:(UIColor *)color;

- (void)wr_setBackgroundAplha:(CGFloat)alpha;

/** 设置导航栏所有BarButtonItem的透明度 */
- (void)wr_setBarButtonItemsAlpha:(CGFloat)alpha hasSystemBackIndicator:(BOOL)hasSystemBackIndicator;

/** 设置导航栏在垂直方向上平移多少距离 */
- (void)wr_setTranslationY:(CGFloat)translationY;

/** 清除在导航栏上设置的背景颜色、透明度、位移距离等属性 */
- (void)wr_clear;
@end
