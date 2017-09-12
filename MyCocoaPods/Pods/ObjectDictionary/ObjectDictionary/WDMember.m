//
//  WDMember.m
//  WDExtension
//
//  Created by WD on 14-1-15.
//  Copyright (c) 2014年 itcast. All rights reserved.
#import "WDMember.h"
#import "NSObject+Extention.h"
@implementation WDType
- (instancetype)initWithCode:(NSString *)code{
    if (self = [super init]) {
        self.code = code;
    }return self;
}
/** 类型标识符 */
- (void)setCode:(NSString *)code{
    _code = code;
    if (_code.length == 0 || [_code isEqualToString:@":"] ||
        [_code isEqualToString:@"^{objc_ivar=}"] ||
        [_code isEqualToString:@"^{objc_method=}"]) {
        _KVCDisabled = YES;
    } else if ([_code hasPrefix:@"@"] && _code.length > 3) {
        // 去掉@"和"，截取中间的类型名称
        _code = [_code substringFromIndex:2];
        _code = [_code substringToIndex:_code.length - 1];
        _typeClass = NSClassFromString(_code);
        _fromFoundation = [_code hasPrefix:@"NS"];
    }
}
- (NSString *)description{
    return [self wkeyValues].description;
}
@end
@implementation WDArgument
- (NSString *)description{
    return [self wkeyValues].description;
}
@end
@implementation WDMember
/**
 *  初始化
 *  @param srcObject 来源于哪个对象
 *  @return 初始化好的对象
 */
- (instancetype)initWithSrcObject:(id)srcObject{
    if (self = [super init]) {
        _srcObject = srcObject;
    }
    return self;
}
- (void)setSrcClass:(Class)srcClass{
    _srcClass = srcClass;
    _srcClassFromFoundation = [NSStringFromClass(srcClass) hasPrefix:@"NS"];
}
- (NSString *)description{
    return [self wkeyValues].description;
}
@end
@implementation WDIvar
/**
 *  初始化
 *  @param ivar      成员变量
 *  @param srcObject 哪个对象的成员变量
 *  @return 初始化好的对象
 */
- (instancetype)initWithIvar:(Ivar)ivar srcObject:(id)srcObject{
    if (self = [super initWithSrcObject:srcObject]) {
        self.ivar = ivar;
    }return self;
}
/**
 *  设置成员变量
 */
- (void)setIvar:(Ivar)ivar{
    _ivar = ivar;
    // 1.成员变量名
    _name = [NSString stringWithUTF8String:ivar_getName(ivar)];
    // 2.属性名
    if ([_name hasPrefix:@"_"]) {
        _propertyName = [_name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    } else {
        _propertyName = _name;
    }
    // 3.成员变量的类型符
    NSString *code = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
    //    NSLog(@"---%@-%@---", _name, code);
    _type = [[WDType alloc] initWithCode:code];
}
/**
 *  获得成员变量的值
 */
- (id)value{
    if (_type.KVCDisabled) return [NSNull null];
    return [_srcObject valueForKey:_propertyName];
}
/**
 *  设置成员变量的值
 */
- (void)setValue:(id)value{
    if (_type.KVCDisabled) return;
    [_srcObject setValue:value forKey:_propertyName];
}
@end
@implementation WDMethod
/**
 *  初始化
 *  @param method    方法
 *  @param srcObject 哪个对象的方法
 *  @return 初始化好的对象
 */
- (instancetype)initWithMethod:(Method)method srcObject:(id)srcObject{
    if (self = [super initWithSrcObject:srcObject]) {
        self.method = method;
    }return self;
}
/**
 *  设置方法
 */
- (void)setMethod:(Method)method{
    _method = method;
    // 1.方法选择器
    _selector = method_getName(method);
    _name = NSStringFromSelector(_selector);
    // 2.参数
    int step = 2; // 跳过前面的2个参数
    int argsCount = method_getNumberOfArguments(method);
    NSMutableArray *args = [NSMutableArray arrayWithCapacity:argsCount - step];
    for (int i = step; i<argsCount; i++) {
        WDArgument *arg = [[WDArgument alloc] init];
        arg.index = i - step;
        char *argCode = method_copyArgumentType(method, i);
        arg.type = [NSString stringWithUTF8String:argCode];
        free(argCode);
        [args addObject:arg];
    }
    _arguments = args;
    // 3.返回值类型
    char *returnCode = method_copyReturnType(method);
    _returnType = [NSString stringWithUTF8String:returnCode];
    free(returnCode);
}
@end


