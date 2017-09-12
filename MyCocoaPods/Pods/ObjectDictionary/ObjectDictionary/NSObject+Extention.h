//
//  NSObject+Extention.h
//  JuYan
//
//  Created by 55like on 15/11/4.
//  Copyright (c) 2015年 55like. All rights reserved.
#import <Foundation/Foundation.h>
#import "WDMember.h"
//遍历所有类的block（父类）
typedef void (^WDClassesBlock)(Class c, BOOL *stop);
@protocol WDKeyValue <NSObject>
@optional
//将属性名换为其他key去字典中取值  @return 字典中的key是属性名，value是从字典中取值用的key
- (NSDictionary *)wreplacedKeyFromPropertyName;
//数组中需要转换的模型类@return 字典中的key是数组属性名，value是数组中存放模型的Class
- (NSDictionary *)wobjectClassInArray;
@end
@interface NSArray (jsonstr)
-(NSString*)jsonStr;
-(NSString*)jsonStrSYS;
@end
@interface NSDictionary (JSONSTR)
-(NSString*)jsonStr;
-(NSString*)jsonStrSYS;
@end

@interface NSObject (Extention)<WDKeyValue>
-(id)JsonObjKey:(NSString*)key;
/**
 *  遍历所有的成员变量
 */
- (void)enumerateIvarsWithBlock:(WDIvarsBlock)block;

/**
 *  遍历所有的方法
 */
- (void)enumerateMethodsWithBlock:(WDMethodsBlock)block;

/**
 *  遍历所有的类
 */
- (void)enumerateClassesWithBlock:(WDClassesBlock)block;
@property(nonatomic,copy)NSString*wgetParamStr;
#pragma mark 模型转字典
/**
 *  将字典的键值对转成模型属性
 *  @param keyValues 字典
 */
- (void)setwKeyValues:(NSDictionary *)keyValues;

/**
 *  将模型转成字典
 *  @return 字典
 */
- (NSDictionary *)wkeyValues;

/**
 *  通过模型数组来创建一个字典数组
 *  @param objectArray 模型数组
 *  @return 字典数组
 */
+ (NSArray *)wkeyValuesArrayWithObjectArray:(NSArray *)objectArray;

#pragma mark - 字典转模型
/**
 *  通过字典来创建一个模型
 *  @param keyValues 字典
 *  @return 新建的对象
 */
+ (instancetype)wobjectWithKeyValues:(NSDictionary *)keyValues;

/**
 *  通过plist来创建一个模型
 *  @param filename 文件名(仅限于mainBundle中的文件)
 *  @return 新建的对象
 */
+ (instancetype)wobjectWithFilename:(NSString *)filename;

/**
 *  通过plist来创建一个模型
 *  @param file 文件全路径
 *  @return 新建的对象
 */
+ (instancetype)wobjectWithFile:(NSString *)file;

#pragma mark - 字典数组转模型数组
/**
 *  通过字典数组来创建一个模型数组
 *  @param keyValuesArray 字典数组
 *  @return 模型数组
 */
+ (NSArray *)wobjectArrayWithKeyValuesArray:(NSArray *)keyValuesArray;

/**
 *  通过plist来创建一个模型数组
 *  @param filename 文件名(仅限于mainBundle中的文件)
 *  @return 模型数组
 */
+ (NSArray *)wobjectArrayWithFilename:(NSString *)filename;

/**
 *  通过plist来创建一个模型数组
 *  @param file 文件全路径
 *  @return 模型数组
 */
+ (NSArray *)wobjectArrayWithFile:(NSString *)file;

/**
 *  解码（从文件中解析对象）
 */
- (void)decode:(NSCoder *)decoder;
/**
 *  编码（将对象写入文件中）
 */
- (void)encode:(NSCoder *)encoder;
@end
