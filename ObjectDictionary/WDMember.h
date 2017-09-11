//
//  WDMember.h
//  WDExtension
//
//  Created by WD on 14-1-15.
//  Copyright (c) 2014年 itcast. All rights reserved.
#import <Foundation/Foundation.h>
#import <objc/message.h>
/**
 *  包装一种类型
 */
@interface WDType : NSObject
/** 类型标识符 */
@property (nonatomic, copy) NSString *code;
/** 对象类型（如果是基本数据类型，此值为nil） */
@property (nonatomic, assign, readonly) Class typeClass;
/** 类型是否来自于Foundation框架，比如NSString、NSArray */
@property (nonatomic, readonly, getter = isFromFoundation) BOOL fromFoundation;
/** 类型是否不支持KVC */
@property (nonatomic, readonly, getter = isKVCDisabled) BOOL KVCDisabled;
/**
 *  初始化一个类型对象
 *  @param code 类型标识符
 */
- (instancetype)initWithCode:(NSString *)code;
@end
/**
 *  包装一个方法参数
 */
@interface WDArgument : NSObject
/** 参数的索引 */
@property (nonatomic, assign) int index;
/** 参数类型 */
@property (nonatomic, copy) NSString *type;
@end
@interface WDMember : NSObject{
    __weak id _srcObject;
    Class _srcClass;
    NSString *_name;
}
/** 成员来源于哪个类（可能是父类） */
@property (nonatomic, assign) Class srcClass;
/** 成员来源类是否是Foundation框架的 */
@property (nonatomic, readonly, getter = isSrcClassFromFoundation) BOOL srcClassFromFoundation;
/** 成员来源于哪个对象 */
@property (nonatomic, weak, readonly) id srcObject;
/** 成员名 */
@property (nonatomic, copy, readonly) NSString *name;
/**
 *  初始化
 *  @param srcObject 来源于哪个对象
 *  @return 初始化好的对象
 */
- (instancetype)initWithSrcObject:(id)srcObject;
@end
@class WDType;
/**
 *  包装一个成员变量
 */
@interface WDIvar : WDMember
/** 成员变量 */
@property (nonatomic, assign) Ivar ivar;
/** 成员属性名 */
@property (nonatomic, copy, readonly) NSString *propertyName;
/** 成员变量的值 */
@property (nonatomic) id value;
/** 成员变量的类型 */
@property (nonatomic, strong, readonly) WDType *type;
/**
 *  @param ivar      成员变量
 *  @param srcObject 哪个对象的成员变量
 *  @return 初始化好的对象
 */
- (instancetype)initWithIvar:(Ivar)ivar srcObject:(id)srcObject;
@end
/**
 *  遍历成员变量用的block
 *  @param ivar 成员变量的包装对象
 *  @param stop       YES代表停止遍历，NO代表继续遍历
 */
typedef void (^WDIvarsBlock)(WDIvar *ivar, BOOL *stop);
/**
 *  包装一个方法
 */
@interface WDMethod : WDMember
/** 方法 */
@property (nonatomic, assign) Method method;
/** 方法名 */
@property (nonatomic, assign, readonly) SEL selector;
/** 所有的参数（都是WDArgument对象） */
@property (nonatomic, strong, readonly) NSArray *arguments;
/** 返回值类型 */
@property (nonatomic, copy, readonly) NSString *returnType;
/**
 *  初始化
 *  @param method    方法
 *  @param srcObject 哪个对象的方法
 *  @return 初始化好的对象
 */
- (instancetype)initWithMethod:(Method)method srcObject:(id)srcObject;
@end
/**
 *  遍历方法用的block
 *  @param method 方法的包装对象
 *  @param stop       YES代表停止遍历，NO代表继续遍历
 */
typedef void (^WDMethodsBlock)(WDMethod *method, BOOL *stop);
