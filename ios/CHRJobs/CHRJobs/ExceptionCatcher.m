#import "ExceptionCatcher.h"

@implementation ExceptionCatcher

+ (BOOL)run:(void (^)(void))block error:(NSError **)error {
    @try {
        block();
        return YES;
    } @catch (NSException *exception) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"CHRJobs"
                                         code:1
                                     userInfo:@{
                NSLocalizedDescriptionKey: exception.reason ?: @"Uncaught exception"
            }];
        }
        return NO;
    }
}

@end
