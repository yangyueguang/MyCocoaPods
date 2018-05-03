//
//  UIControl+Addition.m
#import "UIControl+expanded.h"
static char UIButtonHandlerKey;
@implementation UIControl (expanded)
- (void)removeAllTargets {
    for (id target in [self allTargets]) {
        [self removeTarget:target action:NULL forControlEvents:UIControlEventAllEvents];
    }
}
- (void)addEventHandler:(ActionBlock)handler forControlEvents:(UIControlEvents)controlEvents{
    objc_setAssociatedObject(self, &UIButtonHandlerKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionHandler) forControlEvents:controlEvents];
}
- (void)callActionHandler{
    ActionBlock handler = (ActionBlock)objc_getAssociatedObject(self, &UIButtonHandlerKey);
    if (handler) {
        handler(self);
    }
}
@end
