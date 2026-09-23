#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExceptionCatcher : NSObject
/// Returns nil on success, or the exception reason if the block aborted.
+ (nullable NSString *)runBlock:(void (^)(void))block;
@end

NS_ASSUME_NONNULL_END
