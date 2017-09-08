

#import "NSObject+expanded.h"
@implementation NSObject (expanded)
- (void)performSelector:(SEL)aSelector withBool:(BOOL)aValue
{
    BOOL myBoolValue = aValue; // or NO
    
    NSMethodSignature* signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature: signature];
    [invocation setTarget: self];
    [invocation setSelector: aSelector];
    [invocation setArgument: &myBoolValue atIndex: 2];
    [invocation invoke];
}

- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects {
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:aSelector];
    
    NSUInteger i = 1;
    for (id object in objects) {
        [invocation setArgument:(__bridge void *)(object) atIndex:++i];
    }
    [invocation invoke];
    
    if ([signature methodReturnLength]) {
        id data;
        [invocation getReturnValue:&data];
        return data;
    }
    return nil;
}

- (id)performSelector:(SEL)aSelector withParameters:(void *)firstParameter, ... {
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    NSUInteger length = [signature numberOfArguments];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:aSelector];
    
    [invocation setArgument:&firstParameter atIndex:2];
    va_list arg_ptr;
    va_start(arg_ptr, firstParameter);
    for (NSUInteger i = 3; i < length; ++i) {
        void *parameter = va_arg(arg_ptr, void *);
        [invocation setArgument:&parameter atIndex:i];
    }
    va_end(arg_ptr);
    
    [invocation invoke];
    
    if ([signature methodReturnLength]) {
        id data;
        [invocation getReturnValue:&data];
        return data;
    }
    return nil;
}
///将NSArray或者NSDictionary转化为NSString
-(NSString *)JSONString
{
    NSError* error = nil;
    id data = [NSJSONSerialization dataWithJSONObject:self
                                              options:kNilOptions
                                                error:&error];
    if (error != nil){
        NSLog(@"JSON Parsing Error: %@", error);
        return nil ;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

-(NSString *)tojsonstring
{
    NSError* error = nil;
    id data = [NSJSONSerialization dataWithJSONObject:self
                                              options:kNilOptions
                                                error:&error];
    if (error != nil){
        NSLog(@"JSON Parsing Error: %@", error);
        return nil ;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

-(NSString *)JSONString_l{
    NSError* error = nil;
    id data = [NSJSONSerialization dataWithJSONObject:self
                                              options:kNilOptions
                                                error:&error];
    if (error != nil){
        NSLog(@"JSON Parsing Error: %@", error);
        return nil ;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


@end
