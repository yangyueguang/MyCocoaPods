#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "WDMember.h"
#import "NSObject+Extention.h"
#import "JSONKit.h"

FOUNDATION_EXPORT double ObjectDictionaryVersionNumber;
FOUNDATION_EXPORT const unsigned char ObjectDictionaryVersionString[];

