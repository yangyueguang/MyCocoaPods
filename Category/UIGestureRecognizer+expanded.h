//
#import <UIKit/UIKit.h>
@interface UIGestureRecognizer (YYAdd)
- (instancetype)initWithActionBlock:(void (^)(id sender))block;
- (void)addActionBlock:(void (^)(id sender))block;
- (void)removeAllActionBlocks;
@end
