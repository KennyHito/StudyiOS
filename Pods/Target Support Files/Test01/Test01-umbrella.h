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

#import "Test01.h"
#import "TestInject.h"

FOUNDATION_EXPORT double Test01VersionNumber;
FOUNDATION_EXPORT const unsigned char Test01VersionString[];

