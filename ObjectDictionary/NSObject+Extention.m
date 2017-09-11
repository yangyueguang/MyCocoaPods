//
//  NSObject+Extention.m
//  JuYan
//
//  Created by 55like on 15/11/4.
//  Copyright (c) 2015年 55like. All rights reserved.
//

#import "NSObject+Extention.h"
@implementation NSArray (jsonstr)
-(NSString*)jsonStr{
    NSMutableString*mstr=[NSMutableString new];
    [mstr appendString:@"[\n"];
    for (id obj in self) {
        if ([obj isEqual:self.lastObject]) {
            [mstr appendString:[NSString stringWithFormat:@"%@\n",[self strfrome:obj]]];
        }else{
            [mstr appendString:[NSString stringWithFormat:@"%@,\n",[self strfrome:obj]]];
        }
    }
    [mstr appendString:@"]"];
    return mstr;
}

-(NSString*)strfrome:(id)obj{
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)obj jsonStr];
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"\"%@\"",obj];
    }
    if ([obj isKindOfClass:[NSArray class]]) {
        return [(NSArray*)obj jsonStr];
    }
    return [[obj wkeyValues] jsonStr];
}
-(NSString *)jsonStrSYS{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end

@implementation NSDictionary (JSONSTR)
-(NSString*)jsonStr{
    NSMutableString*mstr=[NSMutableString new];
    [mstr appendString:@"{\n"];
    NSArray*keyArry=[self allKeys];
    for (NSString *keyname in keyArry) {
        if ([keyname isEqual:[keyArry lastObject]]) {
            [mstr appendString:[NSString stringWithFormat:@"\"%@\":%@\n",keyname,[self strfrome:keyname]]];
        }else
            [mstr appendString:[NSString stringWithFormat:@"\"%@\":%@,\n",keyname,[self strfrome:keyname]]];
    }
    [mstr appendString:@"}\n"];
    return mstr;
}
-(NSString*)strfrome:(NSString*)key{
    id hh=[self JsonObjKey:key];
    if ([hh isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)hh jsonStr];
    }
    if ([hh isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"\"%@\"",hh];
    }
    if ([hh isKindOfClass:[NSArray class]]) {
        return [(NSArray*)hh jsonStr];
    }
    return [[hh wkeyValues] jsonStr];
}
-(NSString *)jsonStrSYS{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
-(NSString *)description{
    return self.jsonStrSYS;
}
@end

@implementation NSObject (Extention)
-(id)JsonObjKey:(NSString*)key{
    
    id dic=self;
    if (![self isKindOfClass:[NSDictionary class]]) {
        return @"";
    }
    
    NSDictionary*dict=dic;
    id value=  [dict objectForKey:key];
    //    id value = [self objectForKey:aKey];
    if (!value||value==[NSNull null]) {
        return @"";
    }else{
        if ([value isKindOfClass:[NSNumber class]]) {
            return [NSString stringWithFormat:@"%@",value];
        }
        else if([value isKindOfClass:[NSString class]]){
            if ([value isEqualToString:@""] || [value isEqualToString:@"null"]) {
                return  @"";
            }
        }
        return value;
    }
    //    return value;
}
/**
 *  遍历所有的成员变量
 */
- (void)enumerateIvarsWithBlock:(WDIvarsBlock)block
{
    [self enumerateClassesWithBlock:^(__unsafe_unretained Class c, BOOL *stop) {
        // 1.获得所有的成员变量
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList(c, &outCount);
        
        // 2.遍历每一个成员变量
        for (int i = 0; i<outCount; i++) {
            WDIvar *ivar = [[WDIvar alloc] initWithIvar:ivars[i] srcObject:self];
            ivar.srcClass = c;
            block(ivar, stop);
        }
        
        // 3.释放内存
        free(ivars);
    }];
}

/**
 *  遍历所有的方法
 */
- (void)enumerateMethodsWithBlock:(WDMethodsBlock)block
{
    [self enumerateClassesWithBlock:^(__unsafe_unretained Class c, BOOL *stop) {
        // 1.获得所有的成员变量
        unsigned int outCount = 0;
        Method *methods = class_copyMethodList(c, &outCount);
        
        // 2.遍历每一个成员变量
        for (int i = 0; i<outCount; i++) {
            WDMethod *method = [[WDMethod alloc] initWithMethod:methods[i] srcObject:self];
            method.srcClass = c;
            block(method, stop);
        }
        
        // 3.释放内存
        free(methods);
    }];
}

/**
 *  遍历所有的类
 */
- (void)enumerateClassesWithBlock:(WDClassesBlock)block
{
    // 1.没有block就直接返回
    if (block == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = [self class];
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        block(c, &stop);
        
        // 4.2.获得父类
        c = class_getSuperclass(c);
    }
}

/**
 *  通过字典来创建一个模型
 *  @param keyValues 字典
 *  @return 新建的对象
 */
+ (instancetype)wobjectWithKeyValues:(NSDictionary *)keyValues
{
    if (![keyValues isKindOfClass:[NSDictionary class]]) {
        return nil;
        [NSException raise:@"keyValues is not a NSDictionary" format:nil];
    }
    
    id model = [[self alloc] init];
    [model setwKeyValues:keyValues];
    return model;
}

/**
 *  通过plist来创建一个模型
 *  @param filename 文件名(仅限于mainBundle中的文件)
 *  @return 新建的对象
 */
+ (instancetype)wobjectWithFilename:(NSString *)filename
{
    NSString *file = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    return [self wobjectWithFile:file];
}

/**
 *  通过plist来创建一个模型
 *  @param file 文件全路径
 *  @return 新建的对象
 */
+ (instancetype)wobjectWithFile:(NSString *)file
{
    NSDictionary *keyValues = [NSDictionary dictionaryWithContentsOfFile:file];
    return [self wobjectWithKeyValues:keyValues];
}

/**
 *  将字典的键值对转成模型属性
 *  @param keyValues 字典
 */
- (void)setwKeyValues:(NSDictionary *)keyValues
{
    if (![keyValues isKindOfClass:[NSDictionary class]]) {
        //        [NSException raise:@"keyValues is not a NSDictionary" format:nil];
        return;
    }
    
    [self enumerateIvarsWithBlock:^(WDIvar *ivar, BOOL *stop) {
        // 来自Foundation框架的成员变量，直接返回
        if (ivar.isSrcClassFromFoundation) return;
        
        // 1.取出属性值
        NSString *key = [self keyWithPropertyName:ivar.propertyName];
        id value = keyValues[key];
        if (!value) return;
        
        // 2.如果是模型属性
        if (ivar.type.typeClass && !ivar.type.fromFoundation) {
            value = [ivar.type.typeClass wobjectWithKeyValues:value];
        } else if ([self respondsToSelector:@selector(wobjectClassInArray)]) {
            // 3.字典数组-->模型数组
            Class objectClass = self.wobjectClassInArray[ivar.propertyName];
            if (objectClass) {
                if ([value isKindOfClass:[NSArray class]]) {
                    value = [objectClass wobjectArrayWithKeyValuesArray:value];
                }else return;
                
            }
        }
        if ([value isKindOfClass:[NSNumber class]]) {
            NSNumber *ff=value;
            value =[NSString stringWithFormat:@"%@",ff];
        }
        if (!value||value==[NSNull null]) {
            //            return ;
            value=@"";
        }
        if([value isKindOfClass:[NSString class]]){
            if ([value isEqualToString:@"null"]) {
                //                return  ;
                value=@"";
                //                [value objectForJSONKey:@""];
                
                
            }
        }
        // 4.赋值
        ivar.value = value;
    }];
}

/**
 *  将模型转成字典
 *  @return 字典
 */
- (NSDictionary *)wkeyValues
{
    NSMutableDictionary *keyValues = [NSMutableDictionary dictionary];
    
    [self enumerateIvarsWithBlock:^(WDIvar *ivar, BOOL *stop) {
        if (ivar.isSrcClassFromFoundation) return;
        
        // 1.取出属性值
        id value = ivar.value;
        if (!value) return;
        
        // 2.如果是模型属性
        if (ivar.type.typeClass && !ivar.type.fromFoundation) {
            value = [value wkeyValues];
        } else if ([self respondsToSelector:@selector(wobjectClassInArray)]) {
            // 3.处理数组里面有模型的情况
            Class objectClass = self.wobjectClassInArray[ivar.propertyName];
            if (objectClass) {
                value = [objectClass wkeyValuesArrayWithObjectArray:value];
            }
        }
        
        // 4.赋值
        NSString *key = [self keyWithPropertyName:ivar.propertyName];
        keyValues[key] = value;
    }];
    
    return keyValues;
}

/**
 *  通过模型数组来创建一个字典数组
 *  @param objectArray 模型数组
 *  @return 字典数组
 */
+ (NSArray *)wkeyValuesArrayWithObjectArray:(NSArray *)objectArray
{
    // 0.判断真实性
    if (![objectArray isKindOfClass:[NSArray class]]) {
        [NSException raise:@"objectArray is not a NSArray" format:nil];
    }
    
    // 1.过滤
    if (![objectArray isKindOfClass:[NSArray class]]) return objectArray;
    if (![[objectArray lastObject] isKindOfClass:self]) return objectArray;
    
    // 2.创建数组
    NSMutableArray *keyValuesArray = [NSMutableArray array];
    for (id object in objectArray) {
        [keyValuesArray addObject:[object wkeyValues]];
    }
    return keyValuesArray;
}

#pragma mark - 字典数组转模型数组
/**
 *  通过字典数组来创建一个模型数组
 *  @param keyValuesArray 字典数组
 *  @return 模型数组
 */
+ (NSArray *)wobjectArrayWithKeyValuesArray:(NSArray *)keyValuesArray
{
    // 1.判断真实性
    if (![keyValuesArray isKindOfClass:[NSArray class]]) {
        [NSException raise:@"keyValuesArray is not a NSArray" format:nil];
    }
    
    // 2.创建数组
    NSMutableArray *modelArray = [NSMutableArray array];
    
    // 3.遍历
    for (NSDictionary *keyValues in keyValuesArray) {
        if (![keyValues isKindOfClass:[NSDictionary class]]) continue;
        
        id model = [self wobjectWithKeyValues:keyValues];
        [modelArray addObject:model];
    }
    
    return modelArray;
}

/**
 *  通过plist来创建一个模型数组
 *  @param filename 文件名(仅限于mainBundle中的文件)
 *  @return 模型数组
 */
+ (NSArray *)wobjectArrayWithFilename:(NSString *)filename
{
    NSString *file = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    return [self wobjectArrayWithFile:file];
}

/**
 *  通过plist来创建一个模型数组
 *  @param file 文件全路径
 *  @return 模型数组
 */
+ (NSArray *)wobjectArrayWithFile:(NSString *)file
{
    NSArray *keyValuesArray = [NSArray arrayWithContentsOfFile:file];
    return [self wobjectArrayWithKeyValuesArray:keyValuesArray];
}

#pragma mark - 私有方法
/**
 *  根据属性名获得对应的key
 *
 *  @param propertyName 属性名
 *
 *  @return 字典的key
 */
- (NSString *)keyWithPropertyName:(NSString *)propertyName
{
    NSString *key = nil;
    // 1.查看有没有需要替换的key
    if ([self respondsToSelector:@selector(wreplacedKeyFromPropertyName)]) {
        key = self.wreplacedKeyFromPropertyName[propertyName];
    }
    // 2.用属性名作为key
    if (!key) key = propertyName;
    
    return key;
}
-(NSString *)wgetParamStr{
    NSDictionary*dictionary=self.wkeyValues;
    if ([self isKindOfClass:[NSDictionary class]]) {
        id sl=self;
        dictionary =sl;
    }
    
    
    
    NSArray*keyArry=[dictionary allKeys];
    NSMutableString*mstr=[NSMutableString new];
    for (NSString *keyname in keyArry) {
        NSString*value=[dictionary objectForKey:keyname];
        
        if([value isKindOfClass:[NSString class]]){
            if ([keyname isEqual:[keyArry firstObject ]]) {
                [mstr appendFormat:@"?%@=%@",keyname,value];
            }else{
                
                [ mstr appendFormat:@"&%@=%@",keyname,value];
                
            }
        }
    }
    
    
    //    1. //字符串加百分号转义使用编码 (这个方法会把参数里面的东西转义)
    //
    //    NSString *str1 = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //
    //    2.//字符串替换百分号转义使用编码
    //
    //    NSString *str1 = [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return mstr;
    
}
-(void)setWgetParamStr:(NSString *)wgetParamStr{
    
    
}
/**
 *  编码（将对象写入文件中）
 */
- (void)encode:(NSCoder *)encoder
{
    [self enumerateIvarsWithBlock:^(WDIvar *ivar, BOOL *stop) {
        if (ivar.isSrcClassFromFoundation) return;
        [encoder encodeObject:ivar.value forKey:ivar.name];
    }];
}

/**
 *  解码（从文件中解析对象）
 */
- (void)decode:(NSCoder *)decoder
{
    [self enumerateIvarsWithBlock:^(WDIvar *ivar, BOOL *stop) {
        if (ivar.isSrcClassFromFoundation) return;
        ivar.value = [decoder decodeObjectForKey:ivar.name];
    }];
}
@end
