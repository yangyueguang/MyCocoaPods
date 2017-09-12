//
//  UILabel+expanded.h
//  薛超APP框架
//
//  Created by 薛超 on 16/9/8.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (expanded)
-(void)lableCopy;

+(UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext;
+(UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext textAlignment:(NSTextAlignment)aalignment;
+(UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext textAlignment:(NSTextAlignment)aalignment setLineSpacing:(float)afloat;
@end
