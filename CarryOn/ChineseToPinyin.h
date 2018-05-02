//
//  ChineseToPinyin.h
#import <UIKit/UIKit.h>
@interface ChineseToPinyin : NSObject {
}
@property(strong,nonatomic)NSString *string;
@property(strong,nonatomic)NSString *pinYin;
//-----  返回tableview右方indexArray
+(NSMutableArray*)IndexArray:(NSArray*)stringArr;
//-----  返回联系人
+(NSMutableArray*)LetterSortArray:(NSArray*)stringArr;
//返回一组字母排序数组(中英混排)
+(NSMutableArray*)SortArray:(NSArray*)stringArr;
char pinyinFirstLetter(unsigned short hanzi);
+ (NSString *) pinyinFromChiniseString:(NSString *)string;
+ (NSString *) firstPinyinFromChinise:(NSString *)string;
+ (char) sortSectionTitle:(NSString *)string; 
@end
