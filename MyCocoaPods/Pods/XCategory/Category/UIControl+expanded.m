//
//  UIControl+Addition.m
//  MyFirstAPP
//
//  Created by 薛超 on 16/8/10.
//  Copyright © 2016年 薛超. All rights reserved.
//

#import "UIControl+expanded.h"

static char UIButtonHandlerKey;
@implementation UIControl (expanded)
- (void)removeAllTargets {
    for (id target in [self allTargets]) {
        [self removeTarget:target action:NULL forControlEvents:UIControlEventAllEvents];
    }
}



- (void)addEventHandler:(ActionBlock)handler forControlEvents:(UIControlEvents)controlEvents
{
    objc_setAssociatedObject(self, &UIButtonHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionHandler:) forControlEvents:controlEvents];
}


- (void)callActionHandler:(id)sender
{
    ActionBlock handler = (ActionBlock)objc_getAssociatedObject(self, &UIButtonHandlerKey);
    if (handler) {
        handler(sender);
    }
}
@end
