#import <Foundation/Foundation.h>
@interface SDDataCache : NSObject {
    NSMutableDictionary *memCache;
    NSString *diskCachePath;
    NSOperationQueue *cacheInQueue, *cacheOutQueue;
}
+ (SDDataCache *)sharedDataCache;
- (void)storeData:(NSData *)aData forKey:(NSString *)key;
- (void)storeData:(NSData *)aData forKey:(NSString *)key toDisk:(BOOL)toDisk;//存储data
- (NSData *)dataFromKey:(NSString *)key;
- (NSData *)dataFromKey:(NSString *)key fromDisk:(BOOL)fromDisk;//得到指定的data
- (void)removeDataForKey:(NSString *)key;//移除指点的元素
- (void)clearMemory;//清理内存
- (void)clearDisk;//清理所有的缓存
- (void)cleanDisk;//清理过期的缓存
@end
