
#import "NSString+expanded.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString(expanded)

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
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@" "];
        
    } // while //
    
    return html;
    
}

-(NSString*)replaceControlString
{
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
-(NSString*)replaceStoreKey
{
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
-(NSString*)imagePathType:(imageType)__type
{
    if ((__type != imageSmallType && __type != imageBigType)) {
        return self;
    }else{
        return [self stringByReplacingOccurrencesOfString:@"/" withString:__type==imageSmallType?@"/s":@"/b" options:0 range:NSMakeRange(7, [self length]-7)];
    }
}
//- (CGFloat)getHeightByWidth:(NSInteger)_width font:(UIFont *)_font{
//     //!self不会调用，不用判断了
//   return [self sizeWithFont:_font constrainedToSize:CGSizeMake(_width, 1000) lineBreakMode:UILineBreakModeCharacterWrap].height;
//}

//- (NSString *)indentString:(NSString*)_string font:(UIFont *)_font
//{
//    if (!_string) {
//        return self;
//    }else{
//        CGSize  size=[_string sizeWithFont:_font];
//        NSLog(@"%f,%f",size.width/[@" " sizeWithFont:_font].width,[@" " sizeWithFont:_font].width);
//        return [NSString stringWithFormat:@"%@%@",[@"" stringByPaddingToLength:(size.width/[@"_" sizeWithFont:_font].width+2)*2 withString:@" " startingAtIndex:0],self];
//    }
//}

- (BOOL)notEmptyOrNull
{
    if ([self isEqualToString:@""]||[self isEqualToString:@"null"] || [self isEqualToString:@"\"\""] || [self isEqualToString:@"''"]) {
        return NO;
    }
    return YES;
}

+ (NSString *)replaceEmptyOrNull:(NSString *)checkString
{
    if (!checkString || [checkString isEqualToString:@""]||[checkString isEqualToString:@"null"]) {
        return @"";
    }
    return checkString;
}
-(NSString*)replaceTime
{
    NSString *tempStr = self;
    tempStr=[tempStr stringByReplacingOccurrencesOfString:@"-" withString:@"年" options:0 range:NSMakeRange(0, 5)];
    tempStr=[tempStr stringByReplacingOccurrencesOfString:@"-" withString:@"月"];
    tempStr=[tempStr stringByAppendingString:@"日"];
    return tempStr;
}

- (NSString*)soapMessage:(NSString *)key,...
{
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
	CC_MD5(concat_str, strlen(concat_str), result);
	NSMutableString *hash = [NSMutableString string];
	for (int i = 0; i < 16; i++){
		[hash appendFormat:@"%02X", result[i]];
	}
	return [hash lowercaseString];
	
}
+ (NSString *)UTF8StringWithHZGB2312Data:(NSData *)data
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [[NSString alloc] initWithData:data encoding:encoding];
}

- (NSString *)firstMatchWithPattern:(NSString *)pattern
{
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

- (NSArray *)matchesWithPattern:(NSString *)pattern
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators
                                  error:&error];
    
    if (error) {
        NSLog(@"匹配方案错误:%@", error.localizedDescription);
        return nil;
    }
    
    return [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
}

- (NSArray *)matchesWithPattern:(NSString *)pattern keys:(NSArray *)keys
{
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

-(NSDictionary*)tojsonDictionary{
    
    if (self == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
    
}
@end