//
//  UIControl+Addition.h
//  MyFirstAPP
//
//  Created by 薛超 on 16/8/10.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <objc/runtime.h>
@interface UIControl (expanded)
typedef void (^ActionBlock)(id sender);
- (void)removeAllTargets;
- (void)addEventHandler:(ActionBlock)handler forControlEvents:(UIControlEvents)controlEvents;
- (void)callActionHandler:(UIButton*)sender;
@end
