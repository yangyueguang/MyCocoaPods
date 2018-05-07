
#import "NSString+expanded.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString(expanded)
- (NSString*) urlEncodedString {
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    return [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
}
- (NSString*) urlDecodedString {
    return [self stringByRemovingPercentEncoding];
}
- (NSString*)encodeValue:(NSString*)value{
    NSString* encodedValue = value;
    if (value.length > 0) {
        NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"]invertedSet];
        encodedValue = [value stringByAddingPercentEncodingWithAllowedCharacters:set];
    }
    return encodedValue;
}
- (NSMutableDictionary *)getURLParameters {
    NSRange range = [self rangeOfString:@"?"];
    if (range.location == NSNotFound) {return nil;}
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    // 截取参数
    NSString *parametersString = [self substringFromIndex:range.location + 1];
    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            if (key == nil || value == nil) {continue;}
            id existValue = [params valueForKey:key];
            if (existValue != nil) {
                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    [params setValue:items forKey:key];
                } else {
                    [params setValue:@[existValue, value] forKey:key];
                }
            } else {
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数// 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        // 只有一个参数，没有值
        if (pairComponents.count == 1) {return nil;}
        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }   // 设置值
        [params setValue:value forKey:key];
    }
    return params;
}

- (NSString *)stringByReplaceHTML{
    NSScanner *theScanner;
    NSString *text = nil;
    NSString *html = self;
    theScanner = [NSScanner scannerWithString:html];
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
            [NSString stringWithFormat:@"%@>", text]withString:@" "];
    } // while //
    return html;
}
-(NSString*)replaceControlString{
    NSString *tempStr = self;
    tempStr=[tempStr stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    tempStr=[tempStr stringByReplacingOccurrencesOfString:@"\b" withString:@"\\b"];
    tempStr=[tempStr stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    tempStr=[tempStr stringByReplacingOccurrencesOfString:@"\r" withString:@"\\t"];
    tempStr=[tempStr stringByReplacingOccurrencesOfString:@"\t" withString:@"\\r"];
    tempStr=[tempStr stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    tempStr=[tempStr stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    return tempStr;
}
-(NSString*)replaceStoreKey{
    NSString *tempStr = self;
    NSRange range=[tempStr rangeOfString:@"user.lat="];
    if (range.length==0) {
        range=[tempStr rangeOfString:@"loc.latOffset="];
        if (range.length==0) {
            range=[tempStr rangeOfString:@"lat="];
            if (range.length!=0) {
                NSInteger l=[[tempStr substringFromIndex:[tempStr rangeOfString:@"lng="].location] rangeOfString:@"&"].location;
                range.length=[tempStr rangeOfString:@"lng="].location-range.location+l;
                tempStr=[tempStr stringByReplacingCharactersInRange:range withString:@""];
            }
        }else{
            NSInteger l=[[tempStr substringFromIndex:[tempStr rangeOfString:@"loc.lngOffset="].location] rangeOfString:@"&"].location;
            range.length=[tempStr rangeOfString:@"loc.lngOffset="].location-range.location+l;
            tempStr=[tempStr stringByReplacingCharactersInRange:range withString:@""];
        }
    }else{
        NSInteger l=[[tempStr substringFromIndex:[tempStr rangeOfString:@"user.lng="].location] rangeOfString:@"&"].location;
        range.length=[tempStr rangeOfString:@"user.lng="].location-range.location+l;
        tempStr=[tempStr stringByReplacingCharactersInRange:range withString:@""];
    }
    return tempStr;
}
//"upload/".length=7
-(NSString*)imagePathType:(imageType)__type{
    if ((__type != imageSmallType && __type != imageBigType)) {
        return self;
    }else{
        return [self stringByReplacingOccurrencesOfString:@"/" withString:__type==imageSmallType?@"/s":@"/b" options:0 range:NSMakeRange(7, [self length]-7)];
    }
}
//- (CGFloat)getHeightByWidth:(NSInteger)_width font:(UIFont *)_font{
//     //!self不会调用，不用判断了
//   return [self sizeOfFont:_font constrainedToSize:CGSizeMake(_width, 1000) lineBreakMode:UILineBreakModeCharacterWrap].height;
//}
//- (NSString *)indentString:(NSString*)_string font:(UIFont *)_font
//{
//    if (!_string) {
//        return self;
//    }else{
//        CGSize  size=[_string sizeOfFont:_font];
//        NSLog(@"%f,%f",size.width/[@" " sizeOfFont:_font].width,[@" " sizeOfFont:_font].width);
//        return [NSString stringWithFormat:@"%@%@",[@"" stringByPaddingToLength:(size.width/[@"_" sizeOfFont:_font].width+2)*2 withString:@" " startingAtIndex:0],self];
//    }
//}
- (NSString *)indentLength:(CGFloat)_len font:(UIFont *)_font{
    NSString *str=@"";
    CGFloat temp=0.0;
    while (temp<=_len) {
        str=[str stringByAppendingString:@" "];
        temp = [str sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_font,NSFontAttributeName, nil]].width;
    }
    return [NSString stringWithFormat:@"%@%@",str,self];
    //[@"" stringByPaddingToLength:(_len/[@"_" sizeOfFont:_font].width+1) withString:@"_" startingAtIndex:0]
}
- (BOOL)notEmptyOrNull{
    if ([self isEqualToString:@""]||[self isEqualToString:@"null"] || [self isEqualToString:@"\"\""] || [self isEqualToString:@"''"]) {
        return NO;
    }
    return YES;
}
+ (NSString *)replaceEmptyOrNull:(NSString *)checkString{
    if (!checkString || [checkString isEqualToString:@""]||[checkString isEqualToString:@"null"]) {
        return @"";
    }
    return checkString;
}
-(NSString*)replaceTime{
    NSString *tempStr = self;
    tempStr=[tempStr stringByReplacingOccurrencesOfString:@"-" withString:@"年" options:0 range:NSMakeRange(0, 5)];
    tempStr=[tempStr stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
    tempStr=[tempStr stringByAppendingString:@"日"];
    return tempStr;
}
- (NSString*)soapMessage:(NSString *)key,...{
    NSString *akey;
    va_list ap;
    va_start(ap, key);
    NSString *obj = nil;
    if (key) {
        if ([key rangeOfString:@"<"].length == 0)
            obj=[NSString stringWithFormat:@"<%@>%@</%@>",key,@"%@",key];
        else
            obj = key;
        
        while (obj&&(akey=va_arg(ap,id))) {
            if ([akey rangeOfString:@"<"].length == 0)
                obj=[obj stringByAppendingFormat:@"<%@>%@</%@>",akey,@"%@",akey];
            else
                obj = [obj stringByAppendingString:akey];
        }
        va_end(ap);
    }
    
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:soap=\"http://soap.csc.iofd.cn/\"> <soapenv:Header/> <soapenv:Body><soap:%@>%@</soap:%@></soapenv:Body></soapenv:Envelope>",self,obj?obj:@"",self];
}
- (NSString *)md5{
    const char *concat_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, (unsigned int)strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
    
}
#pragma mark 计算字符串大小
- (CGSize)sizeOfFont:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *dict = @{NSFontAttributeName: font};
    CGSize textSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return textSize;
}
- (NSString *) pinyin{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}
- (NSString *) pinyinInitial{
    if (self.length == 0) {
        return nil;
    }
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSArray *word = [str componentsSeparatedByString:@" "];
    NSMutableString *initial = [[NSMutableString alloc] initWithCapacity:str.length / 3];
    for (NSString *str in word) {
        [initial appendString:[str substringToIndex:1]];
    }
    
    return initial;
}
- (NSString *)urlEncode {
    return [self urlEncodeUsingEncoding:NSUTF8StringEncoding];
}
- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
    return [self urlEncodedString];
}
- (NSString *)urlDecode {
    return [self urlDecodeUsingEncoding:NSUTF8StringEncoding];
}
- (NSString *)urlDecodeUsingEncoding:(NSStringEncoding)encoding {
    return [self urlDecodedString];
}
- (NSDictionary *)dictionaryFromURLParameters{
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1] stringByRemovingPercentEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}
- (UIColor *) stringTOColor:(NSString *)str{
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}
+ (NSString *)emojiWithIntCode:(int)intCode {
    int symbol = ((((0x808080F0 | (intCode & 0x3F000) >> 4) | (intCode & 0xFC0) << 10) | (intCode & 0x1C0000) << 18) | (intCode & 0x3F) << 24);
    NSString *string = [[NSString alloc] initWithBytes:&symbol length:sizeof(symbol) encoding:NSUTF8StringEncoding];
    if (string == nil) { // 新版Emoji
        string = [NSString stringWithFormat:@"%C", (unichar)intCode];
    }
    return string;
}
- (NSString *)emoji{
    return [NSString emojiWithStringCode:self];
}
+ (NSString *)emojiWithStringCode:(NSString *)stringCode{
    char *charCode = (char *)stringCode.UTF8String;
    int intCode = (int)strtol(charCode, NULL, 16);
    return [self emojiWithIntCode:intCode];
}
// 判断是否是 emoji表情
- (BOOL)isEmoji{
    BOOL returnValue = NO;
    const unichar hs = [self characterAtIndex:0];
    // surrogate pair
    if (0xd800 <= hs && hs <= 0xdbff) {
        if (self.length > 1) {
            const unichar ls = [self characterAtIndex:1];
            const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
            if (0x1d000 <= uc && uc <= 0x1f77f) {
                returnValue = YES;
            }
        }
    } else if (self.length > 1) {
        const unichar ls = [self characterAtIndex:1];
        if (ls == 0x20e3) {
            returnValue = YES;
        }
    } else {
        // non surrogate
        if (0x2100 <= hs && hs <= 0x27ff) {
            returnValue = YES;
        } else if (0x2B05 <= hs && hs <= 0x2b07) {
            returnValue = YES;
        } else if (0x2934 <= hs && hs <= 0x2935) {
            returnValue = YES;
        } else if (0x3297 <= hs && hs <= 0x3299) {
            returnValue = YES;
        } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
            returnValue = YES;
        }
    }
    
    return returnValue;
}
- (CGSize)sizeOfFont:(UIFont *)font maxW:(CGFloat)maxW{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
- (CGSize)sizeOfFont:(UIFont *)font{
    return [self sizeOfFont:font maxW:MAXFLOAT];
}
-(NSString *)fileAppend:(NSString *)append{
    //1.1获得文件扩展名
    NSString *ext = [self pathExtension];
    //1.2删除最后面的扩展名
    NSString *imageName = [self stringByDeletingPathExtension];
    //1.3拼接append
    imageName = [imageName stringByAppendingString:append];
    //1.4拼接扩展名
    imageName = [imageName stringByAppendingPathExtension:ext];
    return imageName;
}

+(NSString *)stringWithDouble:(double)value decimalsCount:(int)decimalsCount{
    if (decimalsCount < 0) {
        return nil;
    }
    //生成格式字符串
    NSString *fmt = [NSString stringWithFormat:@"%%.%df", decimalsCount];
    //生成保留decimalsCount位小数的字符串
    NSString *str = [NSString stringWithFormat:fmt, value];
    //没有小数，直接返回
    if ([str rangeOfString:@"."].length == 0) {
        return str;
    }
    //从最后面往前找，不断删除最后面的0和最后一个“.”
    int index = (int)str.length - 1;
    unichar currentChar = [str characterAtIndex:index];
    for (; currentChar == '0' || currentChar == '.'; index--, currentChar = [str characterAtIndex:index]) {
        //裁减到“.”直接返回
        if (currentChar == '.') {
            return [str substringToIndex:index];
        }
    }
    str = [str substringToIndex:index + 1];
    return str;
}
+ (NSString *)UTF8StringWithHZGB2312Data:(NSData *)data{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [[NSString alloc] initWithData:data encoding:encoding];
}
- (NSString *)firstMatchWithPattern:(NSString *)pattern{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
 options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators
                                  error:&error];
    if (error) {
        NSLog(@"匹配方案错误:%@", error.localizedDescription);
        return nil;
    }
    NSTextCheckingResult *result = [regex firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    if (result) {
        NSRange r = [result rangeAtIndex:1];
        return [self substringWithRange:r];
    } else {
        NSLog(@"没有找到匹配内容 %@", pattern);
        return nil;
    }
}
- (NSArray *)matchesWithPattern:(NSString *)pattern{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
    options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:&error];
    if (error) {
        NSLog(@"匹配方案错误:%@", error.localizedDescription);
        return nil;
    }
    return [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
}
- (NSArray *)matchesWithPattern:(NSString *)pattern keys:(NSArray *)keys{
    NSArray *array = [self matchesWithPattern:pattern];
    if (array.count == 0) return nil;
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSTextCheckingResult *result in array) {
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        for (int i = 0; i < keys.count; i++) {
            NSRange r = [result rangeAtIndex:(i + 1)];
            [dictM setObject:[self substringWithRange:r] forKey:keys[i]];
        }
        [arrayM addObject:dictM];
    }
    return [arrayM copy];
}

-(NSMutableAttributedString*)attributeNumberWithFont:(UIFont*)font color:(UIColor*)color{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:self attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    for(int i =0; i < [self length];i++) {
        int a = [self characterAtIndex:i];
        if(isdigit(a)){
            [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:53/255.0 green:190/255.0 blue:131/255.0 alpha:1/1.0] range:NSMakeRange(i,1)];
        }
    }
    return AttributedStr;
}
-(NSMutableAttributedString*)attributeNumberWithBoldFontSize:(CGFloat)fontsize color:(UIColor*)color{
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:self attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize],NSForegroundColorAttributeName:color}];
    for(int i =0; i < [self length];i++) {
        int a = [self characterAtIndex:i];
        if(isdigit(a)){
            [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:33/255.0 green:34/255.0 blue:35/255.0 alpha:1] range:NSMakeRange(i,1)];
            [AttributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:fontsize+2] range:NSMakeRange(i, 1)];
        }
    }
    return AttributedStr;
}
-(NSString*)deleteSpace{
    NSMutableString *allStr = [self mutableCopy];
    CFStringTrimWhitespace((CFMutableStringRef)allStr);
    return allStr;
}
- (NSString* )extendName{
    NSArray* array = [self componentsSeparatedByString:@"."];
    return [array lastObject];
}
- (NSString *)gotHtml{
    NSURL *url = [NSURL URLWithString:[self urlEncodedString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:&error];
    if (error) {
        NSLog(@"%@",error.localizedDescription);
        return nil;
    }
    NSString *backStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return backStr;
}

@end

