
#import <Foundation/Foundation.h>
@interface NSObject (expanded)
//perfrom for bool
- (void)performSelector:(SEL)aSelector withBool:(BOOL)aValue;
- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects;
- (id)performSelector:(SEL)aSelector withParameters:(void *)firstParameter, ...;
///将NSArray或者NSDictionary转化为NSString
-(NSString *)JSONString;
-(NSString *)tojsonstring;
///将NSArray或者NSDictionary转化为NSString
-(NSString *)JSONString_l;
@end
