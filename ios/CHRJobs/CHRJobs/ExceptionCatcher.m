#import "ExceptionCatcher.h"

@implementation ExceptionCatcher

+ (NSString *)runBlock:(void (^)(void))block {
    @try {
        block();
        return nil;
    } @catch (NSException *exception) {
        return exception.reason ?: @"Uncaught exception";
    }
}

@end
