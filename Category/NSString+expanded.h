
//
typedef enum {
    imageSmallType,
    imageMiddlType,
    imageBigType,
}imageType;
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString(expanded)

- (NSString*)urlEncodedString;
- (NSString*)urlDecodedString;

- (NSString*)encodeValue:(NSString*)value;
- (NSMutableDictionary *)getURLParameters;
-(NSString*)replaceControlString;
-(NSString*)imagePathType:(imageType)__type;
//- (CGFloat)getHeightByWidth:(NSInteger)_width font:(UIFont *)_font;
//- (NSString *)indentString:(NSString*)_string font:(UIFont *)_font;
- (NSString *)indentLength:(CGFloat)_len font:(UIFont *)_font;
- (BOOL)notEmptyOrNull;
+ (NSString *)replaceEmptyOrNull:(NSString *)checkString;
-(NSString*)replaceTime;
-(NSString*)replaceStoreKey;
- (NSString*)soapMessage:(NSString *)key,...;
- (NSString *)md5;
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

- (NSString *) pinyin;
- (NSString *) pinyinInitial;
/**
 *  @brief  urlEncode
 *
 *  @return urlEncode 后的字符串
 */
- (NSString *)urlEncode;
/**
 *  @brief  urlEncode
 *
 *  @param encoding encoding模式
 *
 *  @return urlEncode 后的字符串
 */
- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
/**
 *  @brief  urlDecode
 *
 *  @return urlDecode 后的字符串
 */
- (NSString *)urlDecode;
/**
 *  @brief  urlDecode
 *
 *  @param encoding encoding模式
 *
 *  @return urlDecode 后的字符串
 */
- (NSString *)urlDecodeUsingEncoding:(NSStringEncoding)encoding;

/**
 *  @brief  url query转成NSDictionary
 *
 *  @return NSDictionary
 */
- (NSDictionary *)dictionaryFromURLParameters;

- (UIColor *) stringTOColor:(NSString *)str;
/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithIntCode:(int)intCode;

/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithStringCode:(NSString *)stringCode;
- (NSString *)emoji;

/**
 *  是否为emoji字符
 */

- (BOOL)isEmoji;

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font;

/**
 *  拼接文件名
 *
 */
-(NSString *)fileAppend:(NSString *)append;

/**
 *  生成一个保留decimalsCount位小数的字符串（裁减多余的0）
 *
 *  @param value         需要转成字符串的数
 *  @param decimalsCount 需要保留小数的位数
 *
 *  @return 保留decimalsCount位小数的字符串
 */
+(NSString *)stringWithDouble:(double)value decimalsCount:(int)decimalsCount;

- (NSAttributedString *)toMessageString;
/** 将GBK编码的二进制数据转换成字符串 */
+ (NSString *)UTF8StringWithHZGB2312Data:(NSData *)data;

/** 查找并返回第一个匹配的文本内容 */
- (NSString *)firstMatchWithPattern:(NSString *)pattern;

/** 查找多个匹配方案结果 */
- (NSArray *)matchesWithPattern:(NSString *)pattern;

/** 查找多个匹配方案结果，并根据键值数组生成对应的字典数组 */
- (NSArray *)matchesWithPattern:(NSString *)pattern keys:(NSArray *)keys;
-(NSMutableAttributedString*)attributeNumberWithFont:(UIFont*)font color:(UIColor*)color;
-(NSMutableAttributedString*)attributeNumberWithBoldFontSize:(CGFloat)fontsize color:(UIColor*)color;
@end
