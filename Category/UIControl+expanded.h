//
//  UIControl+Addition.h
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@interface UIControl (expanded)
typedef void (^ActionBlock)(id sender);
- (void)removeAllTargets;
- (void)addEventHandler:(ActionBlock)handler forControlEvents:(UIControlEvents)controlEvents;
- (void)callActionHandler;
@end
