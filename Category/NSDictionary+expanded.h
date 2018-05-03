//
//  NSDictionaryCategory.h
#import <Foundation/Foundation.h>
@interface NSDictionary (expanded)
- (id)objectForJSONKey:(id)aKey;
- (id)valueForJSONKey:(NSString *)key;
- (id)valueForJSONKeys:(NSString *)key,...NS_REQUIRES_NIL_TERMINATION;
- (void)setObjects:(id)objects forKey:(id)aKey;
+ (NSDictionary*)dictFromLocalJsonFileName:(NSString *)name;
- (NSString*)valueForJSONStrKey:(NSString *)key;
@end
